import 'package:flexeat/domain/packaging.dart';

class Product {
  final int id;
  final String name;
  final List<Packaging> packagings;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          packagings == other.packagings;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ packagings.hashCode;

  const Product({
    required this.id,
    required this.name,
    this.packagings = const [],
  });

  Product copyWith({
    int? id,
    String? name,
    List<Packaging>? packagings,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      packagings: packagings ?? this.packagings,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, packagings: $packagings}';
  }
}
