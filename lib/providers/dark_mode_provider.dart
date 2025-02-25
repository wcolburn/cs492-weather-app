import 'package:flutter/material.dart';

class DarkModeProvider extends ChangeNotifier { 
  bool isDarkMode = false;

  void setDarkMode() {
    isDarkMode = true;
    notifyListeners();
  }

  void setLightMode() {
    isDarkMode = false;
    notifyListeners();
  }
}