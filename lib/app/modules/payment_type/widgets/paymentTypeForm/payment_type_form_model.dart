import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/size_extensions.dart';
import '../../../../core/ui/styles/text_styles.dart';
import '../../../../models/payment_type_model.dart';
import '../../payment_type_controller.dart';

class PaymentTypeFormModel extends StatefulWidget {
  final PaymentTypeModel? model;
  final PaymentTypeController controller;

  const PaymentTypeFormModel({
    super.key,
    required this.model,
    required this.controller,
  });

  @override
  State<PaymentTypeFormModel> createState() => _PaymentTypeFormModelState();
}

class _PaymentTypeFormModelState extends State<PaymentTypeFormModel> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final acronymEC = TextEditingController();
  var enabled = false;

  void _closeModal() => Navigator.of(context).pop();

  //* trazendo os dados se ja houver carregado

  @override
  void initState() {
    final paymentModel = widget.model;
    if (paymentModel != null) {
      nameEC.text = paymentModel.name;
      acronymEC.text = paymentModel.acronym;
      enabled = paymentModel.enabled;
    }
    super.initState();
  }

  //! não esquecer de fazer os dispose dos textEdit controller NUNCA!
  //! POIS SEI QUE TEM PROJETOS QUE NAO TEM OS DISPOSE NELES!
  @override
  void dispose() {
    nameEC.dispose();
    acronymEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return SingleChildScrollView(
      child: Container(
        width: screenWidth * (screenWidth > 1200 ? .5 : .7),
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    //* aqui foi feito a verificação da modal para ver se foi clicado no adicionar ou no editar.
                    child: Text(
                      '${widget.model == null ? 'Adicionar' : 'Editar'} forma de pagamento',
                      textAlign: TextAlign.center,
                      style: context.textStyle.textTitle,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _closeModal,
                      child: const Icon(Icons.close),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameEC,
                validator: Validatorless.required('Nome obrigatório'),
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: acronymEC,
                validator: Validatorless.required('Sigla obrigatória'),
                decoration: const InputDecoration(
                  label: Text('Sigla'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Ativo:', style: context.textStyle.textRegular),
                  Switch(
                    value: enabled,
                    onChanged: (value) {
                      setState(() {
                        enabled = value;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    child: OutlinedButton(
                      onPressed: _closeModal,
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red)),
                      child: Text(
                        'Cancelar',
                        style: context.textStyle.textBold
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          final valid =
                              formKey.currentState?.validate() ?? false;
                          if (valid) {
                            final name = nameEC.text;
                            final acronym = acronymEC.text;
                            widget.controller.savePayment(
                              id: widget.model?.id,
                              name: name,
                              acronym: acronym,
                              enabled: enabled,
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
