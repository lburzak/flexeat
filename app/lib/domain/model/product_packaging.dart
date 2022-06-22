import 'nutrition_facts.dart';
import 'packaging.dart';
import 'product.dart';

class ProductPackaging {
  final Product product;
  final Packaging packaging;
  final NutritionFacts nutritionFacts;

  const ProductPackaging(
      {required this.product,
      required this.packaging,
      required this.nutritionFacts});
}
