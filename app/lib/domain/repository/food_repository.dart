import 'package:flexeat/domain/model/food.dart';

abstract class FoodRepository {
  Future<Food?> findProductByEan(String code);
}
