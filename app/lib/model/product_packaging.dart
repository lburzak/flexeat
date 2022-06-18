import 'package:flexeat/model/nutrition_facts.dart';
import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/model/product.dart';

class ProductPackaging {
  final Product product;
  final Packaging packaging;
  final NutritionFacts nutritionFacts;

  const ProductPackaging(
      {required this.product,
      required this.packaging,
      required this.nutritionFacts});
}
