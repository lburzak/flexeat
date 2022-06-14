import 'package:flexeat/domain/recipe.dart';

abstract class RecipeRepository {
  Future<int> create(String name);

  Stream<List<Recipe>> watchAll();

  Stream<Recipe?> watchById(int id);

  Future<void> updateNameById(int id, {required String name});

  Future<void> addIngredientById(int id,
      {required int articleId, required int weight});
}
