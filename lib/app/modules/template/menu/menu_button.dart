import 'package:flutter/material.dart';

import '../../../core/ui/styles/text_styles.dart';
import 'menu_enum.dart';

class MenuButton extends StatelessWidget {
  //* passando o enum do menu para poder fazer a chamada dele na tela do menuBar
  final Menu menu;
  final Menu? menuSelected;
  final ValueChanged<Menu> onPressed;

  const MenuButton({
    super.key,
    required this.menu,
    this.menuSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = menuSelected == menu;
    //* aqui foi adicionado o visibility para poder utilizar o visible com a constrains max
    //* e tbm o replacement com um icon para quando for menor que 90 ele aparecer apenas o icon e não o texto
    //* foi adicionado tbm o tooltip, ele fica responsavel por passar o cursor do mouse em cima do icon e ele informar qual é o nome do mesmo

    return LayoutBuilder(
      builder: (_, constrains) {
        return Visibility(
          visible: constrains.maxWidth != 90,
          replacement: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0XFFFFF5E2),
                  )
                : null,
            //! recomendo o tooltip apenas para web
            child: Tooltip(
              message: menu.label,
              child: IconButton(
                onPressed: () => onPressed(menu),
                icon: Image.asset(
                    'assets/images/icons/${isSelected ? menu.assetIconSelected : menu.assetIcon}'),
              ),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onPressed(menu),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: isSelected
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0XFFFFF5E2),
                      )
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                          'assets/images/icons/${isSelected ? menu.assetIconSelected : menu.assetIcon}'),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                        child: Text(
                      menu.label,
                      overflow: TextOverflow.ellipsis,
                      style: (isSelected
                          ? context.textStyle.textBold
                          : context.textStyle.textRegular),
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
