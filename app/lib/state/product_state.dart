import 'package:flexeat/domain/nutrition_facts.dart';
import 'package:meta/meta.dart';

@immutable
class ProductState {
  final String productName;
  final int? id;
  final NutritionFacts nutritionFacts;
  final List<String> compatibleArticles;

  const ProductState(
      {this.productName = "",
      this.id,
      this.nutritionFacts = const NutritionFacts(),
      this.compatibleArticles = const []});

  ProductState copyWith({
    String? productName,
    int? id,
    NutritionFacts? nutritionFacts,
    List<String>? compatibleArticles,
  }) {
    return ProductState(
      productName: productName ?? this.productName,
      id: id ?? this.id,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      compatibleArticles: compatibleArticles ?? this.compatibleArticles,
    );
  }
}
