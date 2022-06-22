import 'package:flexeat/domain/model/packaging.dart';
import 'package:flexeat/domain/model/product.dart';
import 'package:flexeat/domain/model/product_packaging.dart';

abstract class PackagingRepository {
  Future<List<Packaging>> findAllByProductId(int productId);
  Future<Packaging?> findById(int packagingId);
  Future<Product?> findProductByPackagingId(int packagingId);
  Future<List<ProductPackaging>> findProductPackagingsByArticleId(
      int articleId);
  Future<Packaging> create(int productId, Packaging packaging);
}
