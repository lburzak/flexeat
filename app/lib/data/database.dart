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
