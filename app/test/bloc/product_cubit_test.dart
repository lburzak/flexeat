import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util/prepared_completer.dart';
import 'product_cubit_test.mocks.dart';

@GenerateMocks([ProductRepository, ProductPackagingsCubit])
void main() {
  late ProductCubit cubit;
  late MockProductRepository productRepository;
  late LoadingCubit loadingCubit;
  late PreparedCompleter<Product> dataCompleter;

  const product = Product(id: 0, name: "Test name");
  const existingProduct = Product(id: 1, name: "Some product");

  final createdProduct = product.copyWith(id: 4);

  setUp(() {
    productRepository = MockProductRepository();
    loadingCubit = LoadingCubit();
    cubit = ProductCubit(productRepository, loadingCubit);

    dataCompleter = when(productRepository.findById(existingProduct.id))
        .thenReturnCompleter(existingProduct);
  });

  group('when productId is null', () {
    late PreparedCompleter<Product> createCompleter;
    setUp(() {
      createCompleter = when(productRepository.create(argThat(equals(product))))
          .thenReturnCompleter(createdProduct);

      when(productRepository.update(any))
          .thenAnswer((_) async => createdProduct);

      cubit.setName(product.name);
    });

    test(".save() creates new product", () {
      cubit.save();
      verify(productRepository.create(product));
    });

    test(".save() after saving does not create new product", () async {
      cubit.save();
      await createCompleter.ensureComplete();
      cubit.save();
      verify(productRepository.create(product)).called(1);
    });

    test(".save() when loading does not create new product", () {
      cubit.save();
      cubit.save();
      verify(productRepository.create(product)).called(1);
    });
  });

  group('when productId is not null', () {
    const updatedName = "Updated name";
    final updatedProduct = existingProduct.copyWith(name: updatedName);

    setUp(() {
      when(productRepository.update(argThat(equals(updatedProduct))))
          .thenAnswer((_) async => updatedProduct);

      cubit.setProductId(existingProduct.id);
    });

    group('after data is fetched', () {
      setUp(() async {
        await dataCompleter.ensureComplete();
      });

      test('state is fetched from repository', () async {
        expect(cubit.state.productName, equals(existingProduct.name));
      });

      test('.save() updates existing product', () async {
        cubit.setName(updatedName);
        cubit.save();
        verify(productRepository
            .update(existingProduct.copyWith(name: updatedName)));
      });
    });
  });

  test(".setProductId() populates selected product data", () async {
    cubit.setProductId(existingProduct.id);
    await dataCompleter.ensureComplete();
    expect(cubit.state.productName, equals(existingProduct.name));
  });

  test(".setName() changes name", () {
    const name = "new name";
    cubit.setName(name);
    expect(cubit.state.productName, equals(name));
  });
}
