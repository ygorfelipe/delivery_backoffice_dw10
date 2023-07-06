// ignore_for_file: public_member_api_docs, sort_constructors_first
//* o milliseconds é o tempo que ele ira aguardar para executar aquela função - callBack ou qlqr outra função feita
//* timer, é o tempo que iremos aguardar o milliseconds

import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});

  //! essa função, é para quando estourar o timer, é para executar a função
  //! é como se fosse um trigger

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }
}
