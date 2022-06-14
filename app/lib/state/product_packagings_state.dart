import 'package:flexeat/model/packaging.dart';
import 'package:meta/meta.dart';

@immutable
class ProductPackagingsState {
  final List<Packaging> packagings;

  const ProductPackagingsState({
    this.packagings = const [],
  });

  ProductPackagingsState copyWith({
    List<Packaging>? packagings,
  }) {
    return ProductPackagingsState(
      packagings: packagings ?? this.packagings,
    );
  }
}
