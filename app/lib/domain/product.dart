class Product {
  final int id;
  final String name;

  const Product({
    this.id = 0,
    this.name = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Product copyWith({
    int? id,
    String? name,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
