import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../storage/storage.dart';

//* aqui iremos criar um contexto global da key, para nos pergamos o usuário quando for logado
//* para verificarmos se já expirou ou não o accessToken
//* aqui iremos pegar e iremos apenas utilizar ele no contexto de logout
class GlobalContext {
  late final GlobalKey<NavigatorState> _navigatorKey;

  static GlobalContext? _instance;

  GlobalContext._();

  static GlobalContext get instance {
    _instance ??= GlobalContext._();
    return _instance!;
  }

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  void loginExpire() {
    Modular.get<Storage>().clean();
    ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.only(top: 72),
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Login Expirado',
        message: 'Login Expirado, faça o login novamente',
        contentType: ContentType.failure,
      ),
    ));
    Modular.to.navigate('/login');
  }
}
