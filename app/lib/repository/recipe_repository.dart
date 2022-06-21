import 'package:flexeat/model/recipe.dart';
import 'package:flexeat/model/recipe_header.dart';

abstract class RecipeRepository {
  Future<int> create(String name);

  Stream<List<RecipeHeader>> watchAllHeaders();

  Stream<Recipe?> watchById(int id);

  Future<void> updateNameById(int id, {required String name});

  Future<void> addIngredientById(int id,
      {required int articleId, required int weight});

  Future<void> removeById(int recipeId);
}
