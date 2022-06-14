import 'package:flexeat/model/nutrition_facts.dart';
import 'package:flexeat/repository/nutrition_facts_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NutritionFactsFormModel {
  final int _productId;
  final NutritionFactsRepository _nutritionFactsRepository;
  final form = FormGroup({
    'energy': FormControl<double>(),
    'fat': FormControl<double>(),
    'carbohydrates': FormControl<double>(),
    'fibre': FormControl<double>(),
    'protein': FormControl<double>(),
    'salt': FormControl<double>(),
  });

  NutritionFactsFormModel(this._nutritionFactsRepository,
      {required int productId})
      : _productId = productId {
    _nutritionFactsRepository.findByProductId(productId).then(_populateFields);
  }

  void _populateFields(NutritionFacts nutritionFacts) {
    form.control('energy').value = nutritionFacts.energy;
    form.control('fat').value = nutritionFacts.fat;
    form.control('carbohydrates').value = nutritionFacts.carbohydrates;
    form.control('fibre').value = nutritionFacts.fibre;
    form.control('protein').value = nutritionFacts.protein;
    form.control('salt').value = nutritionFacts.salt;
  }

  void submit() {
    final nutritionFacts = NutritionFacts(
        energy: form.control('energy').value,
        fat: form.control('fat').value,
        carbohydrates: form.control('carbohydrates').value,
        fibre: form.control('fibre').value,
        protein: form.control('protein').value,
        salt: form.control('salt').value);

    _nutritionFactsRepository.updateByProductId(_productId, nutritionFacts);
  }
}
