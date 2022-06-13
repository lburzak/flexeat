import 'package:flexeat/domain/recipe.dart';

abstract class RecipeRepository {
  Future<int> create(String name);
  Stream<List<Recipe>> findAll();
}
