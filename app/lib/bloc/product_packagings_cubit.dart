import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/state/product_packagings_state.dart';
import 'package:flexeat/state/product_state.dart';

class ProductPackagingsCubit extends Cubit<ProductPackagingsState> {
  final PackagingRepository _packagingRepository;
  late StreamSubscription<ProductState> productStateSubscription;
  int? _productId;

  ProductPackagingsCubit(
      PackagingRepository packagingRepository, ProductCubit productCubit)
      : _packagingRepository = packagingRepository,
        super(const ProductPackagingsState()) {
    _productId = productCubit.state.id;
    productStateSubscription = productCubit.stream.listen((state) {
      if (state.id != null && _productId != state.id) {
        _setProductId(state.id!);
      }
    });
  }

  @override
  Future<void> close() async {
    productStateSubscription.cancel();
    return super.close();
  }

  void addPackaging(Packaging packaging) {
    if (_productId == null) {
      throw StateError("Product not set");
    }

    _packagingRepository.create(_productId!, packaging).then(_insertPackaging);
  }

  void _insertPackaging(Packaging packaging) {
    final packagings = List<Packaging>.from(state.packagings);
    packagings.add(packaging);

    emit(state.copyWith(packagings: packagings));
  }

  void _updatePackagings(List<Packaging> packagings) {
    emit(state.copyWith(packagings: packagings));
  }

  void _setProductId(int productId) {
    _productId = productId;
    _packagingRepository.findAllByProductId(productId).then(_updatePackagings);
  }
}
