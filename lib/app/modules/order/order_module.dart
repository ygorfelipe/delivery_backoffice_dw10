import 'package:flutter_modular/flutter_modular.dart';
import '../../repositories/order/order_repository.dart';
import '../../repositories/order/order_repository_impl.dart';
import '../../services/order/get_order_by_id_dto_service.dart';
import '../../services/order/get_order_by_id_service_impl.dart';
import './order_controller.dart';
import './order_page.dart';

class OrderModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton<OrderRepository>((i) => OrderRepositoryImpl(i())),
    Bind.lazySingleton<GetOrderByIdService>((i) => GetOrderByIdServiceImpl(
          i(),
          i(),
          i(),
        )),
    Bind.lazySingleton((i) => OrderController(
          i(),
          i(),
        )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const OrderPage()),
  ];
}
