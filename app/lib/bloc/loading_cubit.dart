import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingCubit extends Cubit<bool> {
  LoadingCubit({bool initialState = false}) : super(false);

  Future<T> launch<T>(Future<T> task) {
    emit(true);
    return task
      ..then((value) {
        emit(false);
      });
  }
}

extension LoadingFuture<T> on Future<T> {
  Future<T> listenIn(LoadingCubit loadingCubit) {
    return loadingCubit.launch(this);
  }
}
