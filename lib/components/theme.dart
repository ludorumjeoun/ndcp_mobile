import 'package:flutter/material.dart';
import 'package:ndcp_mobile/services/auth/client_type.dart';

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

class BackgoundAndForegroundColors {
  final Color background;
  final Color foreground;
  BackgoundAndForegroundColors(this.background, this.foreground);
}
mixin AppTheme {
  static final colorScheme = ColorScheme.fromSwatch().copyWith(
    primary: AppColors.primaryText,
    secondary: AppColors.secondaryText,
    background: AppColors.background,
    primaryContainer: AppColors.headerBackground,
    brightness: Brightness.dark,
  );
  static final darkTableColors = [
    //background: #273149;
    const Color.fromRGBO(0x27, 0x31, 0x49, 1),
    //background: #18202E;
    const Color.fromRGBO(0x18, 0x20, 0x2E, 1),
  ];
  static final tableSwatch = [
    BackgoundAndForegroundColors(
      const Color.fromRGBO(0x18, 0x20, 0x2E, 1),
      const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1),
    ),
    BackgoundAndForegroundColors(
      const Color.fromRGBO(0x27, 0x31, 0x49, 1),
      const Color.fromRGBO(0xC7, 0xD7, 0xFF, 1),
    ),
    BackgoundAndForegroundColors(
      const Color.fromRGBO(0x10, 0x14, 0x1B, 1),
      const Color.fromRGBO(0xC7, 0xD7, 0xFF, 1),
    ),
    BackgoundAndForegroundColors(
      const Color.fromRGBO(0x2F, 0x3A, 0x79, 1),
      const Color.fromRGBO(0xC7, 0xD7, 0xFF, 1),
    )
  ];
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    cardTheme: const CardTheme(
      color: Color.fromRGBO(0x18, 0x20, 0x2E, 1),
      // Rounded Rectangle with 16px radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    primaryColor: AppColors.background,
    primarySwatch: MaterialColor(
      AppColors.headerBackground.value,
      <int, Color>{
        50: AppColors.headerBackground.withOpacity(0.05),
        100: AppColors.headerBackground.withOpacity(0.1),
        200: AppColors.headerBackground.withOpacity(0.2),
        300: AppColors.headerBackground.withOpacity(0.3),
        400: AppColors.headerBackground.withOpacity(0.4),
        500: AppColors.headerBackground.withOpacity(0.5),
        600: AppColors.headerBackground.withOpacity(0.6),
        700: AppColors.headerBackground.withOpacity(0.7),
        800: AppColors.headerBackground.withOpacity(0.8),
        900: AppColors.headerBackground.withOpacity(0.9),
      },
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: AppColors.headerText,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        toolbarTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.headerBackground,
        foregroundColor: Colors.white),
  );
  static final brightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.background,
    primarySwatch: MaterialColor(
      AppColors.headerBackground.value,
      <int, Color>{
        50: AppColors.headerBackground.withOpacity(0.05),
        100: AppColors.headerBackground.withOpacity(0.1),
        200: AppColors.headerBackground.withOpacity(0.2),
        300: AppColors.headerBackground.withOpacity(0.3),
        400: AppColors.headerBackground.withOpacity(0.4),
        500: AppColors.headerBackground.withOpacity(0.5),
        600: AppColors.headerBackground.withOpacity(0.6),
        700: AppColors.headerBackground.withOpacity(0.7),
        800: AppColors.headerBackground.withOpacity(0.8),
        900: AppColors.headerBackground.withOpacity(0.9),
      },
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: AppColors.headerText,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: AppColors.headerBackground,
      foregroundColor: Colors.white,
    ),
  );
  static ThemeData themeByClientType(ClientType type) {
    if (type == ClientType.doctor) {
      return darkTheme;
    }
    if (type == ClientType.patient) {
      return brightTheme;
    }
    return darkTheme;
  }

  static final theme = ThemeData(
      backgroundColor: AppColors.headerBackground,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.background,
      primarySwatch: MaterialColor(
        AppColors.headerBackground.value,
        <int, Color>{
          50: AppColors.headerBackground.withOpacity(0.05),
          100: AppColors.headerBackground.withOpacity(0.1),
          200: AppColors.headerBackground.withOpacity(0.2),
          300: AppColors.headerBackground.withOpacity(0.3),
          400: AppColors.headerBackground.withOpacity(0.4),
          500: AppColors.headerBackground.withOpacity(0.5),
          600: AppColors.headerBackground.withOpacity(0.6),
          700: AppColors.headerBackground.withOpacity(0.7),
          800: AppColors.headerBackground.withOpacity(0.8),
          900: AppColors.headerBackground.withOpacity(0.9),
        },
      ),
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
