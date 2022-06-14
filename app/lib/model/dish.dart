import 'package:flexeat/domain/ingredient.dart';
import 'package:flexeat/domain/product_ingredient.dart';
import 'package:flexeat/model/recipe_header.dart';

class Dish {
  final RecipeHeader recipeHeader;
  final Map<Ingredient, ProductIngredient> ingredients;

  const Dish({
    this.recipeHeader = const RecipeHeader(),
    this.ingredients = const {},
  });
}
