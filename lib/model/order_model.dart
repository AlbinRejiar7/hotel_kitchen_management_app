import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? orderId;
  String? dishName;
  String? quantity;
  Timestamp? createdAt;
  String? orderStatus; // Added field for order status

  OrderModel({
    this.orderId,
    this.dishName,
    this.quantity,
    this.createdAt,
    this.orderStatus,
  });

  factory OrderModel.fromMap(Map<String, dynamic>? map) {
    return OrderModel(
      orderId: map?['orderId'],
      dishName: map?['dishName'],
      quantity: map?['quantity'],
      createdAt: map?['createdAt'],
      orderStatus: map?['orderStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'dishName': dishName,
      'quantity': quantity,
      'createdAt': createdAt,
      'orderStatus': orderStatus,
    };
  }

  Future<void> updateOrder() async {
    if (orderId != null) {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update(toMap());
    }
  }
}
