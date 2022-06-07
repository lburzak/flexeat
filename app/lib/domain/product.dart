class Product {
  final int id;
  final String name;
  final List<String> suppliedArticles;

  const Product(
      {this.id = 0, this.name = "", this.suppliedArticles = const []});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          suppliedArticles == other.suppliedArticles;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ suppliedArticles.hashCode;

  Product copyWith({
    int? id,
    String? name,
    List<String>? suppliedArticles,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      suppliedArticles: suppliedArticles ?? this.suppliedArticles,
    );
  }
}
