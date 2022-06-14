import 'package:flexeat/model/nutrition_facts.dart';
import 'package:meta/meta.dart';

import '../model/article.dart';

@immutable
class ProductState {
  final String productName;
  final int? id;
  final NutritionFacts nutritionFacts;
  final List<Article> compatibleArticles;
  final List<Article> availableArticles;

  const ProductState(
      {this.productName = "",
      this.id,
      this.nutritionFacts = const NutritionFacts(),
      this.compatibleArticles = const [],
      this.availableArticles = const []});

  ProductState copyWith({
    String? productName,
    int? id,
    NutritionFacts? nutritionFacts,
    List<Article>? compatibleArticles,
    List<Article>? availableArticles,
  }) {
    return ProductState(
      productName: productName ?? this.productName,
      id: id ?? this.id,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      compatibleArticles: compatibleArticles ?? this.compatibleArticles,
      availableArticles: availableArticles ?? this.availableArticles,
    );
  }
}
