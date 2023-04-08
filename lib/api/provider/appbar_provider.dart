import 'package:flutter/material.dart';

import '../../views/widgets/animated_app_bar.dart';
import '../../views/widgets/normal_app_bar.dart';

class AppBarProvider extends ChangeNotifier {
  PreferredSizeWidget _selected = const NormalAppBar();
  PreferredSizeWidget get selected => _selected;

  void setSelectedAppBar(int value) {
    switch (value) {
      case 0:
        _selected = const NormalAppBar();
        break;

      case 1:
        _selected = const AnimatedAppBar();
        break;

      default:
        _selected = const NormalAppBar();
    }
    notifyListeners();
  }
}
