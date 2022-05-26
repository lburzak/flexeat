import 'package:flexeat/data/row.dart';
import 'package:flexeat/domain/packaging.dart';
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
