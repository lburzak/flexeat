import 'package:flexeat/bloc/nutrition_facts_cubit.dart';
import 'package:flexeat/domain/model/nutrition_facts.dart';
import 'package:flexeat/domain/repository/nutrition_facts_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util/prepared_completer.dart';
import 'nutrition_facts_cubit_test.mocks.dart';

@GenerateMocks([NutritionFactsRepository])
void main() {
  const existingProductId = 11;
  const existingProductNutritionFacts = NutritionFacts(
      carbohydrates: 300,
      energy: 200,
      fat: 400,
      fibre: 30,
      protein: 10,
      salt: 5);

  late NutritionFactsCubit cubit;
  late MockNutritionFactsRepository nutritionFactsRepository;
  late PreparedCompleter<NutritionFacts> dataCompleter;

  setUp(() {
    nutritionFactsRepository = MockNutritionFactsRepository();
    cubit = NutritionFactsCubit(nutritionFactsRepository);

    dataCompleter =
        when(nutritionFactsRepository.findByProductId(existingProductId))
            .thenReturnCompleter(existingProductNutritionFacts);
  });

  test('is initialized with null values', () {
    expect(cubit.state.carbohydrates, isNull);
    expect(cubit.state.energy, isNull);
    expect(cubit.state.fat, isNull);
    expect(cubit.state.fibre, isNull);
    expect(cubit.state.protein, isNull);
    expect(cubit.state.salt, isNull);
  });

  group('before product is set', () {
    test('.save() throws StateError', () {
      expect(cubit.save, throwsStateError);
    });
  });

  test('populates data when product id changed', () async {
    cubit.setProductId(existingProductId);
    await dataCompleter.ensureComplete();
    expect(cubit.state, equals(existingProductNutritionFacts));
  });

  group('after product is set', () {
    setUp(() async {
      cubit.setProductId(existingProductId);
      await dataCompleter.ensureComplete();
    });

    test('.save() updates packagings list', () async {
      fail("");
    });

    test('.save() adds packaging to repository', () {
      fail("");
    });
  });
}
