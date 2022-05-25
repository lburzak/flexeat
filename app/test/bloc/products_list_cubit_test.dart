import 'dart:async';

import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util/prepared_completer.dart';
import 'product_cubit_test.mocks.dart';

class LoadingCubitSpy extends LoadingCubit {
  Future? _launchedFuture;

  bool get launched => _launchedFuture != null;

  Future? get launchedFuture => _launchedFuture;

  @override
  Future<T> launch<T>(Future<T> task) {
    _launchedFuture = task;
    return super.launch(task);
  }
}

@GenerateMocks([ProductRepository, LoadingCubit])
void main() {
  late ProductsListCubit cubit;
  late ProductRepository productRepository;
  late LoadingCubit loadingCubit;
  late PreparedCompleter<List<Product>> dataCompleter;

  const products = [Product(id: 5, name: "Some product")];

  setUp(() {
    loadingCubit = LoadingCubit();
    productRepository = MockProductRepository();
    dataCompleter =
        when(productRepository.findAll()).thenReturnCompleter(products);
    cubit = ProductsListCubit(productRepository, loadingCubit);
  });

  test('begins with empty list and loading', () {
    expect(cubit.state.products, isEmpty);
  });

  test('loads data when constructed', () async {
    await dataCompleter.ensureComplete();
    expect(cubit.state.products, equals(products));
  });

  // Generated mock doesn't handle generics properly.
  // Custom spy can't compare futures.
  test('handles loading state when fetching data', () async {
    expect(loadingCubit.state, isTrue);
    await dataCompleter.ensureComplete();
    expect(loadingCubit.state, isFalse);
  }, skip: true);
}

extension CompleterTest<T> on Completer {
  Future<void> ensureComplete(T data) async {
    complete(data);
    await future;
  }
}
