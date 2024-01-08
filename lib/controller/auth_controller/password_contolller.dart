import 'package:flutter/material.dart';

class PasswordProvider with ChangeNotifier {
  bool isvisible = true;
  void isVisible(bool obscureText) {
    isvisible = !obscureText;
    notifyListeners();
  }
}
