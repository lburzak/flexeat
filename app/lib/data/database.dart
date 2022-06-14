import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

Future<sqflite.Database> openDatabase() async {
  final databasesPath = await sqflite.getDatabasesPath();
  final path = join(databasesPath, 'flexeat.db');
  return sqflite.openDatabase(path, version: 1, onCreate: _initDatabase);
}

Future<void> _initDatabase(sqflite.Database db, int version) async {
  await db.transaction((txn) async {
    await txn.execute(createProductTable);
    await txn.execute(createPackagingTable);
    await txn.execute(createNutritionFactsTable);
    await txn.execute(createArticlesTable);
    await txn.execute(createProductArticleTable);
    await txn.execute(createRecipeTable);
    await txn.execute(createIngredientTable);
  });
}

const createProductTable = """
CREATE TABLE product (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);
""";

const createPackagingTable = """
CREATE TABLE packaging (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  weight INTEGER NOT NULL,
  label TEXT,
  FOREIGN KEY (product_id) REFERENCES product(id)
);
""";

const createNutritionFactsTable = """
CREATE TABLE nutrition_facts (
  product_id INTEGER PRIMARY KEY,
  energy REAL,
  fat REAL,
  carbohydrates REAL,
  fibre REAL,
  protein REAL,
  salt REAL,
  FOREIGN KEY (product_id) REFERENCES product(id)
);
""";

const article$ = "article";
const article$id = "id";
const createArticlesTable = """
CREATE TABLE ${article$} (
  ${article$id} INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);
""";

const createProductArticleTable = """
CREATE TABLE product_article(
  product_id INTEGER,
  article_id INTEGER,
  FOREIGN KEY (product_id) REFERENCES product(id),
  FOREIGN KEY (article_id) REFERENCES article(id),
  PRIMARY KEY (product_id, article_id)
);
""";

const recipe$ = "recipe";
const recipe$id = "id";
const recipe$name = "name";
const createRecipeTable = """
CREATE TABLE ${recipe$} (
  ${recipe$id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${recipe$name} TEXT NOT NULL,
);
""";

const ingredient$ = "ingredient";
const ingredient$recipeId = "recipe_id";
const ingredient$articleId = "article_id";
const ingredient$weight = "weight";
const createIngredientTable = """
CRATE TABLE ${ingredient$} (
  ${ingredient$recipeId} INTEGER NOT NULL,
  ${ingredient$articleId} INTEGER NOT NULL,
  ${ingredient$weight} INTEGER,
  FOREIGN KEY (${ingredient$recipeId}) REFERENCES ${recipe$}(${recipe$id}),
  FOREIGN KEY (${ingredient$articleId}) REFERENCES ${article$}(${article$id}),
  PRIMARY KEY (${ingredient$recipeId}, ${ingredient$articleId})
);
""";
