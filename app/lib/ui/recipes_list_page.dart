import 'package:auto_route/auto_route.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/bloc/recipes_list_cubit.dart';
import 'package:flexeat/model/recipe_header.dart';
import 'package:flexeat/ui/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipesListPage extends StatelessWidget {
  const RecipesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesListCubit, List<RecipeHeader>>(
        builder: (context, state) => RecipesListView(recipes: state));
  }
}

class RecipesListView extends StatelessWidget {
  final List<RecipeHeader> recipes;

  const RecipesListView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listener: (context, state) {
        if (state is ToDishNavigationState) {
          print(context.router.stack.map((e) => e.name));
          context.router.push(DishRoute(recipeId: state.recipeId));
        }
      },
      child: Scaffold(
        body: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) => RecipesListRow(
            recipe: recipes[index],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => context.read<RecipesListCubit>().add(),
        ),
      ),
    );
  }
}

class RecipesListRow extends StatelessWidget {
  final RecipeHeader recipe;

  const RecipesListRow({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.read<RecipesListCubit>().openRecipe(recipe.id),
      title: Text(recipe.name),
    );
  }
}
