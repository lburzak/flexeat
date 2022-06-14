import 'package:flexeat/model/article.dart';
import 'package:flexeat/model/dish.dart';
import 'package:flexeat/model/ingredient.dart';
import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/model/product.dart';
import 'package:flexeat/model/product_ingredient.dart';
import 'package:flutter/material.dart';

class DishPage extends StatelessWidget {
  const DishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DishView(
        dish: Dish(ingredients: {
      const Ingredient(weight: 300, article: Article(name: "Ogórek")):
          const ProductIngredient(
              packaging: Packaging(weight: 300, label: "ok"),
              product: Product(name: "Plaki"))
    }));
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
          Text(dish.recipeHeader.name),
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
