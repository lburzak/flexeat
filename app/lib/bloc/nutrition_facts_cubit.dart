import 'package:flexeat/model/nutrition_facts.dart';
import 'package:flexeat/repository/nutrition_facts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NutritionFactsCubit extends Cubit<NutritionFacts> {
  final NutritionFactsRepository _nutritionFactsRepository;

  NutritionFactsCubit(NutritionFactsRepository nutritionFactsRepository)
      : _nutritionFactsRepository = nutritionFactsRepository,
        super(const NutritionFacts());

  void save() {
    throw StateError("Product not set");
  }

  void setProductId(int productId) {
    // _nutritionFactsRepository.findByProductId(productId).then(emit);
  }
}
