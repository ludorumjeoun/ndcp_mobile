import 'package:flutter/material.dart';

mixin AppColors {
  // Header Background: #2F3A79
  static const headerBackground = Color.fromARGB(255, 0x2F, 0x3A, 0x79);
  // Header Text: #A1BBFF
  static const headerText = Color.fromARGB(255, 0xA1, 0xBB, 0xFF);
  // Header Primary : #FFFFFF
  static const headerPrimary = Colors.white;

  // Background Color: #10141B;
  static const background = Color.fromARGB(255, 0x10, 0x14, 0x1B);
  // Secondary Background for opacity: rgba(255, 255, 255, 0x20)
  static const secondaryBackground = Color.fromARGB(0x20, 0xFF, 0xFF, 0xFF);
  // Primary Text: #FFFFFF
  static const primaryText = Colors.white;
  // Secondary Text: #A1BBFF
  static const secondaryText = Color.fromARGB(255, 0xA1, 0xBB, 0xFF);
  // Button Background: #3F5285;
  static const buttonBackground = Color.fromARGB(255, 0x3F, 0x52, 0x85);
  static const buttonText = primaryText;

  // Border Primary Color: #2F3A79
  static const borderPrimary = Color.fromARGB(255, 0xA1, 0xBB, 0xFF);
  // Border Error Color #FF0000
  static const borderError = Color.fromARGB(255, 0xFF, 0x00, 0x00);
  // Border Success Color #00FF00
  static const borderSuccess = Color.fromARGB(255, 0x00, 0xFF, 0x00);
  // Border Warning Color #FFA500
  static const borderWarning = Color.fromARGB(255, 0xFF, 0xA5, 0x00);
  // Border Disabled Color #808080
  static const borderDisabled = Color.fromARGB(255, 0x80, 0x80, 0x80);
}

mixin AppTextStyle {
  static const primary = TextStyle(
      color: AppColors.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.normal);
  static const secondary = TextStyle(
      color: AppColors.secondaryText,
      fontSize: 14,
      fontWeight: FontWeight.normal);
  static const headerTitle = TextStyle(
      color: AppColors.headerText, fontSize: 14, fontWeight: FontWeight.bold);
}

mixin AppTheme {
  static final colorScheme = ColorScheme.fromSwatch().copyWith(
    primary: AppColors.primaryText,
    secondary: AppColors.secondaryText,
    background: AppColors.background,
    primaryContainer: AppColors.headerBackground,
    brightness: Brightness.dark,
  );
  static final theme = ThemeData(
      backgroundColor: AppColors.headerBackground,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryText,
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        bodyText1: AppTextStyle.primary,
        bodyText2: AppTextStyle.secondary,
        button: AppTextStyle.primary,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.headerBackground,
        elevation: 0,
      ),
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.headerPrimary,
        titleTextStyle: AppTextStyle.headerTitle,
      ),
      buttonTheme:
          const ButtonThemeData(buttonColor: AppColors.buttonBackground),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBackground,
          textStyle: AppTextStyle.primary,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: AppTextStyle.secondary,
        hintStyle: AppTextStyle.secondary,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: AppColors.primaryText,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: AppColors.borderPrimary,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: AppColors.borderError,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: AppColors.borderError,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: AppColors.borderDisabled,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: AppColors.borderPrimary,
          ),
        ),
      ));
  static final textTheme = theme.textTheme;
  static final appBarTheme = theme.appBarTheme;
  static final buttonTheme = theme.buttonTheme;
  static final elevatedButtonTheme = theme.elevatedButtonTheme;
}
