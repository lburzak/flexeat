import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/model/product.dart';

class ProductPackaging {
  final Product product;
  final Packaging packaging;

  const ProductPackaging({
    required this.product,
    required this.packaging,
  });
}
