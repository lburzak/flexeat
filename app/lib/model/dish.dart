import 'package:flexeat/domain/ingredient.dart';
import 'package:flexeat/domain/product_ingredient.dart';
import 'package:flexeat/domain/recipe.dart';

class Dish {
  final Recipe recipe;
  final Map<Ingredient, ProductIngredient> ingredients;

  const Dish({
    this.recipe = const Recipe(),
    this.ingredients = const {},
  });
}
