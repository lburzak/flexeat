import 'dart:async';

import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/products_list_state.dart';
import 'package:flexeat/usecase/create_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  final LoadingCubit _loadingCubit;
  final NavigationCubit _navigationCubit;
  final CreateProduct _createProduct;
  late StreamSubscription<List<Product>> _productsSubscription;

  ProductsListCubit(ProductRepository productRepository, this._navigationCubit,
      this._loadingCubit, this._createProduct)
      : super(const ProductsListState()) {
    _productsSubscription =
        productRepository.watchAll().listen(_updateProducts);
  }

  void createProduct() {
    _createProduct(name: "Unnamed").then((productId) {
      _navigationCubit.navigateToProduct(id: productId);
    });
  }

  void _updateProducts(List<Product> products) {
    emit(state.copyWith(products: products));
  }

  @override
  Future<void> close() async {
    _productsSubscription.cancel();
    return super.close();
  }
}
