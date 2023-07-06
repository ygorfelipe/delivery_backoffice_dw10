import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../dto/order/order_dto.dart';
import '../../models/orders/order_model.dart';
import '../../models/orders/order_status.dart';
import '../../repositories/order/order_repository.dart';
import '../../services/order/get_order_by_id_dto_service.dart';
part 'order_controller.g.dart';

enum OrderStateStatus {
  initial,
  loading,
  loaded,
  error,
  showDetailModal,
  statusChanched,
}

class OrderController = OrderControllerBase with _$OrderController;

abstract class OrderControllerBase with Store {
  final OrderRepository _orderRepository;
  final GetOrderByIdService _getOrderByIdService;
  late final DateTime _today;

  @readonly
  OrderStatus? _statusFilter;

  @readonly
  var _status = OrderStateStatus.initial;

  @readonly
  var _orders = <OrderModel>[];

  @readonly
  String? _errorMessage;

  @readonly
  OrderDto? _orderSelected;

  //! buscando a data agora dentro do construtor
  OrderControllerBase(this._orderRepository, this._getOrderByIdService) {
    final todayNow = DateTime.now();
    _today = DateTime(todayNow.year, todayNow.month, todayNow.day);
  }

  //! metodo para alterar o filtro
  @action
  void changeStatusFilter(OrderStatus? status) {
    _statusFilter = status;
    findOrders();
  }

  @action
  Future<void> findOrders() async {
    try {
      _status = OrderStateStatus.loading;
      //! continuando a buscar
      _orders = await _orderRepository.findAllOrders(_today, _statusFilter);
      _status = OrderStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao buscar pedidos do dia', error: e, stackTrace: s);
      _status = OrderStateStatus.error;
      _errorMessage = 'Erro ao buscar pedidos do dia';
    }
  }

  @action
  Future<void> showDetailModal(OrderModel model) async {
    _status = OrderStateStatus.loading;
    await Future.delayed(Duration.zero);
    _orderSelected = await _getOrderByIdService(model);
    _status = OrderStateStatus.showDetailModal;
  }

  @action
  Future<void> chanceStatus(OrderStatus status) async {
    _status = OrderStateStatus.loading;
    await _orderRepository.changeStatus(_orderSelected!.id, status);
    _status = OrderStateStatus.statusChanched;
  }
}
