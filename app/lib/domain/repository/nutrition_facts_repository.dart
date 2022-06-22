import 'package:flexeat/domain/model/nutrition_facts.dart';

abstract class NutritionFactsRepository {
  Future<NutritionFacts> findByProductId(int productId);
  Stream<NutritionFacts> watchByProductId(int productId);
  Future<void> updateByProductId(int productId, NutritionFacts nutritionFacts);
}
