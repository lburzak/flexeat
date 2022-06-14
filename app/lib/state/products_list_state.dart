import '../model/product.dart';

class ProductsListState {
  final List<Product> products;

  const ProductsListState({
    this.products = const [],
  });

  ProductsListState copyWith({
    List<Product>? products,
  }) {
    return ProductsListState(
      products: products ?? this.products,
    );
  }
}
