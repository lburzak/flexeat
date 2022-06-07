import 'package:flexeat/domain/nutrition_facts.dart';

abstract class NutritionFactsRepository {
  Future<NutritionFacts> findByProductId(int productId);
  Stream<NutritionFacts> watchByProductId(int productId);
  Future<void> updateByProductId(int productId, NutritionFacts nutritionFacts);
}
