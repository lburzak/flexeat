import 'package:bloc/bloc.dart';
import 'package:flexeat/domain/model/packaging.dart';
import 'package:flexeat/domain/repository/packaging_repository.dart';
import 'package:flexeat/state/product_packagings_state.dart';

class ProductPackagingsCubit extends Cubit<ProductPackagingsState> {
  final PackagingRepository _packagingRepository;
  final int _productId;

  ProductPackagingsCubit(this._packagingRepository, this._productId)
      : super(const ProductPackagingsState()) {
    _packagingRepository.findAllByProductId(_productId).then(_updatePackagings);
  }

  void addPackaging(Packaging packaging) {
    _packagingRepository.create(_productId, packaging).then(_insertPackaging);
  }

  void _insertPackaging(Packaging packaging) {
    final packagings = List<Packaging>.from(state.packagings);
    packagings.add(packaging);

    emit(state.copyWith(packagings: packagings));
  }

  void _updatePackagings(List<Packaging> packagings) {
    emit(state.copyWith(packagings: packagings));
  }
}
