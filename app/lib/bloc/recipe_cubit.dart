import 'dart:async';

import 'package:flexeat/domain/recipe.dart';
import 'package:flexeat/repository/recipe_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeCubit extends Cubit<Recipe> {
  final RecipeRepository _recipeRepository;
  late final StreamSubscription _sub;

  RecipeCubit(this._recipeRepository, {required int recipeId})
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

  void changeName(String name) {}

  void addIngredient(int articleId, int weight) {}

  void selectProduct(int ingredientId, int productId) {}
}
