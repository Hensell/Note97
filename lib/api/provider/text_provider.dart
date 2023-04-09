import 'package:flutter/material.dart';

class TextProvider extends ChangeNotifier {
  final TextEditingController _textEditingController = TextEditingController();

  void updateText(String newText) {
    _textEditingController.text = newText;
    notifyListeners();
  }

  void clearText() {
    _textEditingController.clear();
    notifyListeners();
  }

  TextEditingController get textEditingController => _textEditingController;
}
