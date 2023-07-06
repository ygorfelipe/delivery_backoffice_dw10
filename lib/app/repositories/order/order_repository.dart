import '../../models/orders/order_model.dart';
import '../../models/orders/order_status.dart';

abstract class OrderRepository {
  //! aqui no findAll nos iremos buscar pela data, e quando colocado [] é opcional
  //! sendo assim opcional o parametro status
  Future<List<OrderModel>> findAllOrders(DateTime date, [OrderStatus? status]);
  Future<OrderModel> getById(int id);
  //! aqui  nos estamos fazendo a mudança de status quando for finalizado o pedido
  Future<void> changeStatus(int id, OrderStatus status);
}
