import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final LoadingCubit _loadingCubit;

  ProductCubit(this._productRepository, this._loadingCubit,
      {required int productId})
      : super(const ProductState()) {
    _fetchData(productId);
  }

  Future<void> _fetchData(int productId) async {
    final product =
        await _productRepository.findById(productId).listenIn(_loadingCubit);
    emit(ProductState(productName: product.name, id: product.id));
  }

  void save() {
    if (_loadingCubit.state == true) {
      return;
    }

    if (state.id == null) {
      _productRepository
          .create(Product(name: state.productName))
          .listenIn(_loadingCubit)
          .then((product) {
        emit(state.copyWith(id: product.id));
      });
      return;
    }

    _productRepository
        .update(Product(id: state.id!, name: state.productName))
        .listenIn(_loadingCubit);
  }

  void setName(String text) {
    emit(state.copyWith(productName: text));
  }
}
