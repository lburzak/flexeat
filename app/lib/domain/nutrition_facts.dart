class NutritionFacts {
  final int? energy;
  final int? fat;
  final int? carbohydrates;
  final int? fibre;
  final int? protein;
  final int? salt;

  const NutritionFacts({
    this.energy,
    this.fat,
    this.carbohydrates,
    this.fibre,
    this.protein,
    this.salt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionFacts &&
          runtimeType == other.runtimeType &&
          energy == other.energy &&
          fat == other.fat &&
          carbohydrates == other.carbohydrates &&
          fibre == other.fibre &&
          protein == other.protein &&
          salt == other.salt;

  @override
  int get hashCode =>
      energy.hashCode ^
      fat.hashCode ^
      carbohydrates.hashCode ^
      fibre.hashCode ^
      protein.hashCode ^
      salt.hashCode;

  @override
  String toString() {
    return 'NutritionFacts{energy: $energy, fat: $fat, carbohydrates: $carbohydrates, fibre: $fibre, protein: $protein, salt: $salt}';
  }
}
