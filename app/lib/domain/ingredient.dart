import 'article.dart';

class Ingredient {
  final Article article;
  final int weight;

  const Ingredient({
    this.article = const Article(),
    this.weight = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          article == other.article &&
          weight == other.weight;

  @override
  int get hashCode => article.hashCode ^ weight.hashCode;
}
