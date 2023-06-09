import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/widgets/animated_app_bar.dart';
import '../../views/widgets/normal_app_bar.dart';

class AppBarProvider extends ChangeNotifier {
  final String themePreferenceKey = 'appBar_preference';
  Widget _selected = const NormalAppBar();
  Widget get selected => _selected;

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themePreference = prefs.getInt(themePreferenceKey) ?? 0;
    setSelectedAppBar(themePreference);
  }

  setPref(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themePreferenceKey, value);
  }

  AppBarProvider() {
    getPref();
  }

  void setSelectedAppBar(int value) {
    switch (value) {
      case 0:
        _selected = const AnimatedAppBar();

        break;

      case 1:
        _selected = const NormalAppBar();
        break;

      default:
        _selected = const AnimatedAppBar();
    }

    setPref(value);
    notifyListeners();
  }
}
