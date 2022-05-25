import 'dart:async';

import 'package:mockito/mockito.dart';

class PreparedCompleter<T> {
  final T _value;
  final Completer<T> _completer = Completer<T>();

  Future<T> get future => _completer.future;

  PreparedCompleter(this._value);

  Future<void> ensureComplete() async {
    _completer.complete(_value);
    await future;
  }
}

extension CompleterExpectation<T> on PostExpectation<Future<T>> {
  PreparedCompleter<T> thenReturnCompleter(T value) {
    final completer = PreparedCompleter(value);

    thenAnswer((_) async => completer.future);

    return completer;
  }
}
