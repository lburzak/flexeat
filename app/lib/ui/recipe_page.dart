import 'package:flexeat/domain/article.dart';
import 'package:flexeat/domain/ingredient.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/domain/product_ingredient.dart';
import 'package:flexeat/domain/recipe.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecipeView(
        recipe: Recipe(name: "Working", ingredients: {
      const Ingredient(weight: 300, article: Article(name: "Ogórek")):
          const ProductIngredient(
              packaging: Packaging(weight: 300, label: "ok"),
              product: Product(name: "Plaki"))
    }));
  }
}

class RecipeView extends StatelessWidget {
  final Recipe recipe;

  const RecipeView({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entries = recipe.ingredients.entries.toList();
    return Scaffold(
      body: Column(
        children: [
          Text(recipe.name),
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
  final ProductIngredient productIngredient;

  const IngredientView(
      {Key? key, required this.ingredient, required this.productIngredient})
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
            ProductIngredientView(productIngredient: productIngredient)
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
