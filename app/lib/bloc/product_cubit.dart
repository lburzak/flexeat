import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/packaging.dart';
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
        emit(state.copyWith(loading: false, packagings: product.packagings));
      });
      return;
    }

    emit(state.copyWith(loading: true));
    _productRepository
        .update(Product(id: _productId!, name: state.productName))
        .then((_) => emit(state.copyWith(loading: false)));
  }

  void reportPrice(int price) {}

  void addPackaging(int weight, String label) {
    final packaging = Packaging(weight: weight, label: label);

    final List<Packaging> packagings = List.from(state.packagings);
    packagings.add(packaging);

    if (_productId != null) {
      final product = Product(
          id: _productId!, name: state.productName, packagings: packagings);

      emit(state.copyWith(loading: true));
      _productRepository.update(product).then((product) {
        emit(state.copyWith(loading: false, packagings: product.packagings));
      });
    }

    emit(state.copyWith(packagings: packagings));
  }

  void setName(String text) {
    emit(state.copyWith(productName: text));
  }
}
