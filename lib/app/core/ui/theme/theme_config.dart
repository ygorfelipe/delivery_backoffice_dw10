import '../styles/text_styles.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import '../styles/colors_app.dart';

class ThemeConfig {
  ThemeConfig._();

  static final _defultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: Colors.grey[400]!),
  );

  static final theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsApp.instance.primaryColor,
      primary: ColorsApp.instance.primaryColor,
      secondary: ColorsApp.instance.seconderyColor,
    ),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: AppStyles.instance.primaryButton),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.all(20),
      border: _defultInputBorder,
      enabledBorder: _defultInputBorder,
      focusedBorder: _defultInputBorder,
      labelStyle: TextStyles.instance.textRegular.copyWith(color: Colors.black),
      errorStyle:
          TextStyles.instance.textRegular.copyWith(color: Colors.redAccent),
          
    ),
  );
}
