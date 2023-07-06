import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../models/payment_type_model.dart';
import './payment_type_repository.dart';

class PaymentTypeRepositoryImpl implements PaymentTypeRepository {
  final CustomDio _dio;

  PaymentTypeRepositoryImpl(this._dio);

  @override
  Future<List<PaymentTypeModel>> findAll(bool? enabled) async {
    try {
      final paymentResult = await _dio.auth().get(
        '/payment-types',
        queryParameters: {
          if (enabled != null) 'enabled': enabled,
        },
      );
      return paymentResult.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar Forma de Pagamento', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar Forma de Pagamento');
    }
  }

  @override
  Future<PaymentTypeModel> findById(int id) async {
    try {
      final paymentResult = await _dio.auth().get(
            '/payment-types/$id',
          );
      return PaymentTypeModel.fromMap(paymentResult.data);
    } on DioError catch (e, s) {
      log('Erro ao buscar Forma de Pagamento $id', error: e, stackTrace: s);
      throw RepositoryException(
          message: 'Erro ao buscar Forma de Pagamento $id');
    }
  }

  @override
  Future<void> save(PaymentTypeModel model) async {
    //* para fazer o metodo insert/update não precisa mais passar os parametros de forma explicitas
    //* basta passar a model com o toMap() que ele fara o resto
    //* no backend em questão tem não tem o save, tem apenas o put e o post
    try {
      final client = _dio.auth();

      //* se veio um id na hora do "save" então significa que é um update
      //* se não veio nenhum id é um insert
      if (model.id != null) {
        await client.put(
          '/payment-types/${model.id}',
          data: model.toMap(),
        );
      } else {
        await client.post(
          '/payment-types/',
          data: model.toMap(),
        );
      }
    } on DioError catch (e, s) {
      log('Erro ao salvar Forma de Pagamento ', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao salvar Forma de Pagamento ');
    }
  }
}
