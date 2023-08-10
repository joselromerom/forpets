import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  String iconsColor = "Amarillo";

  ThemeData themeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFFFFF),
      textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black)),
      iconTheme: const IconThemeData.fallback());

  getTheme() => themeData;

  setTheme(ThemeData theme) {
    themeData = theme;
    notifyListeners();
  }

  setColor(String color) {
    iconsColor = color;
    notifyListeners();
  }
}
