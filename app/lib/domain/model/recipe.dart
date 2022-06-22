import 'ingredient.dart';
import 'recipe_header.dart';

class Recipe {
  final RecipeHeader header;
  final List<Ingredient> ingredients;

  const Recipe({
    this.header = const RecipeHeader(),
    this.ingredients = const [],
  });
}
