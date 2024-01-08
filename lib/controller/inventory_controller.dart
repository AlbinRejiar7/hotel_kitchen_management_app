import 'package:flutter/material.dart';

import '../model/inventory_model.dart';

class InventoryProvider with ChangeNotifier {
  String? unit = "kg";
  List<InventoryItem> invItems = [];
  void changeCurrentUnit(String? newValue) {
    unit = newValue;
    notifyListeners();
  }
}
