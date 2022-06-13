import 'package:flutter/material.dart';

import '../domain/recipe.dart';

class RecipesListPage extends StatelessWidget {
  const RecipesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RecipesListPage();
  }
}

class RecipesListView extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipesListView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) => RecipesListRow(
        recipe: recipes[index],
      ),
    );
  }
}

class RecipesListRow extends StatelessWidget {
  final Recipe recipe;

  const RecipesListRow({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recipe.name),
    );
  }
}
