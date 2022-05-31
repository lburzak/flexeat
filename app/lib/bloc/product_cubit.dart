import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final LoadingCubit _loadingCubit;
  final int _productId;

  ProductCubit(this._productRepository, this._loadingCubit,
      {required int productId})
      : _productId = productId,
        super(const ProductState()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final product =
        await _productRepository.findById(_productId).listenIn(_loadingCubit);
    emit(ProductState(productName: product.name, id: product.id));
  }

  void save() {
    if (_loadingCubit.state == true) {
      return;
    }

    _productRepository
        .update(Product(id: _productId, name: state.productName))
        .listenIn(_loadingCubit);
  }

  void setName(String text) {
    emit(state.copyWith(productName: text));
  }

  void changeName(String name) {}
}
