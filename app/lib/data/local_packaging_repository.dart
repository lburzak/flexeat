import 'package:flexeat/data/database.dart';
import 'package:flexeat/data/local_product_repository.dart';
import 'package:flexeat/data/row.dart';
import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/model/product.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:sqflite/sqflite.dart';

const packagingTable = 'packaging';
const idColumn = 'id';
const productIdColumn = 'product_id';
const labelColumn = 'label';
const weightColumn = 'weight';

class LocalPackagingRepository implements PackagingRepository {
  final Database _database;

  LocalPackagingRepository(this._database);

  @override
  Future<Packaging> create(int productId, Packaging packaging) async {
    if (packaging.id != 0) {
      throw UnimplementedError("Creating packagings with ID not supported.");
    }

    final id = await _database.insert(
        packagingTable, _serialize(packaging, productId: productId));

    return packaging.copyWith(id: id);
  }

  @override
  Future<List<Packaging>> findAllByProductId(int productId) async {
    final rows = await _database.query(packagingTable,
        where: '$productIdColumn = ?', whereArgs: [productId]);
    final packagings = rows.map((row) => _deserialize(row));
    return packagings.toList(growable: false);
  }

  @override
  Future<Product?> findProductByPackagingId(int packagingId) async {
    final rows = await _database.rawQuery("""
    SELECT *
    FROM ${packaging$} INNER JOIN ${product$}
      ON ${packaging$}.${packaging$productId} = ${product$}.${product$id}
    WHERE ${packaging$}.${packaging$id} = ?
    """, [packagingId]);

    if (rows.isEmpty) {
      return null;
    }

    return rows.first.toProduct();
  }

  @override
  Future<Packaging?> findById(int packagingId) async {
    final rows = await _database.query(packagingTable,
        where: "$idColumn = ?", whereArgs: [packagingId]);

    if (rows.isEmpty) {
      return null;
    }

    return _deserialize(rows.first);
  }

  Row _serialize(Packaging packaging, {required int productId}) {
    return {
      productIdColumn: productId,
      labelColumn: packaging.label,
      weightColumn: packaging.weight
    };
  }

  Packaging _deserialize(Row row) {
    return Packaging(
        id: row[idColumn], weight: row[weightColumn], label: row[labelColumn]);
  }
}
