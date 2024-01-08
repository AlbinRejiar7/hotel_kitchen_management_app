// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/controller/order_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_chef/sign_in_screen.dart';
import 'package:provider/provider.dart';

class ChefHomePage extends StatefulWidget {
  const ChefHomePage({super.key});

  @override
  State<ChefHomePage> createState() => _ChefHomePageState();
}

class _ChefHomePageState extends State<ChefHomePage> {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  Future<dynamic> _showLogoutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  Text("DO YOU WANT TO LOGOUT?"),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel)),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SingInPageChef()));
                      authInstance.signOut();

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logout Successfull")));
                    },
                    icon: const Icon(Icons.done))
              ],
            ));
  }

  String selectedStatus = 'pending';
  @override
  Widget build(BuildContext context) {
    var statusProvider = Provider.of<OrderProvider>(context);
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    var uid = authInstance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: Icon(Icons.logout))
        ],
        centerTitle: true,
        title: Text("Assigned orders by admin"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('chefs').doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('Chef data not found!');
          }
          var chefData = snapshot.data!.data() as Map<String, dynamic>;
          var orders = chefData['orders'] as List<dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HI,${chefData["name"]}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                kHeight(10),
                Flexible(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      var orderData = orders[index] as Map<String, dynamic>;
                      var dishName = orderData['dishName'];
                      var quantity = orderData['quantity'];
                      return Container(
                        decoration:
                            BoxDecoration(color: ColorConst.customWhite),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text(
                                          "Do you want to change the Status"),
                                      actions: [
                                        DropdownButtonFormField<String>(
                                          value: statusProvider.status,
                                          onChanged: (String? newValue) async {
                                            statusProvider
                                                .changeStatus(newValue!);

                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('orders')
                                                  .doc(orderData['orderId'])
                                                  .update({
                                                'orderStatus': newValue
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Successfuly updated")));
                                              Navigator.pop(context);
                                            } on FirebaseException catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text(e.message!)));
                                            }
                                          },
                                          items: [
                                            'pending',
                                            'approved',
                                            'inprogress',
                                            'ready',
                                          ].map((status) {
                                            return DropdownMenuItem<String>(
                                              value: status,
                                              child: Text(status),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            labelText: 'Select Status',
                                            border: OutlineInputBorder(),
                                          ),
                                        )
                                      ]);
                                });
                          },
                          child: ListTile(
                            title: Text('Dish: $dishName'),
                            subtitle: Text('Quantity: $quantity'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
