class Packaging {
  final int id;
  final int weight;
  final String label;

  const Packaging({
    this.id = 0,
    required this.weight,
    required this.label,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Packaging &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          weight == other.weight &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ weight.hashCode ^ label.hashCode;
}