import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/model/product.dart';

class ProductIngredient {
  final Product product;
  final Packaging packaging;

  const ProductIngredient({
    this.product = const Product(),
    this.packaging = const Packaging(),
  });
}
