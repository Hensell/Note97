import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemesProvider with ChangeNotifier {
  final String themePreferenceKey = 'theme_preference';

  ThemeData _selectedTheme = ThemeData(
      useMaterial3: true,
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(),
        color: Color(0xffFFB4A3),
        surfaceTintColor: Colors.transparent,
        shadowColor: Color(0xff611201),
        elevation: 1,
      ),
      colorScheme: const ColorScheme(
          primaryContainer: Color(0xff611201),
          onPrimaryContainer: Color(0xffFFB4A3),
          brightness: Brightness.dark,
          primary: Color(0xffFFB4A3),
          onPrimary: Color(0xffFFB4A3),
          secondary: Color(0xff611201),
          onSecondary: Color(0xff611201),
          error: Colors.blue,
          onError: Colors.blue,
          background: Color(0xffFFB4A3),
          onBackground: Color(0xffFFB4A3),
          surface: Color(0xff611201),
          onSurface: Color(0xffFFB4A3)),
      fontFamily: "Roboto Slab",
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: Color(0xffFFB4A3)), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
          ),
          hintStyle: const TextStyle(fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: Color(0xffFFB4A3)), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: Color(0xffFFB4A3)), //<-- SEE HERE
            borderRadius: BorderRadius.circular(50.0),
          )));

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themePreference = prefs.getInt(themePreferenceKey) ?? 0;
    setSelectedTheme(themePreference);
  }

  setPref(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themePreferenceKey, value);
  }

  ThemesProvider() {
    getPref();
  }

  ThemeData get selectedTheme => _selectedTheme;

  void setSelectedTheme(int value) {
    switch (value) {
      case 0:
        _selectedTheme = darkTheme();
        break;

      case 1:
        _selectedTheme = greenTheme();
        break;

      case 2:
        _selectedTheme = nightTheme();
        break;

      case 3:
        _selectedTheme = eightbitTheme();
        break;
      default:
        _selectedTheme = darkTheme();
    }

    setPref(value);
    notifyListeners();
  }

  greenTheme() {
    return ThemeData(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0), //<-- SEE HERE
          ),
          color: const Color(0xFFF5F5F5),
          surfaceTintColor: Colors.transparent,
          shadowColor: const Color(0xFF0A1172),
          elevation: 1,
        ),
        useMaterial3: true,
        colorScheme: const ColorScheme(
            primaryContainer: Color(0xff0e5f20),
            onPrimaryContainer: Color(0xFFF5F5F5),
            brightness: Brightness.light,
            primary: Color(0xFFF5F5F5),
            onPrimary: Color(0xFFF5F5F5),
            secondary: Color(0xFF0A1172),
            onSecondary: Color(0xFF0A1172),
            error: Colors.blue,
            onError: Colors.blue,
            background: Color(0xFFF5F5F5),
            onBackground: Color(0xFFF5F5F5),
            surface: Color(0xff0e5f20),
            onSurface: Color(0xFFF5F5F5)),
        fontFamily: "Timew new roman",
        textTheme: const TextTheme(displayLarge: TextStyle(letterSpacing: 5)),
        shadowColor: const Color(0xff0e5f20),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w500, color: Color(0xFFF5F5F5)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(0.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffD2C6C3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(0.0),
            )));
  }

  darkTheme() {
    return ThemeData(
        useMaterial3: true,
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(),
          color: Color(0xffFFB4A3),
          surfaceTintColor: Colors.transparent,
          shadowColor: Color(0xff611201),
          elevation: 1,
        ),
        colorScheme: const ColorScheme(
            primaryContainer: Color(0xff611201),
            onPrimaryContainer: Color(0xffFFB4A3),
            brightness: Brightness.dark,
            primary: Color(0xffFFB4A3),
            onPrimary: Color(0xffFFB4A3),
            secondary: Color(0xff611201),
            onSecondary: Color(0xff611201),
            error: Colors.blue,
            onError: Colors.blue,
            background: Color(0xffFFB4A3),
            onBackground: Color(0xffFFB4A3),
            surface: Color(0xff611201),
            onSurface: Color(0xffFFB4A3)),
        fontFamily: "Roboto Slab",
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffFFB4A3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            ),
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffFFB4A3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Color(0xffFFB4A3)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(50.0),
            )));
  }

  nightTheme() {
    return ThemeData(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
          ),
          color: const Color(0xff6750a4),
          surfaceTintColor: Colors.transparent,
          shadowColor: const Color(0xff1d0042),
          elevation: 1,
        ),
        useMaterial3: true,
        colorScheme: const ColorScheme(
            tertiary: Color(0xff1d0042),
            primaryContainer: Color(0xff1d0042),
            onPrimaryContainer: Color(0xff6750a4),
            brightness: Brightness.dark,
            primary: Color(0xff6750a4),
            onPrimary: Color(0xff6750a4),
            secondary: Color(0xff1d0042),
            onSecondary: Color(0xff1d0042),
            error: Colors.blue,
            onError: Colors.blue,
            background: Color(0xff6750a4),
            onBackground: Color(0xff6750a4),
            surface: Color(0xff1d0042),
            onSurface: Color(0xff6750a4)),
        fontFamily: "Roboto Flex",
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 3, color: Color(0xff6750a4)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 3, color: Color(0xff6750a4)), //<-- SEE HERE
              borderRadius: BorderRadius.circular(5.0),
            )));
  }

  eightbitTheme() {
    return ThemeData(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), //<-- SEE HERE
          ),
          color: const Color(0xff9bbc0f),
          surfaceTintColor: Colors.transparent,
          shadowColor: const Color(0xff0f380f),
          elevation: 1,
        ),
        useMaterial3: true,
        colorScheme: const ColorScheme(
          tertiary: Color(0xff0f380f),
          primaryContainer: Color(0xff0f380f),
          onPrimaryContainer: Color(0xff9bbc0f),
          brightness: Brightness.dark,
          primary: Color(0xff9bbc0f),
          onPrimary: Color(0xff9bbc0f),
          secondary: Color(0xff0f380f),
          onSecondary: Color(0xff0f380f),
          error: Colors.blue,
          onError: Colors.blue,
          background: Color(0xff9bbc0f),
          onBackground: Color(0xff9bbc0f),
          surface: Color(0xff0f380f),
          onSurface: Color(0xff9bbc0f),
        ),
        fontFamily: "Roboto Flex",
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(fontWeight: FontWeight.w500),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
                color: Color(0xff9bbc0f),
              ), //<-- SEE HERE
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
                color: Color(0xff9bbc0f),
              ), //<-- SEE HERE
              borderRadius: BorderRadius.circular(5.0),
            )));
  }
}
