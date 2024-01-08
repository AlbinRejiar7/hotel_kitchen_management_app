import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  String itemId;
  String itemName;
  String quantity;
  String unitOfMeasure;
  String imageUrl;

  InventoryItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitOfMeasure,
    required this.imageUrl,
  });

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      itemId: map['itemId'],
      itemName: map['itemName'],
      quantity: map['quantity'],
      unitOfMeasure: map['unitOfMeasure'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'quantity': quantity,
      'unitOfMeasure': unitOfMeasure,
      'imageUrl': imageUrl,
    };
  }

  Future<void> updateItem() async {
    await FirebaseFirestore.instance
        .collection('inventory')
        .doc(itemId)
        .update(toMap());
  }
}
