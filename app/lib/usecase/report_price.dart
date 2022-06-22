import 'package:flexeat/model/price.dart';
import 'package:flexeat/repository/price_repository.dart';

class ReportPrice {
  final PriceRepository _priceRepository;

  const ReportPrice(this._priceRepository);

  Future<void> call(int packagingId, int value) async {
    final price = Price(value: value, reportDate: DateTime.now());
    _priceRepository.insert(packagingId, price);
  }
}
