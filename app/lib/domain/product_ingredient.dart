import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/domain/product.dart';

class ProductIngredient {
  final Product product;
  final Packaging packaging;

  const ProductIngredient({
    this.product = const Product(),
    this.packaging = const Packaging(),
  });
}
