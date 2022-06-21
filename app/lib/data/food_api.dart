import 'package:dio/dio.dart';
import 'package:flexeat/model/nutrition_facts.dart';

class FoodResult {
  final List<String> categories;
  final NutritionFacts nutritionFacts;
  final String name;
  final String genericName;
  final int? quantity;
  final String packaging;

  const FoodResult({
    required this.categories,
    required this.nutritionFacts,
    required this.name,
    required this.genericName,
    required this.quantity,
    required this.packaging,
  });
}

class FoodApi {
  final Dio _dio;

  FoodApi(this._dio);

  Future<FoodResult?> fetchProductByEan(String code) async {
    final result = await _dio
        .get("https://world.openfoodfacts.org/api/v0/product/$code.json");

    if (result.data["product"] == null) {
      return null;
    }

    return FoodResult(
        categories: result.data["product"]["categories"]?.split(", ") ?? [],
        nutritionFacts: NutritionFacts(
            energy: (result.data["product"]["nutriments"]["energy-kcal_100g"]
                    as int)
                .toDouble(),
            carbohydrates: result.data["product"]["nutriments"]
                    ["carbohydrates_100g"]
                ?.toDouble(),
            fat: result.data["product"]["nutriments"]["fat_100g"]?.toDouble(),
            fibre:
                result.data["product"]["nutriments"]["fiber_100g"]?.toDouble(),
            protein: result.data["product"]["nutriments"]["proteins_100g"]
                ?.toDouble(),
            salt:
                result.data["product"]["nutriments"]["salt_100g"]?.toDouble()),
        name: result.data["product"]["product_name_pl"],
        genericName: result.data["product"]["generic_name_pl"] ?? "",
        quantity:
            int.tryParse(result.data["product"]["product_quantity"] ?? ""),
        packaging: result.data["product"]?["packaging"]?.split(", ")?.last);
  }
}
