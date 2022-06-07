import 'dart:async';

import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/repository/nutrition_facts_repository.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final NutritionFactsRepository _nutritionFactsRepository;
  final LoadingCubit _loadingCubit;
  final int _productId;
  late StreamSubscription subscription;

  ProductCubit(this._productRepository, this._loadingCubit,
      this._nutritionFactsRepository,
      {required int productId})
      : _productId = productId,
        super(const ProductState()) {
    _fetchData();

    subscription = _nutritionFactsRepository
        .watchByProductId(productId)
        .listen((nutritionFacts) {
      emit(state.copyWith(nutritionFacts: nutritionFacts));
    });
  }

  @override
  Future<void> close() async {
    subscription.cancel();
    super.close();
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
}
