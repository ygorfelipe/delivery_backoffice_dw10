import '../../dto/order/order_product_dto.dart';
import '../../models/orders/order_model.dart';
import '../../dto/order/order_dto.dart';
import '../../models/payment_type_model.dart';
import '../../models/user_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';
import '../../repositories/products/product_repository.dart';
import '../../repositories/user/user_repository.dart';
import 'get_order_by_id_dto_service.dart';

class GetOrderByIdServiceImpl implements GetOrderByIdService {
  final PaymentTypeRepository _paymentTypeRepository;
  final UserRepository _userRepository;
  final ProductRepository _productRepository;

  GetOrderByIdServiceImpl(
    this._paymentTypeRepository,
    this._userRepository,
    this._productRepository,
  );

  @override
  Future<OrderDto> call(OrderModel order) => _orderDtoParse(order);

  //! criando dois metodos auxiliares, para converter tudo, e diminuindo o maximo de responsabilidade única
  //! querendo os metodos em 2 metodos menores, assim dividino as responsabilidades

  //* primeiramente vai fazer todas as buscas primeiros
  Future<OrderDto> _orderDtoParse(OrderModel order) async {
    final start = DateTime.now();
    final paymentTypeFuture =
        _paymentTypeRepository.findById(order.paymentTypeId);
    final userFuture = _userRepository.getById(order.userId);
    final orderProductsFuture = _orderProducetParse(order);

    final responses =
        await Future.wait([paymentTypeFuture, userFuture, orderProductsFuture]);
    //! DESAFIO
    print(
        'Calculando tempo: ${DateTime.now().difference(start).inMilliseconds}');
    return OrderDto(
      id: order.id,
      date: order.date,
      status: order.status,
      orderProducts: responses[2] as List<OrderProductDto>,
      user: responses[1] as UserModel,
      address: order.address,
      cpf: order.cpf,
      paymentTypeModel: responses[0] as PaymentTypeModel,
    );
  }

  //! metodo para buscar a lista de produtos.
  Future<List<OrderProductDto>> _orderProducetParse(OrderModel order) async {
    final orderProducts = <OrderProductDto>[];
    //* aqui seria basicamente para fazer uma busca "paralela", mas na vdd é um eventLoop, onde ele busca e retorna o primeiro e dpois o segundo, e assim por diante
    final productsFuture = order.orderProducts
        .map((e) => _productRepository.getProduct(e.productId))
        .toList();

    //! aqui estou aguardando todos os itens retornarem
    final products = await Future.wait(productsFuture);

    for (var i = 0; i < order.orderProducts.length; i++) {
      final orderProduct = order.orderProducts[i];
      final productDto = OrderProductDto(
        product: products[i],
        amount: orderProduct.amount,
        totalPrice: orderProduct.totalPrice,
      );
      orderProducts.add(productDto);
    }
    return orderProducts;
  }
}
