import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util/prepared_completer.dart';
import 'packages_cubit_test.mocks.dart';

@GenerateMocks([PackagingRepository])
void main() {
  late ProductPackagingsCubit cubit;
  late MockPackagingRepository packagingRepository;
  late PreparedCompleter<List<Packaging>> dataCompleter;
  late PreparedCompleter<Packaging> createCompleter;

  const packaging = Packaging(weight: 300, label: "Box");
  const initialPackagings = [Packaging(weight: 200, label: "Plate")];
  const productId = 5;

  final createdPackaging = packaging.copyWith(id: 18);

  setUp(() {
    packagingRepository = MockPackagingRepository();

    dataCompleter = when(packagingRepository.findAllByProductId(productId))
        .thenReturnCompleter(initialPackagings);

    createCompleter = when(packagingRepository.create(any))
        .thenReturnCompleter(createdPackaging);

    cubit = ProductPackagingsCubit(packagingRepository, productId);
  });

  test('.addPackaging() updates packagings list', () async {
    cubit.addPackaging(packaging);
    await createCompleter.ensureComplete();
    expect(cubit.state.packagings, contains(createdPackaging));
  });

  test('.addPackaging() adds packaging to repository', () {
    cubit.addPackaging(packaging);
    verify(packagingRepository.create(packaging));
  });

  test('fetches product packagings', () async {
    await dataCompleter.ensureComplete();
    expect(cubit.state.packagings, containsAll(initialPackagings));
  });
}
