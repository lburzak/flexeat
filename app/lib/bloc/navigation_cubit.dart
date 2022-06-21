import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationState {
  static NavigationState toProduct(int id) =>
      ToProductNavigationState(productId: id);

  static NavigationState stay() => StayNavigationState();

  static NavigationState back() => BackNavigationState();

  static NavigationState toDish(int recipeId) =>
      ToDishNavigationState(recipeId: recipeId);
}

class BackNavigationState extends NavigationState {}

class StayNavigationState extends NavigationState {}

class ToProductNavigationState extends NavigationState {
  int productId;

  ToProductNavigationState({
    required this.productId,
  });
}

class ToDishNavigationState extends NavigationState {
  int recipeId;

  ToDishNavigationState({
    required this.recipeId,
  });
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState.stay());

  void navigateToProduct({required int id}) {
    emit(NavigationState.toProduct(id));
  }

  void navigateToRecipe({required int id}) {
    emit(NavigationState.toDish(id));
  }

  void navigateBack() {
    emit(NavigationState.back());
  }
}
