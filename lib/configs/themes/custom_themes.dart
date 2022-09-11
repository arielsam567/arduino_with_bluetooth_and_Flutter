import 'package:flutter/material.dart';

import 'color_themes.dart';

class CustomThemes {
  static final defaultTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: CustomColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(
            color: CustomColors.white,
        ),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: CustomColors.white,
        ),
      ),
      colorScheme: const ColorScheme(
          onBackground: CustomColors.black,
          onSecondary: CustomColors.secondary,
          onError: CustomColors.white,
          error: CustomColors.white,
          brightness: Brightness.light,
          onPrimary: CustomColors.primary,
          primary: CustomColors.primary,
          background: CustomColors.white,
          onSurface: CustomColors.white,
          surface: CustomColors.white,
          secondary: CustomColors.red
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w700,
          color: CustomColors.primary,
        ),
        headline2: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: CustomColors.white
        ),
        headline3: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
        headline6: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
        headline4: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          color: CustomColors.primary,
        ),
        headline5: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: CustomColors.red
        ),
        button: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: CustomColors.white,
        ),
        bodyText1: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
          color: CustomColors.primary,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: CustomColors.black,
        ),
        labelMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: CustomColors.black,
        ),
        caption: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: CustomColors.white,
        ),
        subtitle2: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
        ),
      ));
}
