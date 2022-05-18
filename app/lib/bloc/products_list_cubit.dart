import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/products_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit(ProductRepository productRepository)
      : super(const ProductsListState()) {
    emit(state.copyWith(loading: true));
    productRepository.findAll().then(
        (products) => emit(state.copyWith(products: products, loading: false)));
  }
}
