import 'package:flexeat/data/live_repository.dart';
import 'package:flexeat/data/row.dart';
import 'package:flexeat/domain/nutrition_facts.dart';
import 'package:sqflite/sqflite.dart';

import '../repository/nutrition_facts_repository.dart';

const nutritionFactsTable = 'nutrition_facts';
const productIdColumn = 'product_id';
const energyColumn = 'energy';
const fatColumn = 'fat';
const carbohydratesColumn = 'carbohydrates';
const fibreColumn = 'fibre';
const proteinColumn = 'protein';
const saltColumn = 'salt';

abstract class _DataEvent {}

class _NutritionFactsUpdatedEvent extends _DataEvent {
  final int productId;

  _NutritionFactsUpdatedEvent(this.productId);
}

class LocalNutritionFactsRepository
    with LiveRepository
    implements NutritionFactsRepository {
  final Database _database;

  LocalNutritionFactsRepository(this._database);

  @override
  Future<NutritionFacts> findByProductId(int productId) async {
    final result = await _database.query(nutritionFactsTable,
        where: '$productIdColumn = ?', whereArgs: [productId]);

    return result.first.deserialize();
  }

  @override
  Stream<NutritionFacts?> watchByProductId(int productId) async* {
    yield await findByProductId(productId);

    yield* dataEvents
        .where((event) =>
            event is _NutritionFactsUpdatedEvent &&
            event.productId == productId)
        .asyncMap((event) => findByProductId(productId));
  }

  @override
  Future<void> updateByProductId(
      int productId, NutritionFacts nutritionFacts) async {
    await _database.insert(nutritionFactsTable, nutritionFacts.serialize(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    emit(_NutritionFactsUpdatedEvent(productId));
  }
}

extension _Serialization on NutritionFacts {
  Row serialize() => {
        energyColumn: energy,
        fatColumn: fat,
        carbohydratesColumn: carbohydrates,
        fibreColumn: fibre,
        proteinColumn: protein,
        saltColumn: salt,
      };
}

extension _Deserialization on Row {
  NutritionFacts deserialize() => NutritionFacts(
        energy: this[energyColumn],
        fat: this[fatColumn],
        carbohydrates: this[carbohydratesColumn],
        fibre: this[fibreColumn],
        protein: this[proteinColumn],
        salt: this[saltColumn],
      );
}
