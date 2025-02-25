import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeProvider extends ChangeNotifier { 
  bool isDarkMode = false;
  late SharedPreferences prefs;

  DarkModeProvider() {
    initDarkMode();
  }

  void initDarkMode() async {
    prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  void updateDarkModePreference() async {
    await prefs.setBool('darkMode', isDarkMode);
  }

  void setDarkMode() {
    isDarkMode = true;
    updateDarkModePreference();
    notifyListeners();
  }

  void setLightMode() {
    isDarkMode = false;
    updateDarkModePreference();
    notifyListeners();
  }
}