import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/formatter_extensions.dart';
import '../../../../core/ui/styles/text_styles.dart';
import '../../../../dto/order/order_product_dto.dart';

class OrderProductItem extends StatelessWidget {
  final OrderProductDto orderProduct;
  const OrderProductItem({super.key, required this.orderProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Text(
            orderProduct.product.name,
            style: context.textStyle.textRegular,
          )),
          Text(orderProduct.amount.toString(),
              style: context.textStyle.textRegular),
          Expanded(
            child: Text(orderProduct.totalPrice.currencyPTBR,
                textAlign: TextAlign.end, style: context.textStyle.textRegular),
          ),
        ],
      ),
    );
  }
}
