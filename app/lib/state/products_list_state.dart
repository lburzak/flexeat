import '../domain/product.dart';

class ProductsListState {
  final bool loading;
  final List<Product> products;

  const ProductsListState({
    this.loading = false,
    this.products = const [],
  });

  ProductsListState copyWith({
    bool? loading,
    List<Product>? products,
  }) {
    return ProductsListState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
    );
  }
}
