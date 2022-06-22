import 'nutrition_facts.dart';

class Food {
  final List<String> categories;
  final NutritionFacts nutritionFacts;
  final String name;
  final String genericName;
  final int? quantity;
  final String packaging;

  const Food({
    required this.categories,
    required this.nutritionFacts,
    required this.name,
    required this.genericName,
    required this.quantity,
    required this.packaging,
  });
}
