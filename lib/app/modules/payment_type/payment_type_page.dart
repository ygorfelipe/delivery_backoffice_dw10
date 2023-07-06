import 'widgets/paymentTypeForm/payment_type_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import 'payment_type_controller.dart';
import 'widgets/payment_type_header.dart';
import 'widgets/payment_type_item.dart';

class PaymentTypePage extends StatefulWidget {
  const PaymentTypePage({super.key});

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with Loader, Messages {
  final controller = Modular.get<PaymentTypeController>();

  final disposers = <ReactionDisposer>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //* esse filterDisposer foi criado, para não ter que ser utilizado na na controller, sendo assim possível criar vários disposers e adicionar em uma lista
      final filterDisposer = reaction((_) => controller.filterEnabled, (_) {
        controller.loadPayments();
      });
      final statusDisposer = reaction((_) => controller.status, (status) {
        switch (status) {
          case PaymentTypeStateStatus.initial:
            break;
          case PaymentTypeStateStatus.loading:
            showLoader();
            break;
          case PaymentTypeStateStatus.loaded:
            hideLoader();
            break;
          case PaymentTypeStateStatus.error:
            hideLoader();
            showErro(controller.errorMessage ??
                'Erro ao buscar formas de Pagamentos');
            break;
          case PaymentTypeStateStatus.addOrUpdatePayment:
            hideLoader();
            showAddOrUpdatePayment();
            break;
          case PaymentTypeStateStatus.saved:
            hideLoader();
            Navigator.of(context, rootNavigator: true).pop();
            controller.loadPayments();
            break;
        }
      });
      //* aqi é a lista dos disposers, onde que podemos chamar vários disposers
      disposers.addAll([statusDisposer, filterDisposer]);
      controller.loadPayments();
    });
  }

  //* aqui é a chamada da lista de disposers para fazermos disposer, sendo assim, é necessário criar um void dispose() para poder fechar todos eles
  //* é o brigatorio utilizar um for, para poder fechar todos eles.
  @override
  void dispose() {
    for (final dispose in disposers) {
      dispose();
    }
    super.dispose();
  }

  //* aqui nos criando um metodo para alterar ou incluir, no caso seria para adicionar ou alterar a forma de pagamento
  //* sera necessário chamar ele em dois lugares, no primeiro seria no btnAdicionar no canto superior direito, e no editar no card
  void showAddOrUpdatePayment() {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.black26,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              elevation: 10,
              child: PaymentTypeFormModel(
                model: controller.paymentTypeSelected,
                controller: controller,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          PaymentTypeHeader(controller: controller),
          const SizedBox(height: 50),
          Expanded(
            child: Observer(builder: (_) {
              return GridView.builder(
                itemCount: controller.paymentTypes.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 120,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  maxCrossAxisExtent: 680,
                ),
                padding: const EdgeInsets.only(left: 20),
                itemBuilder: (context, index) {
                  final paymentTypeModel = controller.paymentTypes[index];
                  return PaymentTypeItem(
                      payment: paymentTypeModel, controller: controller);
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
