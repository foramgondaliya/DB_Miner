import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool istap = false;

  void changetheme(val) {
    istap = !istap;
    notifyListeners();
  }
}
