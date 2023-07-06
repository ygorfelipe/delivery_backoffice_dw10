import '../../../dto/order/order_dto.dart';
import '../order_controller.dart';
import 'widgets/order_bottom_bar.dart';

import 'widgets/order_info_tile.dart';

import '../../../core/ui/extensions/formatter_extensions.dart';
import 'widgets/order_product_item.dart';
import 'package:flutter/material.dart';

import '../../../core/ui/helpers/size_extensions.dart';
import '../../../core/ui/styles/text_styles.dart';

class OrderDetailModal extends StatefulWidget {
  final OrderController controller;
  final OrderDto order;

  const OrderDetailModal({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  State<OrderDetailModal> createState() => _OrderDetailModalState();
}

class _OrderDetailModalState extends State<OrderDetailModal> {
  void _closeModal() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWith = context.screenWidth;
    //! usando o material para definir a base do modal
    return Material(
      color: Colors.black26,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        elevation: 10.0,
        child: Container(
          width: screenWith * (screenWith > 1200 ? .5 : .7),
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Detalhe do Pedido',
                        style: context.textStyle.textTitle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: _closeModal,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Nome Cliente: ',
                      style: context.textStyle.textBold,
                    ),
                    const SizedBox(width: 20),
                    Text(widget.order.user.name,
                        style: context.textStyle.textRegular),
                  ],
                ),
                const Divider(),
                ...widget.order.orderProducts
                    .map((op) => OrderProductItem(orderProduct: op))
                    .toList(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total do Pedido',
                        style: context.textStyle.textExtraBold
                            .copyWith(fontSize: 18.0),
                      ),
                      //! ------------------------
                      //! varrendo todos os dados, inclusive somando todos eles
                      //! REDUCE ou .fold
                      Text(
                        widget.order.orderProducts
                            .fold<double>(
                                0.0,
                                (previousValue, p) =>
                                    previousValue + p.totalPrice)
                            .currencyPTBR,
                        style: context.textStyle.textExtraBold
                            .copyWith(fontSize: 18.0),
                      ),
                      //! ------------------------
                    ],
                  ),
                ),
                const Divider(),
                OrderInfoTile(
                  label: 'Enderço de Entrega:',
                  info: widget.order.address,
                ),
                const Divider(),
                OrderInfoTile(
                  label: 'Forma de pagamento:',
                  info: widget.order.paymentTypeModel.name,
                ),
                const SizedBox(height: 10),
                OrderBottomBar(
                  controller: widget.controller,
                  order: widget.order,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
