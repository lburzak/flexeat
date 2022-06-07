import 'package:flexeat/domain/article.dart';

abstract class ArticleRepository {
  Future<void> create(String name);
  Future<List<Article>> findByProductId(int productId);
  Future<List<Article>> findAll();
  Future<void> linkToProduct(int articleId, int productId);
  Future<void> unlinkFromProduct(int articleId, int productId);
}
