import 'package:flexeat/model/product.dart';
import 'package:flexeat/repository/product_repository.dart';

class CreateProduct {
  final ProductRepository _productRepository;

  CreateProduct(this._productRepository);

  Future<int> call({required String name}) async {
    final product = Product(name: name);
    final createdProduct = await _productRepository.create(product);
    return createdProduct.id;
  }
}
