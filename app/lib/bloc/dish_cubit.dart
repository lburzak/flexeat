import 'dart:async';

import 'package:flexeat/model/dish.dart';
import 'package:flexeat/model/ingredient.dart';
import 'package:flexeat/model/product_packaging.dart';
import 'package:flexeat/repository/article_repository.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/repository/recipe_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DishCubit extends Cubit<Dish> {
  final RecipeRepository _recipeRepository;
  final PackagingRepository _packagingRepository;
  final ArticleRepository _articleRepository;
  final int recipeId;
  late final StreamSubscription _sub;

  Map<Ingredient, ProductPackaging?> _mergeIngredients(
      List<Ingredient> ingredients) {
    final Map<Ingredient, ProductPackaging?> newIngredients = {};

    for (final ingredient in ingredients) {
      if (state.ingredients.containsKey(ingredient)) {
        newIngredients[ingredient] = state.ingredients[ingredient];
      } else {
        newIngredients[ingredient] = null;
      }
    }

    return newIngredients;
  }

  DishCubit(this._recipeRepository, this._packagingRepository,
      this._articleRepository,
      {required this.recipeId})
      : super(const Dish()) {
    _sub = _recipeRepository.watchById(recipeId).listen((recipe) {
      if (recipe != null) {
        emit(state.copyWith(
            recipeHeader: recipe.header,
            ingredients: _mergeIngredients(recipe.ingredients)));
      }
    });
  }

  @override
  Future<void> close() async {
    _sub.cancel();
    super.close();
  }

  void changeName(String name) {
    _recipeRepository.updateNameById(recipeId, name: name);
  }

  void addIngredient(int? articleId, String name, int weight) {
    _addIngredient(articleId, name, weight);
  }

  Future<void> _addIngredient(int? articleId, String name, int weight) async {
    articleId ??= await _articleRepository.create(name);

    _recipeRepository.addIngredientById(recipeId,
        articleId: articleId, weight: weight);
  }

  void selectProduct(int articleId, int packagingId) {
    _updateSelectedProduct(articleId, packagingId);
  }

  void _updateSelectedProduct(int articleId, int packagingId) async {
    final ingredient = state.ingredients.entries
        .firstWhere((element) => element.key.article.id == articleId)
        .key;

    final packaging = await _packagingRepository.findById(packagingId);
    final product =
        await _packagingRepository.findProductByPackagingId(packagingId);

    final productPackaging =
        ProductPackaging(product: product!, packaging: packaging!);

    emit(state.copyWith(
        ingredients: state.ingredients.updated(ingredient, productPackaging)));
  }
}

extension Updated<K, V> on Map<K, V> {
  Map<K, V> updated(K key, V value) {
    final newMap = Map<K, V>.from(this);
    newMap.update(key, (_) => value);
    return newMap;
  }
}
