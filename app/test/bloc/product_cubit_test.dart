import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/model/product.dart';
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

  const product = Product(id: 1, name: "Some product");
  final updatedProduct = product.copyWith(name: "Updated name");

  setUp(() {
    productRepository = MockProductRepository();
    loadingCubit = LoadingCubit();

    dataCompleter =
        when(productRepository.findByPackagingId(argThat(equals(product.id))))
            .thenReturnCompleter(product);

    when(productRepository.update(argThat(equals(updatedProduct))))
        .thenAnswer((_) async => updatedProduct);
  });

  setUp(() async {
    cubit =
        ProductCubit(productRepository, loadingCubit, productId: product.id);
    await dataCompleter.ensureComplete();
  });

  test('state is fetched from repository', () async {
    expect(cubit.state.productName, equals(product.name));
  });

  test('.save() updates existing product', () async {
    cubit.setName(updatedProduct.name);
    cubit.save();
    verify(productRepository.update(updatedProduct));
  });

  test(".setName() changes name", () {
    const name = "new name";
    cubit.setName(name);
    expect(cubit.state.productName, equals(name));
  });
}
