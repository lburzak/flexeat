import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util/prepared_completer.dart';
import 'product_packagings_cubit_test.mocks.dart';

@GenerateMocks([PackagingRepository])
void main() {
  late ProductPackagingsCubit cubit;
  late MockPackagingRepository packagingRepository;
  late PreparedCompleter<List<Packaging>> dataCompleter;
  late PreparedCompleter<Packaging> createCompleter;

  const packaging = Packaging(weight: 300, label: "Box");
  const existingPackagings = [Packaging(weight: 200, label: "Plate")];
  const productId = 5;

  final createdPackaging = packaging.copyWith(id: 18);

  setUp(() {
    packagingRepository = MockPackagingRepository();

    dataCompleter = when(packagingRepository.findAllByProductId(productId))
        .thenReturnCompleter(existingPackagings);

    createCompleter = when(packagingRepository.create(productId, any))
        .thenReturnCompleter(createdPackaging);

    cubit = ProductPackagingsCubit(packagingRepository);
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

  test('.setProductId() populates packagings list', () async {
    cubit.setProductId(productId);
    await dataCompleter.ensureComplete();
    expect(cubit.state.packagings, containsAll(existingPackagings));
  });

  group('after product is set', () {
    setUp(() {
      cubit.setProductId(productId);
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

    test('setProductId() fetches product packagings', () async {
      cubit.setProductId(productId);
      await dataCompleter.ensureComplete();
      expect(cubit.state.packagings, containsAll(existingPackagings));
    });
  });
}
