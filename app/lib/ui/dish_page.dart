import 'package:flexeat/bloc/dish_cubit.dart';
import 'package:flexeat/model/dish.dart';
import 'package:flexeat/model/ingredient.dart';
import 'package:flexeat/model/product_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'editable_header.dart';

class DishPage extends StatelessWidget {
  final int recipeId;

  const DishPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => context.read<Factory<DishCubit, int>>()(recipeId),
        child: BlocBuilder<DishCubit, Dish>(
          builder: (context, state) => DishView(dish: state),
        ));
  }
}

class DishView extends StatelessWidget {
  final Dish dish;

  const DishView({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = dish.ingredients.entries.toList();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: EditableHeader(
              initialText: context.select<DishCubit, String>(
                  (cubit) => cubit.state.recipeHeader.name),
              onSubmit: (text) => context.read<DishCubit>().changeName(text),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) => IngredientView(
                    ingredient: entries[index].key,
                    productIngredient: entries[index].value)),
          ),
        ],
      ),
    );
  }
}

class IngredientView extends StatelessWidget {
  final Ingredient ingredient;
  final ProductIngredient? productIngredient;

  const IngredientView(
      {Key? key, required this.ingredient, this.productIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!,
        child: Column(
          children: [
            Row(
              children: [
                Text(ingredient.article.name),
                Text("${ingredient.weight} g")
              ],
            ),
            productIngredient != null
                ? ProductIngredientView(productIngredient: productIngredient!)
                : ElevatedButton(onPressed: () {}, child: const Text("SELECT"))
          ],
        ),
      ),
    );
  }
}

class ProductIngredientView extends StatelessWidget {
  final ProductIngredient productIngredient;

  const ProductIngredientView({Key? key, required this.productIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Text(productIngredient.product.name),
          Text("${productIngredient.packaging.weight} g")
        ],
      ),
    );
  }
}
