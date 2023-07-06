import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../models/product_model.dart';
import '../../../repositories/products/product_repository.dart';
part 'products_controller.g.dart';

//! sempre colocar o estado dos status
//! em toda as telas deverar conter o estado dos status
enum ProductStateStatus {
  initial,
  loading,
  loaded,
  error,
  addOrUpdateProduct,
}

class ProductsController = ProductsControllerBase with _$ProductsController;

abstract class ProductsControllerBase with Store {
  final ProductRepository _productRepository;

  ProductsControllerBase(this._productRepository);

  @readonly
  var _status = ProductStateStatus.initial;

  @readonly
  var _products = <ProductModel>[];

  @readonly
  String? _filterName;

  @readonly
  ProductModel? _productSelected;

  //! adicionando um debaunce, onde aguarda o usuario digitar alguma coisa, para dpois fazer a busca de verdade
  //! onde o usuario para de digitar ele começa a fazer a busca
  //* procurar sobre debauncer
  //* OBS daria para fazer a impl na busca do calendário academico no app 4class
  @action
  Future<void> filterByName(String name) async {
    _filterName = name;
    await loadProducts();
  }

  @action
  Future<void> loadProducts() async {
    _status = ProductStateStatus.loading;
    try {
      _products = await _productRepository.findAll(_filterName);
      _status = ProductStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao buscar Produtos', error: e, stackTrace: s);
      //! nessa tela não havera uma string de erro, apenas uma mensagem fixa na tela
      //! onde sera uma opção para o tratamento
      _status = ProductStateStatus.error;
    }
  }

  @action
  Future<void> addProduct() async {
    _status = ProductStateStatus.loading;
    await Future.delayed(Duration.zero);
    _productSelected = null;
    _status = ProductStateStatus.addOrUpdateProduct;
  }

  @action
  Future<void> editProduct(ProductModel productModel) async { 
    _status = ProductStateStatus.loading;
    await Future.delayed(Duration.zero);
    _productSelected = productModel;
    _status = ProductStateStatus.addOrUpdateProduct;
  }
}
