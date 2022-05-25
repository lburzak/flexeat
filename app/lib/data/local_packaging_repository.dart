import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:sqflite/sqflite.dart';

class LocalPackagingRepository implements PackagingRepository {
  final Database _database;

  LocalPackagingRepository(this._database);

  @override
  Future<Packaging> create(int productId, Packaging packaging) async {
    if (packaging.id != 0) {
      throw UnimplementedError("Creating packagings with ID not supported.");
    }

    final id = await _database.insert('packaging', {
      'product_id': productId,
      'label': packaging.label,
      'weight': packaging.weight
    });

    return packaging.copyWith(id: id);
  }

  @override
  Future<List<Packaging>> findAllByProductId(int productId) {
    // TODO: implement findAllByProductId
    throw UnimplementedError();
  }
}
