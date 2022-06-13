import 'article.dart';

class Ingredient {
  final Article article;
  final int weight;

  const Ingredient({
    this.article = const Article(),
    this.weight = 0,
  });
}
