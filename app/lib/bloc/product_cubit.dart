import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductCubit extends Cubit<ProductState> {
  int? _productId;
  final ProductRepository _productRepository;
  final LoadingCubit _loadingCubit;

  ProductCubit(this._productRepository, this._loadingCubit, {int? productId})
      : _productId = productId,
        super(const ProductState()) {
    if (_productId != null) {
      _fetchData().listenIn(_loadingCubit);
    }
  }

  Future<void> _fetchData() async {
    if (_productId == null) {
      throw StateError("Product ID is null, cannot fetch");
    }

    final product = await _productRepository.findById(_productId!);
    emit(ProductState(productName: product.name));
  }

  void save() {
    if (_loadingCubit.state == true) {
      return;
    }

    if (_productId == null) {
      _productRepository
          .create(Product(name: state.productName))
          .listenIn(_loadingCubit)
          .then((product) {
        _productId = product.id;
      });
      return;
    }

    _productRepository
        .update(Product(id: _productId!, name: state.productName))
        .listenIn(_loadingCubit);
  }

  void setName(String text) {
    emit(state.copyWith(productName: text));
  }
}
