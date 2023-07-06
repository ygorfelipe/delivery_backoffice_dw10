// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../models/product_model.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final CustomDio _dio;

  ProductRepositoryImpl(this._dio);

  @override
  Future<void> deleteProduct(int id) async {
    //! aqui é um delete "LOGICO" ou seja, aqui esta apenas desativando ele da view
    //! mas é mantido ele 100% no banco de dados
    try {
      await _dio.auth().put('/products/$id', data: {'enabled': false});
    } on DioError catch (e, s) {
      log('Erro ao deletar produto', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao deletar produto');
    }
  }

  @override
  Future<List<ProductModel>> findAll(String? name) async {
    //! nesse caso aqui, dos ativos é porq não tem um back-end com uma regra de negocio
    //! geralmente quando nos fazemos o back-end, quando buscamos todos os itens, ele irá trazer apenas todos os itens ativos
    //! não precisaria fazer essa ferificação para ver se o item é ativado ou não
    //! a não ser que seja necessário fazer na regra de negocio, porém seria utilizado outro endpoint

    try {
      final productResult = await _dio.auth().get(
        '/products',
        queryParameters: {if (name != null) 'name': name, 'enabled': true},
      );
      return productResult.data
          .map<ProductModel>((p) => ProductModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar produtos');
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    //! aqui ele não esta buscando um array de produto por isso eu mapeio ele de primeira
    //! não precisa colocar dentro de uma lista

    try {
      final productResult = await _dio.auth().get('/products/$id');
      return ProductModel.fromMap(productResult.data);
    } on DioError catch (e, s) {
      log('Erro ao buscar produto $id', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar produto');
    }
  }

  @override
  Future<void> save(ProductModel productModel) async {
    try {
      final client = _dio.auth();
      final data = productModel.toMap();
      if (productModel.id != null) {
        await client.put('/products/${productModel.id}', data: data);
      } else {
        await client.post('/products', data: data);
      }
    } on DioError catch (e, s) {
      log('Erro ao salvar produto', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao salvar produto');
    }
  }

  @override
  Future<String> uploadImageProduct(Uint8List file, String fileName) async {
    //! aqui sera a parte mais complicada de se fazer
    //! nos iremos mandar um array de bits para o nosso back-end e nao estamos mantando por string
    //! existe 2 forma, utilizando o base64 - onde torna o upload gigantesco
    //* ou
    //! ou fazemos como formulario do html com o formData

    try {
      final formData = FormData.fromMap(
        {
          'file': MultipartFile.fromBytes(file, filename: fileName),
        },
      );

      //! pegamos o retorno do nosso back-end
      final response = await _dio.auth().post('/uploads', data: formData);
      return response.data['url'];
    } on DioError catch (e, s) {
      log('Erro ao fazer upload do arquivo', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao fazer upload do arquivo');
    }
  }
}
