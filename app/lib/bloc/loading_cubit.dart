import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingCubit extends Cubit<bool> {
  LoadingCubit({bool initialState = false}) : super(false);

  int counter = 0;

  Future<T> launch<T>(Future<T> task) {
    emit(true);
    counter++;
    return task
      ..then((value) {
        counter--;
        if (counter < 1) {
          emit(false);
        }
      });
  }
}

extension LoadingFuture<T> on Future<T> {
  Future<T> listenIn(LoadingCubit loadingCubit) {
    return loadingCubit.launch(this);
  }
}
