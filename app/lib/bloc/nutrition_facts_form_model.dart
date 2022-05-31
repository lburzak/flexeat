import 'package:flexeat/repository/nutrition_facts_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NutritionFactsFormModel {
  final int productId;
  final NutritionFactsRepository nutritionFactsRepository;
  final form = FormGroup({
    'energy': FormControl<double>(),
    'fat': FormControl<double>(),
    'carbohydrates': FormControl<double>(),
    'fibre': FormControl<double>(),
    'protein': FormControl<double>(),
    'salt': FormControl<double>(),
  });

  NutritionFactsFormModel(this.nutritionFactsRepository,
      {required this.productId});

  void submit() {}
}
