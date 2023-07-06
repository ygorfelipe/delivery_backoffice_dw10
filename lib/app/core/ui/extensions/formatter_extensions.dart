import 'package:brasil_fields/brasil_fields.dart';

//* extensions criada para pegar o valor de reais e adicionar a mascara nos valores
//* no itemCard é possível ver como foi utilizado, no Text onde foi colocado o R$
extension FormatterExtensions on double {
  String get currencyPTBR => UtilBrasilFields.obterReal(this);
}
