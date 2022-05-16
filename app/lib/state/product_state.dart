import 'package:flexeat/domain/nutrition_facts.dart';
import 'package:flexeat/state/packaging_stats.dart';
import 'package:meta/meta.dart';


@immutable
class ProductState {
  final String productName;
  final NutritionFacts? nutritionFacts;
  final List<String> compatibleArticles;
  final List<PackagingStats> packagings;

  const ProductState({
    this.productName = "",
    this.nutritionFacts,
    this.compatibleArticles = const [],
    this.packagings = const [],
  });

  ProductState copyWith({
    String? productName,
    NutritionFacts? nutritionFacts,
    List<String>? compatibleArticles,
    List<PackagingStats>? packagings,
  }) {
    return ProductState(
      productName: productName ?? this.productName,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      compatibleArticles: compatibleArticles ?? this.compatibleArticles,
      packagings: packagings ?? this.packagings,
    );
  }
}