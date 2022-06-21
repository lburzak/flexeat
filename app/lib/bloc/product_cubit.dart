import 'dart:async';

import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/repository/article_repository.dart';
import 'package:flexeat/repository/nutrition_facts_repository.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final NutritionFactsRepository _nutritionFactsRepository;
  final ArticleRepository _articleRepository;
  final LoadingCubit _loadingCubit;
  final int _productId;
  final NavigationCubit _navigationCubit;
  late StreamSubscription subscription;
  late StreamSubscription allArticlesSub;
  late StreamSubscription productArticlesSub;

  ProductCubit(
      this._productRepository,
      this._loadingCubit,
      this._nutritionFactsRepository,
      this._articleRepository,
      this._navigationCubit,
      {required int productId})
      : _productId = productId,
        super(const ProductState()) {
    _fetchData();

    subscription = _nutritionFactsRepository
        .watchByProductId(productId)
        .listen((nutritionFacts) {
      emit(state.copyWith(nutritionFacts: nutritionFacts));
    });

    allArticlesSub = _articleRepository.watchAll().listen((articles) {
      emit(state.copyWith(availableArticles: articles));
    });

    productArticlesSub = _articleRepository
        .watchByProductId(_productId)
        .listen((productArticles) {
      emit(state.copyWith(compatibleArticles: productArticles));
    });
  }

  @override
  Future<void> close() async {
    subscription.cancel();
    allArticlesSub.cancel();
    productArticlesSub.cancel();
    super.close();
  }

  Future<void> _fetchData() async {
    final product =
        await _productRepository.findById(_productId).listenIn(_loadingCubit);
    emit(ProductState(productName: product.name, id: product.id));
  }

  void changeName(String name) {
    if (_loadingCubit.state == true) {
      return;
    }

    _productRepository
        .update(Product(id: _productId, name: name))
        .listenIn(_loadingCubit);
  }

  void unlinkArticle(int articleId) {
    _articleRepository.unlinkFromProduct(articleId, _productId);
  }

  void linkArticle(int articleId) {
    _articleRepository.linkToProduct(articleId, _productId);
  }

  void linkNewArticle(String name) {
    _articleRepository.create(name).then((id) {
      _articleRepository.linkToProduct(id, _productId);
    });
  }

  void remove() {
    _productRepository
        .removeById(_productId)
        .listenIn(_loadingCubit)
        .then((value) => _navigationCubit.navigateBack());
  }
}
