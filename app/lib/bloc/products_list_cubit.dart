import 'dart:async';

import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/bloc/state/products_list_state.dart';
import 'package:flexeat/domain/model/product.dart';
import 'package:flexeat/domain/repository/product_repository.dart';
import 'package:flexeat/domain/usecase/create_product.dart';
import 'package:flexeat/domain/usecase/create_product_from_ean.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  final LoadingCubit _loadingCubit;
  final NavigationCubit _navigationCubit;
  final CreateProduct _createProduct;
  late StreamSubscription<List<Product>> _productsSubscription;
  final CreateProductFromEan _createProductFromEan;

  ProductsListCubit(ProductRepository productRepository, this._navigationCubit,
      this._loadingCubit, this._createProduct, this._createProductFromEan)
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

  void createProductFromEan(String code) {
    _createProductFromEan(code).listenIn(_loadingCubit);
  }
}
