import 'package:flexeat/domain/nutrition_facts.dart';

abstract class NutritionFactsRepository {
  Future<NutritionFacts> findByProductId(int productId);
}
