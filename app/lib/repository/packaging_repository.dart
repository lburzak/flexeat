import 'package:flexeat/model/packaging.dart';

abstract class PackagingRepository {
  Future<List<Packaging>> findAllByProductId(int productId);
  Future<Packaging> create(int productId, Packaging packaging);
}
