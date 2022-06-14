import 'ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final List<Ingredient> ingredients;

  const Recipe({this.name = "", this.ingredients = const [], this.id = 0});
}
