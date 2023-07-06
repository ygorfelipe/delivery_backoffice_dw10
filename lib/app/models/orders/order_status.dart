import 'package:flutter/material.dart';

//* esse enum aqui, é criado apenas para poder mostrar o status na tela de administrar pedidos
enum OrderStatus {
  pendente('Pendente', 'P', Colors.blue),
  confirmado('Confirmado', 'C', Colors.green),
  finalizado('Finalizado', 'F', Colors.black),
  cancelado('Cancelado', 'R', Colors.red);

  final String name;
  final String acronym;
  final Color color;

  const OrderStatus(this.name, this.acronym, this.color);

  //* o e num vai chegar com uma String e ira fazer o parser para enum

  static OrderStatus parse(String acronym) {
    return values.firstWhere((s) => s.acronym == acronym);
  }
}
