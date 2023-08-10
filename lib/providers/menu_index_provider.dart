import 'package:flutter/material.dart';

class MenuIndexProvider extends ChangeNotifier {
  int currentIndex = 0;

  set(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
