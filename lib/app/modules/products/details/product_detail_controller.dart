import 'dart:developer';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import '../../../models/product_model.dart';
import '../../../repositories/products/product_repository.dart';
part 'product_detail_controller.g.dart';

//! todas as telas deveram ter o status do estado
enum ProductDetailStateStatus {
  initial,
  loading,
  loaded,
  error,
  errorLoadProduct,
  deleted,
  uploaded,
  saved,
}

class ProductDetailController = ProductDetailControllerBase
    with _$ProductDetailController;

abstract class ProductDetailControllerBase with Store {
  final ProductRepository _productRepository;

  ProductDetailControllerBase(this._productRepository);

  @readonly
  var _status = ProductDetailStateStatus.initial;

  @readonly
  String? _errorMessage;

  //! UPLOAD -------
  @readonly
  String? _imagePath;

  @action
  Future<void> uploadImageProduct(Uint8List file, String fileName) async {
    _status = ProductDetailStateStatus.loading;
    _imagePath = await _productRepository.uploadImageProduct(file, fileName);
    _status = ProductDetailStateStatus.uploaded;
  }
  //!

  @readonly
  ProductModel? _productModel;

  @action
  Future<void> save(String name, double price, String description) async {
    try {
      _status = ProductDetailStateStatus.loading;
      final productModel = ProductModel(
        id: _productModel?.id,
        name: name,
        description: description,
        price: price,
        image: _imagePath!,
        enabled: _productModel?.enabled ?? true,
      );
      await _productRepository.save(productModel);
      _status = ProductDetailStateStatus.saved;
    } catch (e, s) {
      _status = ProductDetailStateStatus.error;
      _errorMessage = 'Erro ao salvar o produto';
      log('Erro ao salvar produto', error: e, stackTrace: s);
    }
  }

  @action
  Future<void> loadProduct(int? id) async {
    try {
      _status = ProductDetailStateStatus.loading;
      _productModel = null;
      _imagePath = null;
      if (id != null) {
        _productModel = await _productRepository.getProduct(id);
        _imagePath = _productModel!.image;
      }
      _status = ProductDetailStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao buscar carregar produto', error: e, stackTrace: s);
      _status = ProductDetailStateStatus.errorLoadProduct;
    }
  }

  @action
  Future<void> deleteProduct() async {
    try {
      _status = ProductDetailStateStatus.loading;

      if (_productModel != null && _productModel!.id != null) {
        await _productRepository.deleteProduct(_productModel!.id!);
        _status = ProductDetailStateStatus.deleted;
      }
      await Future.delayed(Duration.zero);
      _status = ProductDetailStateStatus.error;
      _errorMessage =
          'Produto não cadastrado, não é permitido cadastrar o produto';
    } catch (e, s) {
      log('Erro ao deletar produto', error: e, stackTrace: s);
      _status = ProductDetailStateStatus.error;
      _errorMessage = 'Error ao deletar produto';
    }
  }
}
