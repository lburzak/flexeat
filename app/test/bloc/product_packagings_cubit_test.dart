import 'dart:async';

import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util/prepared_completer.dart';
import 'product_packagings_cubit_test.mocks.dart';

@GenerateMocks([PackagingRepository, ProductCubit])
void main() {
  late ProductPackagingsCubit cubit;
  late MockPackagingRepository packagingRepository;
  late PreparedCompleter<List<Packaging>> dataCompleter;
  late PreparedCompleter<Packaging> createCompleter;
  late MockProductCubit productCubit;

  const packaging = Packaging(weight: 300, label: "Box");
  const existingPackagings = [Packaging(weight: 200, label: "Plate")];
  const productId = 5;

  final createdPackaging = packaging.copyWith(id: 18);
  late StreamController<ProductState> productStateStream;

  setUp(() {
    packagingRepository = MockPackagingRepository();
    productCubit = MockProductCubit();
    productStateStream = StreamController(sync: true);

    when(productCubit.stream).thenAnswer((_) => productStateStream.stream);

    dataCompleter = when(packagingRepository.findAllByProductId(productId))
        .thenReturnCompleter(existingPackagings);

    createCompleter = when(packagingRepository.create(productId, any))
        .thenReturnCompleter(createdPackaging);

    cubit = ProductPackagingsCubit(packagingRepository, productCubit);
  });

  group('before product is set', () {
    test('is initialized with empty list', () {
      expect(cubit.state.packagings, isEmpty);
    });

    test('.addPackaging() throws StateError', () {
      expect(() {
        cubit.addPackaging(packaging);
      }, throwsStateError);
    });
  });

  test('populates packagings list when product id changed', () async {
    productStateStream.add(const ProductState(id: productId));
    await dataCompleter.ensureComplete();
    expect(cubit.state.packagings, containsAll(existingPackagings));
  });

  group('after product is set', () {
    setUp(() {
      productStateStream.add(const ProductState(id: productId));
    });

    test('.addPackaging() updates packagings list', () async {
      cubit.addPackaging(packaging);
      await createCompleter.ensureComplete();
      expect(cubit.state.packagings, contains(createdPackaging));
    });

    test('.addPackaging() adds packaging to repository', () {
      cubit.addPackaging(packaging);
      verify(packagingRepository.create(productId, packaging));
    });
  });
}
