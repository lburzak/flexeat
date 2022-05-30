import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationState {
  static NavigationState toProduct(int id) =>
      ToProductNavigationState(productId: id);

  static NavigationState stay() => StayNavigationState();
}

class StayNavigationState extends NavigationState {}

class ToProductNavigationState extends NavigationState {
  int productId;

  ToProductNavigationState({
    required this.productId,
  });
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState.stay());

  void navigateToProduct({required int id}) {
    emit(NavigationState.toProduct(id));
  }
}
