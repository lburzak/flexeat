import 'package:flexeat/data/live_repository.dart';
import 'package:flexeat/data/row.dart';
import 'package:flexeat/domain/recipe.dart';
import 'package:flexeat/repository/recipe_repository.dart';
import 'package:sqflite/sqflite.dart';

enum DataEvent { created }

const recipe$ = "recipe";
const recipe$name = "name";
const recipe$id = "id";

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
