import 'package:flexeat/domain/product_ingredient.dart';

import 'ingredient.dart';

class Recipe {
  final String name;
  final Map<Ingredient, ProductIngredient> ingredients;

  const Recipe({this.name = "", this.ingredients = const {}});
}
