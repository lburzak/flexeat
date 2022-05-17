import 'package:flexeat/domain/product.dart';
import 'package:flexeat/repository/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  Iterable<Product> products = [];
  int lastId = 0;

  @override
  Future<Product> create(Product product) async {
    final newProduct = product.copyWith(id: ++lastId);
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
  Future<void> update(Product product) async {
    final productsWithoutProduct =
        products.where((element) => element.id != product.id);
    productsWithoutProduct.followedBy([product]);
  }
}
