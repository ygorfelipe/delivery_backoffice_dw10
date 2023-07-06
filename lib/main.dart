import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './app/app_module.dart';
import './app/app_widget.dart';
import 'app/core/env/env.dart';

//! Procurar e estudar mais sobre LayoutBuilder com contrains
//! para saber qual tamanho você esta

Future<void> main() async {
  // iniciando o flutter antes da aplicacao
  WidgetsFlutterBinding.ensureInitialized();
  await Env.instance.load();
  return runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
