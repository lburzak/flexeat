import 'dart:async';

import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_cubit_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late ProductCubit cubit;
  late MockProductRepository productRepository;

  const name = "Test name";

  setUp(() {
    productRepository = MockProductRepository();
  });

  group('when productId is null', () {
    late Completer<Product> saveCompleter;
    setUp(() {
      cubit = ProductCubit(productRepository);
      saveCompleter = Completer<Product>();

      when(productRepository
              .create(argThat(equals(const Product(id: 0, name: name)))))
          .thenAnswer((_) async => saveCompleter.future);
      cubit.setName(name);
    });

    test(".save() creates new product", () {
      cubit.save();
      verify(productRepository.create(const Product(id: 0, name: name)));
    });

    test(".save() changes loading properly", () async {
      expect(cubit.state.loading, isFalse);
      cubit.save();
      expect(cubit.state.loading, isTrue);
      saveCompleter.complete(const Product(id: 1, name: name));
      await saveCompleter.future;
      expect(cubit.state.loading, isFalse);
    });

    test(".save() after saving does not create new product", () async {
      cubit.save();
      saveCompleter.complete(const Product(id: 1, name: name));
      await saveCompleter.future;
      cubit.save();
      verify(productRepository.create(const Product(id: 0, name: name)))
          .called(1);
    });

    test(".save() when loading does not create new product", () {
      cubit.save();
      expect(cubit.state.loading, isTrue);
      verify(productRepository.create(const Product(id: 0, name: name)))
          .called(1);
    });
  });

  group('when productId is not null', () {
    late Completer<Product> dataCompleter;
    late Completer<void> updateCompleter;
    const existingProduct = Product(id: 5, name: "Some product");

    setUp(() {
      dataCompleter = Completer();
      updateCompleter = Completer();

      when(productRepository.findById(existingProduct.id))
          .thenAnswer((_) async => dataCompleter.future);

      when(productRepository.update(any))
          .thenAnswer((_) async => updateCompleter.future);

      cubit = ProductCubit(productRepository, productId: existingProduct.id);
    });

    test('data fetching properly handles loading', () async {
      expect(cubit.state.loading, isTrue);
      dataCompleter.complete(existingProduct);
      await dataCompleter.future;
      expect(cubit.state.loading, isFalse);
    });

    group('after data is fetched', () {
      setUp(() async {
        dataCompleter.complete(existingProduct);
        await dataCompleter.future;
      });

      test('state is fetched from repository', () async {
        expect(cubit.state.productName, equals(existingProduct.name));
      });

      test('.save() updates existing product', () async {
        const updatedName = "Updated name";
        cubit.setName(updatedName);
        cubit.save();
        verify(productRepository
            .update(Product(id: existingProduct.id, name: updatedName)));
      });

      test('.save() properly changes loading', () async {
        expect(cubit.state.loading, isFalse);
        cubit.save();
        expect(cubit.state.loading, isTrue);
        updateCompleter.complete();
        await updateCompleter.future;
        expect(cubit.state.loading, isFalse);
      });

      const weight = 300;
      const label = "Box";
      const packaging = Packaging(weight: weight, label: label);

      test('.addPackaging() updates packagings list', () async {
        cubit.addPackaging(weight, label);
        expect(cubit.state.packagings, contains(packaging));
      });

      test('.addPackaging() updates product in repository', () async {
        cubit.addPackaging(weight, label);
        const expectedPackagings = [packaging];
        verify(productRepository.update(argThat(
            equals(existingProduct.copyWith(packagings: expectedPackagings)))));
      });

      test('.addPackaging() handles loading state properly', () async {
        cubit.addPackaging(weight, label);
        expect(cubit.state.loading, isTrue);
        updateCompleter.complete();
        await updateCompleter.future;
        expect(cubit.state.loading, isFalse);
      });
    });
  });

  test(".setName() changes name", () {
    cubit.setName(name);
    expect(name, equals(name));
  });
}
