import 'package:flexeat/domain/model/packaging.dart';
import 'package:flexeat/domain/model/product.dart';
import 'package:flexeat/domain/repository/article_repository.dart';
import 'package:flexeat/domain/repository/food_repository.dart';
import 'package:flexeat/domain/repository/nutrition_facts_repository.dart';
import 'package:flexeat/domain/repository/packaging_repository.dart';
import 'package:flexeat/domain/repository/product_repository.dart';

class CreateProductFromEan {
  final ProductRepository _productRepository;
  final NutritionFactsRepository _nutritionFactsRepository;
  final PackagingRepository _packagingRepository;
  final ArticleRepository _articleRepository;
  final FoodRepository _foodRepository;

  CreateProductFromEan(
      this._productRepository,
      this._foodRepository,
      this._nutritionFactsRepository,
      this._packagingRepository,
      this._articleRepository);

  Future<int?> call(String code) async {
    final result = await _foodRepository.findProductByEan(code);

    if (result == null) {
      return null;
    }

    final product = Product(name: "${result.name} ${result.genericName}");
    final createdProduct = await _productRepository.create(product);
    _nutritionFactsRepository.updateByProductId(
        createdProduct.id, result.nutritionFacts);
    if (result.quantity != null) {
      _packagingRepository.create(
          createdProduct.id,
          Packaging(
            label: result.packaging,
            weight: result.quantity!,
          ));
    }
    for (final category in result.categories) {
      final articleId = await _articleRepository.create(category);
      _articleRepository.linkToProduct(articleId, createdProduct.id);
    }

    return createdProduct.id;
  }
}
