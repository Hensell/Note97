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
        _selectedTheme = lightTheme;
        break;
      case 1:
        _selectedTheme = darkTheme;
        break;
      case 2:
        _selectedTheme = redTheme;
        break;
      default:
        _selectedTheme = darkTheme;
    }
    notifyListeners();
  }

  final ThemeData darkTheme = ThemeData(
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

  final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: const Color(0xff201A19));

  final ThemeData redTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorSchemeSeed: Colors.green);
}
