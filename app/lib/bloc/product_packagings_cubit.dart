import 'package:bloc/bloc.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/state/product_packagings_state.dart';

class ProductPackagingsCubit extends Cubit<ProductPackagingsState> {
  final PackagingRepository _packagingRepository;

  ProductPackagingsCubit(PackagingRepository packagingRepository, int productId)
      : _packagingRepository = packagingRepository,
        super(const ProductPackagingsState()) {
    packagingRepository.findAllByProductId(productId).then(_updatePackagings);
  }

  void addPackaging(Packaging packaging) {
    _packagingRepository.create(packaging).then(_insertPackaging);
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
