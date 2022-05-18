import 'dart:async';

import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_cubit_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late ProductsListCubit cubit;
  late ProductRepository productRepository;
  late Completer<List<Product>> dataCompleter;

  const products = [Product(id: 5, name: "Some product")];

  setUp(() {
    productRepository = MockProductRepository();
    dataCompleter = Completer();
    when(productRepository.findAll())
        .thenAnswer((_) async => dataCompleter.future);
    cubit = ProductsListCubit(productRepository);
  });

  test('begins with empty list and loading', () {
    expect(cubit.state.products, isEmpty);
  });

  test('loads data when constructed', () async {
    await dataCompleter.ensureComplete(products);
    expect(cubit.state.products, equals(products));
  });

  test('handles loading state when fetching data', () async {
    expect(cubit.state.loading, isTrue);
    await dataCompleter.ensureComplete(products);
    expect(cubit.state.loading, isFalse);
  });
}

extension CompleterTest<T> on Completer {
  Future<void> ensureComplete(T data) async {
    complete(data);
    await future;
  }
}
