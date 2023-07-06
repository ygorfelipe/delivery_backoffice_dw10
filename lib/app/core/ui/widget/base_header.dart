import 'package:flutter/material.dart';

import '../styles/text_styles.dart';

class BaseHeader extends StatelessWidget {
  //* aqui no base header, nos estamos otmizando o header de cada tela
  //* titulo, searchChange e buttonLabel, vai se encontrar em todas as telas sem excessão
  //* no valueCHanged colocado para quando for digitar algo ele recuperar os valores
  //* no caso do Widget nos exemplos, ele sera utilizado com o intuito de
  //! adicionar um textFormField ou um comboBox ou qlqr outro componente

  final String title;
  final ValueChanged<String>? searchChange;
  final String buttonLabel;
  final VoidCallback? buttonPressed;
  final bool addButton;
  final Widget? filterWidget;

  const BaseHeader({
    Key? key,
    required this.title,
    this.searchChange,
    this.buttonLabel = '',
    this.buttonPressed,
    this.addButton = true,
    this.filterWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return Wrap(
          children: [
            Visibility(
              visible: filterWidget == null,
              replacement: filterWidget ?? const SizedBox.shrink(),
              child: SizedBox(
                width: constrains.maxWidth * .15,
                child: TextFormField(
                  onChanged: searchChange,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(
                      Icons.search,
                      size: constrains.maxWidth * 0.02,
                    ),
                    label: Text(
                      'Buscar',
                      style: context.textStyle.textRegular
                          .copyWith(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: constrains.maxWidth * .65,
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: context.textStyle.textTitle.copyWith(
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
              ),
            ),
            Visibility(
              visible: addButton,
              child: SizedBox(
                width: constrains.maxWidth * .15,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: buttonPressed,
                  icon: Icon(
                    Icons.add,
                    size: constrains.maxWidth * 0.02,
                  ),
                  label: FittedBox(child: Text(buttonLabel)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
