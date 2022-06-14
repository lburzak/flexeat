import 'package:flexeat/data/live_repository.dart';
import 'package:flexeat/data/row.dart';
import 'package:flexeat/domain/recipe.dart';
import 'package:flexeat/repository/recipe_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';

enum DataEvent { created }

class LocalRecipeRepository
    with LiveRepository<DataEvent>
    implements RecipeRepository {
  final Database _database;

  LocalRecipeRepository(this._database);

  @override
  Future<int> create(String name) async {
    final recipe = Recipe(name: name);
    final id = _database.insert(recipe$, recipe.serialize());

    emit(DataEvent.created);

    return id;
  }

  Future<List<Recipe>> findAll() async {
    final rows = await _database.query(recipe$);
    return rows.map((recipe) => recipe.toRecipe()).toList();
  }

  @override
  Stream<List<Recipe>> watchAll() async* {
    yield await findAll();
    yield* dataEvents
        .where((event) => event == DataEvent.created)
        .asyncMap((event) => findAll());
  }

  Future<Recipe?> findById(int id) async {
    final rows = await _database
        .query(recipe$, where: "${recipe$id} = ?", whereArgs: [id]);

    if (rows.isEmpty) {
      return null;
    }

    return rows.first.toRecipe();
  }

  @override
  Stream<Recipe?> watchById(int id) async* {
    yield await findById(id);

    yield* dataEvents.asyncMap((event) => findById(id));
  }

  @override
  Future<void> updateNameById(int id, {required String name}) async {
    await _database.update(recipe$, {recipe$name: name},
        where: "${recipe$id} = ?", whereArgs: [id]);
  }

  @override
  Future<void> addIngredientById(int id,
      {required int articleId, required int weight}) async {
    await _database.insert(ingredient$, {
      ingredient$articleId: articleId,
      ingredient$recipeId: id,
      ingredient$weight: weight
    });
  }
}

extension Serialization on Recipe {
  Row serialize() {
    final Row row = {recipe$name: name};

    if (id != 0) {
      row[recipe$id] = id;
    }

    return row;
  }
}

extension ToRecipe on Row {
  Recipe toRecipe() => Recipe(id: this[recipe$id], name: this[recipe$name]);
}
