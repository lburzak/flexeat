import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';

import '../domain/packaging.dart';

class InMemoryProductRepository implements ProductRepository {
  Iterable<Product> products = [];
  int lastId = 0;
  int lastPackagingId = 0;

  @override
  Future<Product> create(Product product) async {
    final newProduct = product.copyWith(
        id: ++lastId, packagings: _inflatedPackagings(product.packagings));
    products = products.followedBy([newProduct]);
    return newProduct;
  }

  @override
  Future<Product> findById(int id) async {
    final Product existingProduct =
        products.firstWhere((element) => element.id == id);

    return existingProduct;
  }

  @override
  Future<Product> update(Product product) async {
    final productsWithoutProduct =
        products.where((element) => element.id != product.id);
    final newProduct =
        product.copyWith(packagings: _inflatedPackagings(product.packagings));
    products = productsWithoutProduct.followedBy([newProduct]);
    return newProduct;
  }

  List<Packaging> _inflatedPackagings(List<Packaging> packagings) {
    return packagings
        .map((e) => e.copyWith(id: e.id == 0 ? ++lastPackagingId : e.id))
        .toList(growable: false);
  }

  @override
  Future<List<Product>> findAll() async {
    return [const Product(id: 12, name: "First")];
  }
}
