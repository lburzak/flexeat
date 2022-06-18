import 'package:flexeat/model/ingredient.dart';
import 'package:flexeat/model/nutrition_facts.dart';
import 'package:flexeat/model/product_packaging.dart';
import 'package:flexeat/model/recipe_header.dart';

class Dish {
  final RecipeHeader recipeHeader;
  final Map<Ingredient, ProductPackaging?> ingredients;
  final NutritionFacts nutritionFacts;

  const Dish(
      {this.recipeHeader = const RecipeHeader(),
      this.ingredients = const {},
      this.nutritionFacts = const NutritionFacts()});

  Dish copyWith({
    RecipeHeader? recipeHeader,
    Map<Ingredient, ProductPackaging?>? ingredients,
    NutritionFacts? nutritionFacts,
  }) {
    return Dish(
      recipeHeader: recipeHeader ?? this.recipeHeader,
      ingredients: ingredients ?? this.ingredients,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
    );
  }
}
