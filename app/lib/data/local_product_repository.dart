import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:sqflite/sqflite.dart';

class LocalProductRepository implements ProductRepository {
  final Database database;

  LocalProductRepository(this.database);

  @override
  Future<Product> create(Product product) async {
    if (product.id != 0) {
      throw UnimplementedError("Creating products with ID not supported.");
    }

    return await database.transaction((txn) async {
      final productId = await txn.insert('product', {'name': product.name});

      final packagings = await Future.wait(product.packagings.map(
          (packaging) => createPackagingForProduct(txn, packaging, productId)));

      return product.copyWith(id: productId, packagings: packagings);
    });
  }

  Future<Packaging> createPackagingForProduct(
      Transaction txn, Packaging packaging, int productId) async {
    if (packaging.id != 0) {
      throw UnimplementedError("Creating packagings with ID not supported.");
    }

    final id = await txn.insert('packaging', {
      'product_id': productId,
      'label': packaging.label,
      'weight': packaging.weight
    });

    return packaging.copyWith(id: id);
  }

  @override
  Future<List<Product>> findAll() async {
    // TODO: implement findById
    throw UnimplementedError();
  }

  @override
  Future<Product> findById(int id) {
    // TODO: implement findById
    throw UnimplementedError();
  }

  @override
  Future<Product> update(Product product) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
