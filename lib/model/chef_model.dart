import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_model.dart';

class ChefModel {
  String? id;
  String? name;
  String? email;
  Timestamp? createdAt;
  List<OrderModel>? orders;

  ChefModel({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.orders,
  });

  factory ChefModel.fromMap(Map<String, dynamic> map) {
    List<OrderModel>? ordersList =
        (map['orders'] as List<dynamic>?)?.map<OrderModel>((order) {
      return OrderModel.fromMap(order);
    }).toList();

    return ChefModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: map['createdAt'],
      orders: ordersList,
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>>? ordersList =
        orders?.map((order) => order.toMap()).toList();

    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'orders': ordersList,
    };
  }

  Future<void> updateChef() async {
    if (id != null) {
      await FirebaseFirestore.instance
          .collection('chefs')
          .doc(id)
          .update(toMap());
    }
  }
}
