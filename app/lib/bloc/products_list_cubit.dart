import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/products_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  final LoadingCubit _loadingCubit;

  ProductsListCubit(
      ProductRepository productRepository, LoadingCubit loadingCubit)
      : _loadingCubit = loadingCubit,
        super(const ProductsListState()) {
    productRepository.findAll().listenIn(_loadingCubit).then(_updateProducts);
  }

  void _updateProducts(List<Product> products) {
    emit(state.copyWith(products: products));
  }
}
