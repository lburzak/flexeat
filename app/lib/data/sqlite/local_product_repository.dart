import 'dart:async';

import 'package:flexeat/data/event/live_repository.dart';
import 'package:flexeat/data/sqlite/database.dart';
import 'package:flexeat/data/sqlite/row.dart';
import 'package:flexeat/domain/model/product.dart';
import 'package:flexeat/domain/repository/product_repository.dart';
import 'package:sqflite/sqflite.dart';

const productTable = 'product';
const nameColumn = 'name';
const idColumn = 'id';

enum _DataEvent { productCreated, productChanged, productRemoved }

class LocalProductRepository
    with LiveRepository<_DataEvent>
    implements ProductRepository {
  final Database _database;

  LocalProductRepository(this._database);

  @override
  Future<Product> create(Product product) async {
    if (product.id != 0) {
      throw UnimplementedError("Creating products with ID not supported.");
    }

    final productId = await _database.insert(productTable, _serialize(product));

    emit(_DataEvent.productCreated);

    return product.copyWith(id: productId);
  }

  @override
  Future<List<Product>> findAll() async {
    final rows = await _database.query(productTable);
    final products =
        rows.map((row) => _deserialize(row)).toList(growable: false);
    return products;
  }

  @override
  Future<Product> findById(int id) async {
    final rows = await _database
        .query(productTable, where: '$idColumn = ?', whereArgs: [id]);
    return _deserialize(rows.first);
  }

  @override
  Future<void> update(Product product) async {
    await _database.update(productTable, _serialize(product),
        where: '$idColumn = ?', whereArgs: [product.id]);

    emit(_DataEvent.productChanged);
  }

  @override
  Stream<List<Product>> watchAll() async* {
    final applicableEvents = [
      _DataEvent.productCreated,
      _DataEvent.productChanged,
      _DataEvent.productRemoved
    ];

    yield await findAll();
    yield* dataEvents
        .where((event) => applicableEvents.contains(event))
        .asyncMap((event) => findAll());
  }

  @override
  Future<void> removeById(int productId) async {
    await _database
        .delete(product$, where: "${product$id} = ?", whereArgs: [productId]);
    emit(_DataEvent.productRemoved);
  }

  Row _serialize(Product product) {
    return {
      idColumn: product.id > 0 ? product.id : null,
      nameColumn: product.name
    };
  }

  Product _deserialize(Row row) {
    return row.toProduct();
  }
}

extension ProductSerialization on Row {
  Product toProduct() => Product(id: this[idColumn], name: this[nameColumn]);
}
