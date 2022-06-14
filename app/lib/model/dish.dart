import 'package:flexeat/model/ingredient.dart';
import 'package:flexeat/model/product_ingredient.dart';
import 'package:flexeat/model/recipe_header.dart';

class Dish {
  final RecipeHeader recipeHeader;
  final Map<Ingredient, ProductIngredient> ingredients;

  const Dish({
    this.recipeHeader = const RecipeHeader(),
    this.ingredients = const {},
  });
}
