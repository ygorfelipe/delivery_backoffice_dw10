// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

import '../../global/constants.dart';
import '../../global/global_context.dart';
import '../../storage/storage.dart';

class AuthIntercerptor extends Interceptor {
  final Storage storage;

  AuthIntercerptor(this.storage);

  //* aqui devemos pegar o onRequest do interceptor, e pegar o accessToken do storage
  //* pegamos ele, e passamos no options.header do Interceptor o aauthorization e o bearer

  //* dpois devemos adicionar no customDio esse interceptor

  //* quando o dio fazer o request ele deve buscar o accessToken do SesstionStorageKeys
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = storage.getData(SessionStorageKeys.accessToken.key);
    options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
  }

  //* quando não tiver mais valido o accessToken, ele irá deslogar o usuário
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      GlobalContext.instance.loginExpire();
    } else {
      handler.next(err);
    }
  }
}
