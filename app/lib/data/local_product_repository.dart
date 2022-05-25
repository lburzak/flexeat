import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:sqflite/sqflite.dart';

const productTable = 'products';
const nameColumn = 'name';
const idColumn = 'id';

class LocalProductRepository implements ProductRepository {
  final Database database;

  LocalProductRepository(this.database);

  @override
  Future<Product> create(Product product) async {
    if (product.id != 0) {
      throw UnimplementedError("Creating products with ID not supported.");
    }

    return await database.transaction((txn) async {
      final productId =
          await txn.insert(productTable, {nameColumn: product.name});

      return product.copyWith(id: productId);
    });
  }

  @override
  Future<List<Product>> findAll() async {
    final rows = await database.query(productTable);
    final products =
        rows.map((row) => _deserialize(row)).toList(growable: false);
    return products;
  }

  @override
  Future<Product> findById(int id) async {
    final rows = await database
        .query(productTable, where: '$idColumn = ?', whereArgs: [id]);
    return _deserialize(rows.first);
  }

  @override
  Future<void> update(Product product) async {
    await database.update(productTable, _serialize(product));
  }

  Map<String, dynamic> _serialize(Product product) {
    return {idColumn: product.id, nameColumn: product.name};
  }

  Product _deserialize(Map<String, dynamic> row) {
    return Product(id: row[idColumn], name: row[nameColumn]);
  }
}
