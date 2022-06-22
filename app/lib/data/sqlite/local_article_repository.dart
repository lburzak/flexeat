import 'package:flexeat/data/event/live_repository.dart';
import 'package:flexeat/data/sqlite/row.dart';
import 'package:flexeat/domain/model/article.dart';
import 'package:flexeat/domain/repository/article_repository.dart';
import 'package:sqflite/sqflite.dart';

const _article$ = 'article';
const _article$id = 'id';
const _article$name = 'name';
const _productArticle$ = 'product_article';
const _productArticle$productId = 'product_id';
const _productArticle$articleId = 'article_id';

abstract class _DataEvent {}

class _ArticleCreatedEvent extends _DataEvent {}

class _ArticleLinkedEvent extends _DataEvent {
  final int productId;

  _ArticleLinkedEvent({
    required this.productId,
  }) : super();
}

class _ArticleUnlinkedEvent extends _DataEvent {
  final int productId;

  _ArticleUnlinkedEvent({
    required this.productId,
  }) : super();
}

class _ArticleDeletedEvent extends _DataEvent {}

class LocalArticleRepository extends ArticleRepository
    with LiveRepository<_DataEvent> {
  final Database _database;

  LocalArticleRepository(this._database);

  @override
  Future<int> create(String name) async {
    final article = Article(name: name);
    final id = await _database.insert(_article$, article.serialize());
    emit(_ArticleCreatedEvent());
    return id;
  }

  @override
  Future<void> linkToProduct(int articleId, int productId) async {
    await _database.insert(_productArticle$, {
      _productArticle$articleId: articleId,
      _productArticle$productId: productId
    });

    emit(_ArticleLinkedEvent(productId: productId));
  }

  Future<void> _removeById(int articleId) async {
    await _database
        .delete(_article$, where: '${_article$id} = ?', whereArgs: [articleId]);
    emit(_ArticleDeletedEvent());
  }

  @override
  Future<void> unlinkFromProduct(int articleId, int productId) async {
    await _database.delete(_productArticle$,
        where:
            '${_productArticle$articleId} = ? AND ${_productArticle$productId} = ?',
        whereArgs: [articleId, productId]);

    final currentArticleLinks = await _database.query(_productArticle$,
        where: '${_productArticle$articleId} = ?', whereArgs: [articleId]);

    if (currentArticleLinks.isEmpty) {
      await _removeById(articleId);
    }

    emit(_ArticleUnlinkedEvent(productId: productId));
  }

  Future<List<Article>> findAll() async {
    final articles = await _database.query(_article$);
    return articles.map((e) => e.deserialize()).toList();
  }

  Future<List<Article>> findByProductId(int productId) async {
    final articles = await _database.rawQuery("""
        SELECT A.${_article$id}, A.${_article$name}
        FROM ${_article$} A INNER JOIN ${_productArticle$} P ON A.${_article$id} = P.${_productArticle$articleId}
        WHERE ${_productArticle$productId} = ?
    """, [productId]);
    return articles.map((e) => e.deserialize()).toList();
  }

  @override
  Stream<List<Article>> watchAll() async* {
    yield await findAll();
    yield* dataEvents
        .where((event) =>
            event is _ArticleCreatedEvent || event is _ArticleDeletedEvent)
        .asyncMap((_) => findAll());
  }

  @override
  Stream<List<Article>> watchByProductId(int productId) async* {
    yield await findByProductId(productId);
    yield* dataEvents
        .where((event) =>
            event is _ArticleLinkedEvent || event is _ArticleUnlinkedEvent)
        .asyncMap((_) => findByProductId(productId));
  }
}

extension _Serialization on Article {
  Row serialize() {
    final map = <String, Object?>{
      _article$name: name,
    };

    if (id != 0) {
      map[_article$id] = id;
    }

    return map;
  }
}

extension _Deserialization on Row {
  Article deserialize() =>
      Article(id: this[_article$id], name: this[_article$name]);
}
