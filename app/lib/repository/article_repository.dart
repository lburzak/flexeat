import 'package:flexeat/domain/article.dart';

abstract class ArticleRepository {
  Future<int> create(String name);
  Stream<List<Article>> watchByProductId(int productId);
  Stream<List<Article>> watchAll();
  Future<void> linkToProduct(int articleId, int productId);
  Future<void> unlinkFromProduct(int articleId, int productId);
}
