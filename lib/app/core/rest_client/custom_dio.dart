import '../storage/storage.dart';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

import '../env/env.dart';

import 'interceptors/auth_intercerptor.dart';

class CustomDio extends DioForBrowser {
  late AuthIntercerptor _authIntercerptor;

  CustomDio(Storage storage)
      : super(BaseOptions(
          baseUrl: Env.instance.get('backend_base_url'),
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 60),
        )) {
    interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
    _authIntercerptor = AuthIntercerptor(storage);
  }

  CustomDio auth() {
    interceptors.add(_authIntercerptor);
    return this;
  }

  CustomDio unauth() {
    interceptors.remove(_authIntercerptor);
    return this;
  }
}
