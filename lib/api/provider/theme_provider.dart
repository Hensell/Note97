import 'package:flutter/material.dart';

class ThemesProvider with ChangeNotifier {
  ThemeData _selectedTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xff201A19),
      fontFamily: "Roboto Slab",
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
          )));

  ThemeData get selectedTheme => _selectedTheme;

  void setSelectedTheme(int value) {
    switch (value) {
      case 0:
        _selectedTheme = lightTheme();

        break;
      case 1:
        _selectedTheme = darkTheme();

        break;
      case 2:
        _selectedTheme = greenTheme();

        break;
      default:
        _selectedTheme = darkTheme();
    }
    notifyListeners();
  }

  darkTheme() {
    AppColors.customContainer = const Color(0xffFFB4A3);
    AppColors.backgroud = const Color(0xffFFB4A3);
    AppColors.shadowColor = const Color(0xff611201);
    AppColors.fontColor = const Color(0xff611201);
    AppColors.iconColor = const Color(0xff611201);

    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xff201A19),
        /*colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xff611201),
            onPrimary: Color(0xffFFB4A3),
            secondary: Color(0xffFFB4A3),
            onSecondary: Color(0xffFFB4A3),
            error: Color(0xffFFB4A3),
            onError: Color(0xffFFB4A3),
            background: Colors.blue,
            onBackground: Color(0xffFFB4A3),
            surface: Color(0xffFFB4A3),
            onSurface: Color(0xffFFB4A3)),*/
        fontFamily: "Roboto Slab",
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            )));
  }

  lightTheme() {
    AppColors.customContainer = Colors.white;
    AppColors.backgroud = Colors.white;
    AppColors.shadowColor = Colors.black;
    AppColors.fontColor = Colors.black;
    AppColors.iconColor = const Color(0xffFFB4A3);
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xff201A19),
        fontFamily: "Roboto Slab",
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            )));
  }

  greenTheme() {
    AppColors.customContainer = Colors.green;
    AppColors.backgroud = Colors.green;

    AppColors.fontColor = Colors.black;
    AppColors.iconColor = const Color(0xff0e5f20);

    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
        fontFamily: "Roboto Slab",
        shadowColor: const Color(0xff0e5f20),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            )));
  }
}

class AppColors {
  /* Default colors */
  static Color primary = Color(0xFF6200EE);
  static Color customContainer = Color(0xffFFB4A3);
  static Color backgroud = Color(0xffFFB4A3);
  static Color shadowColor = Color(0xff201A19);
  static Color fontColor = Color(0xff201A19);
  static Color iconColor = Color(0xff201A19);
}
