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

const product$ = "product";
const product$id = "id";
const product$name = "name";
const createProductTable = """
CREATE TABLE ${product$} (
  ${product$id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${product$name} TEXT NOT NULL
);
""";

const packaging$ = "packaging";
const packaging$id = "id";
const packaging$productId = "product_id";
const packaging$weight = "weight";
const packaging$label = "label";
const createPackagingTable = """
CREATE TABLE ${packaging$} (
  ${packaging$id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${packaging$productId} INTEGER NOT NULL,
  ${packaging$weight} INTEGER NOT NULL,
  ${packaging$label} TEXT,
  FOREIGN KEY (${packaging$productId}) REFERENCES ${product$}(${product$id})
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
const article$name = "name";
const createArticlesTable = """
CREATE TABLE ${article$} (
  ${article$id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${article$name} TEXT NOT NULL
);
""";

const productArticle$ = "product_article";
const productArticle$productId = "product_id";
const productArticle$articleId = "article_id";
const createProductArticleTable = """
CREATE TABLE ${productArticle$}(
  ${productArticle$productId} INTEGER,
  ${productArticle$articleId} INTEGER,
  FOREIGN KEY (${productArticle$productId}) REFERENCES ${product$}(${product$id}),
  FOREIGN KEY (${productArticle$articleId}) REFERENCES ${article$}(${article$id}),
  PRIMARY KEY (${productArticle$productId}, ${productArticle$articleId})
);
""";

const recipe$ = "recipe";
const recipe$id = "id";
const recipe$name = "name";
const createRecipeTable = """
CREATE TABLE ${recipe$} (
  ${recipe$id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${recipe$name} TEXT NOT NULL
);
""";

const ingredient$ = "ingredient";
const ingredient$recipeId = "recipe_id";
const ingredient$articleId = "article_id";
const ingredient$weight = "weight";
const createIngredientTable = """
CREATE TABLE ${ingredient$} (
  ${ingredient$recipeId} INTEGER NOT NULL,
  ${ingredient$articleId} INTEGER NOT NULL,
  ${ingredient$weight} INTEGER,
  FOREIGN KEY (${ingredient$recipeId}) REFERENCES ${recipe$}(${recipe$id}),
  FOREIGN KEY (${ingredient$articleId}) REFERENCES ${article$}(${article$id}),
  PRIMARY KEY (${ingredient$recipeId}, ${ingredient$articleId})
);
""";
