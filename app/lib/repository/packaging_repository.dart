import 'package:flexeat/domain/packaging.dart';

abstract class PackagingRepository {
  Future<List<Packaging>> findAllByProductId(int productId);
  Future<Packaging> create(Packaging packaging);
}
