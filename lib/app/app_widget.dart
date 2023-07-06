import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/global/global_context.dart';
import 'core/ui/theme/theme_config.dart';

class AppWidget extends StatelessWidget {
  final _navigateKey = GlobalKey<NavigatorState>();

  //* essa globalContext está vindo lá do globalContext, fazendo com que o flutter_modular
  //* libere esse contexto para nossa aplicação apenas quando for solicitado
  AppWidget({super.key}) {
    GlobalContext.instance.navigatorKey = _navigateKey;
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/login');
    //* integrando a chave criada com a do modular
    Modular.setNavigatorKey(_navigateKey);

    return MaterialApp.router(
      title: 'Delivery BackOffice',
      theme: ThemeConfig.theme,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
