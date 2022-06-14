import 'dart:async';

import 'package:flexeat/model/recipe.dart';
import 'package:flexeat/repository/recipe_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeCubit extends Cubit<Recipe> {
  final RecipeRepository _recipeRepository;
  final int recipeId;
  late final StreamSubscription _sub;

  RecipeCubit(this._recipeRepository, {required this.recipeId})
      : super(const Recipe()) {
    _sub = _recipeRepository.watchById(recipeId).listen((event) {
      emit(event ?? const Recipe());
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

  void addIngredient(int articleId, int weight) {
    _recipeRepository.addIngredientById(recipeId,
        articleId: articleId, weight: weight);
  }

  void selectProduct(int ingredientId, int productId) {}
}
