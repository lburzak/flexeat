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
  });
}

const createProductTable = """
CREATE TABLE product (
  id INT PRIMARY KEY,
  name TEXT NOT NULL
);
""";

const createPackagingTable = """
CREATE TABLE packaging (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  weight INT NOT NULL,
  label TEXT,
  FOREIGN KEY (product_id) REFERENCES product(id)
);
""";
