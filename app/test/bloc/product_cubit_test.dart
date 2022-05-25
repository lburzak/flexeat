import 'dart:async';

import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_cubit_test.mocks.dart';

@GenerateMocks([ProductRepository, LoadingCubit])
void main() {
  late ProductCubit cubit;
  late MockProductRepository productRepository;
  late LoadingCubit loadingCubit;

  const name = "Test name";
  const weight = 300;
  const label = "Box";
  const packaging = Packaging(weight: weight, label: label);

  setUp(() {
    productRepository = MockProductRepository();
  });

  group('when productId is null', () {
    late Completer<Product> saveCompleter;
    setUp(() {
      loadingCubit = MockLoadingCubit();
      cubit = ProductCubit(productRepository, loadingCubit);
      saveCompleter = Completer<Product>();

      when(productRepository
              .create(argThat(equals(const Product(id: 0, name: name)))))
          .thenAnswer((_) async => saveCompleter.future);
      when(productRepository.update(any))
          .thenAnswer((_) async => const Product(id: 1, name: name));
      when(productRepository.create(argThat(equals(
              const Product(id: 0, name: name, packagings: [packaging])))))
          .thenAnswer((_) async => saveCompleter.future);
      cubit.setName(name);
    });

    test(".save() creates new product", () {
      cubit.save();
      verify(productRepository.create(const Product(id: 0, name: name)));
    });

    test(".save() changes loading properly", () async {
      expect(loadingCubit.state, isFalse);
      cubit.save();
      expect(loadingCubit.state, isTrue);
      saveCompleter.complete(const Product(id: 1, name: name));
      await saveCompleter.future;
      expect(loadingCubit.state, isFalse);
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
      expect(loadingCubit.state, isTrue);
      verify(productRepository.create(const Product(id: 0, name: name)))
          .called(1);
    });

    test('.addPackaging() updates packagings list', () async {
      cubit.addPackaging(weight, label);
      expect(cubit.state.packagings, contains(packaging));
    });

    test('.addPackaging() does not update product in repository', () async {
      cubit.addPackaging(weight, label);
      verifyNever(productRepository.update(any));
    });

    test('.save() updates packagings list', () async {
      cubit.addPackaging(weight, label);
      cubit.save();
      final packagingInDb = packaging.copyWith(id: 1);
      saveCompleter
          .complete(Product(id: 1, name: name, packagings: [packagingInDb]));
      await saveCompleter.future;
      expect(cubit.state.packagings, contains(packagingInDb));
    });
  });

  group('when productId is not null', () {
    late Completer<Product> dataCompleter;
    late Completer<Product> updateCompleter;
    const existingProduct = Product(id: 1, name: "Some product");
    const newPackaging = Packaging(weight: weight, label: label);
    const packagingFromRepository =
        Packaging(id: 1, weight: weight, label: label);
    const updatedName = "Updated name";
    final updatedProduct = existingProduct
        .copyWith(name: updatedName, packagings: [packagingFromRepository]);

    setUp(() {
      dataCompleter = Completer();
      updateCompleter = Completer();

      when(productRepository.findById(existingProduct.id))
          .thenAnswer((_) async => dataCompleter.future);

      when(productRepository.update(any))
          .thenAnswer((_) async => updateCompleter.future);

      cubit = ProductCubit(productRepository, loadingCubit,
          productId: existingProduct.id);
    });

    test('data fetching properly handles loading', () async {
      expect(loadingCubit.state, isTrue);
      dataCompleter.complete(existingProduct);
      await dataCompleter.future;
      expect(loadingCubit.state, isFalse);
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
        cubit.setName(updatedName);
        cubit.save();
        verify(productRepository
            .update(existingProduct.copyWith(name: updatedName)));
      });

      test('.save() properly changes loading', () async {
        expect(loadingCubit.state, isFalse);
        cubit.save();
        expect(loadingCubit.state, isTrue);
        updateCompleter.complete(updatedProduct);
        await updateCompleter.future;
        expect(loadingCubit.state, isFalse);
      });

      test('.addPackaging() updates packagings list', () async {
        cubit.addPackaging(weight, label);
        expect(cubit.state.packagings, contains(packaging));
      });

      test('.addPackaging() updates product in repository', () async {
        cubit.addPackaging(newPackaging.weight, newPackaging.label);
        verify(productRepository.update(argThat(
            equals(existingProduct.copyWith(packagings: [newPackaging])))));
      });

      test('.addPackaging() handles loading state properly', () async {
        cubit.addPackaging(weight, label);
        expect(loadingCubit.state, isTrue);
        updateCompleter.complete(updatedProduct);
        await updateCompleter.future;
        expect(loadingCubit.state, isFalse);
      });

      test('.addPackaging() updates packages list', () async {
        cubit.addPackaging(weight, label);
        updateCompleter.complete(updatedProduct);
        await updateCompleter.future;
        expect(cubit.state.packagings, contains(packagingFromRepository));
      });
    });
  });

  test(".setName() changes name", () {
    cubit.setName(name);
    expect(name, equals(name));
  });
}
