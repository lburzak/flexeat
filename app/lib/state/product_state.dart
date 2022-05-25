import 'package:flexeat/domain/nutrition_facts.dart';
import 'package:meta/meta.dart';

@immutable
class ProductState {
  final String productName;
  final NutritionFacts? nutritionFacts;
  final List<String> compatibleArticles;

  const ProductState(
      {this.productName = "",
      this.nutritionFacts,
      this.compatibleArticles = const []});

  ProductState copyWith(
      {String? productName,
      NutritionFacts? nutritionFacts,
      List<String>? compatibleArticles}) {
    return ProductState(
        productName: productName ?? this.productName,
        nutritionFacts: nutritionFacts ?? this.nutritionFacts,
        compatibleArticles: compatibleArticles ?? this.compatibleArticles);
  }
}
