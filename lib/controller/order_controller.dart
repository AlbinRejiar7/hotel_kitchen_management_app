import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  int quantity = 1;
  String status = 'pending';
  void incrementQunatity() {
    quantity++;
    notifyListeners();
  }

  void decrementquantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  void changeStatus(String newValue) {
    status = newValue;
    notifyListeners();
  }
}
