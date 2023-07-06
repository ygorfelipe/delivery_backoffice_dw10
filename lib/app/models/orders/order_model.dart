// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'order_product_model.dart';
import 'order_status.dart';

class OrderModel {
  final int id;
  final DateTime date;
  final OrderStatus status;
  final List<OrderProductModel> orderProducts;
  final int userId;
  final String address;
  final String cpf;
  final int paymentTypeId;
  OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.orderProducts,
    required this.userId,
    required this.address,
    required this.cpf,
    required this.paymentTypeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      //! na data é alterado para toIso, nunca por millesconds padrão
      'date': date.toIso8601String(),
      //! o status não é .toMap() mas sim pelo acronym porq vou pegar apenas a sigla
      'status': status.acronym,
      'orderProducts': orderProducts.map((x) => x.toMap()).toList(),
      'userId': userId,
      'address': address,
      'cpf': cpf,
      'paymentTypeId': paymentTypeId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int,
      //! aqui não precisa fazer a conversão do dateTime padrão dele, mas sim no parser de date
      date: DateTime.parse(map['date']),
      //! aqui não sera no metodo fromMap mas sim fazendo um parser dele tbm, para pegar o acronym
      status: OrderStatus.parse(map['status']),
      orderProducts: List<OrderProductModel>.from(
        (map['products']).map<OrderProductModel>(
          (x) => OrderProductModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      userId: (map['user_id'] ?? 0) as int,
      address: (map['address'] ?? '') as String,
      cpf: (map['cpf'] ?? '') as String,
      paymentTypeId: (map['payment_method_id'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(id: $id, date: $date, status: $status, products: $orderProducts, user_id: $userId, address: $address, cpf: $cpf, payment_method_id: $paymentTypeId)';
  }
}
