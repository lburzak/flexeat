import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductCubit extends Cubit<ProductState> {
  int? _productId;
  final ProductRepository _productRepository;

  ProductCubit(this._productRepository, {int? productId})
      : _productId = productId,
        super(const ProductState()) {
    if (_productId != null) {
      emit(state.copyWith(loading: true));
      _fetchData().then((_) => emit(state.copyWith(loading: false)));
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
    if (_productId == null) {
      emit(state.copyWith(loading: true));
      _productRepository
          .create(Product(id: 0, name: state.productName))
          .then((product) {
        _productId = product.id;
        emit(state.copyWith(loading: false));
      });
      return;
    }

    emit(state.copyWith(loading: true));
    _productRepository
        .update(Product(id: _productId!, name: state.productName))
        .then((_) => emit(state.copyWith(loading: false)));
  }

  void reportPrice(int price) {}

  void addPackaging(int weight) {}

  void setName(String text) {
    emit(state.copyWith(productName: text));
  }
}
