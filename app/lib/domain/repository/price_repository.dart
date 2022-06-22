import 'package:flexeat/domain/model/price.dart';

abstract class PriceRepository {
  Future<void> insert(int packagingId, Price price);
  Future<Price> findLatest(int packagingId);
}
