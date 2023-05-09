import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Env? _instance;

  Env._();

  static Env get instance {
    _instance ??= Env._();
    return _instance!;
  }

  //3 metodos

  //carregando o load
  Future<void> load() => dotenv.load();

  //buscando a chave, porem se nao existernao vai fazer problema, retorn null
  String? maybeGet(String key) => dotenv.maybeGet(key);

  // vai buscar a chaven o arquivo de confi, e se nao exister, vai subir um erro
  String get(String key) => dotenv.get(key);
}
