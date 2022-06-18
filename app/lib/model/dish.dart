import 'package:flexeat/model/ingredient.dart';
import 'package:flexeat/model/product_packaging.dart';
import 'package:flexeat/model/recipe_header.dart';

class Dish {
  final RecipeHeader recipeHeader;
  final Map<Ingredient, ProductPackaging?> ingredients;

  const Dish({
    this.recipeHeader = const RecipeHeader(),
    this.ingredients = const {},
  });

  Dish copyWith({
    RecipeHeader? recipeHeader,
    Map<Ingredient, ProductPackaging?>? ingredients,
  }) {
    return Dish(
      recipeHeader: recipeHeader ?? this.recipeHeader,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
