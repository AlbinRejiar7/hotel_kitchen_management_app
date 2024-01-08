import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/model/chef_model.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';

class ChoosechefPage extends StatelessWidget {
  final String oderId;
  final String itemName;
  final String quantity;
  const ChoosechefPage({
    super.key,
    required this.oderId,
    required this.itemName,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("choose your chef"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chefs').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              List<ChefModel> chefList =
                  snapshot.data!.docs.map<ChefModel>((doc) {
                return ChefModel.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                padding: EdgeInsets.all(10),
                itemCount: chefList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      sendOrderToChef(
                          chefId: chefList[index].id ?? "null",
                          orderId: oderId,
                          context: context,
                          dishname: itemName,
                          quantity: quantity,
                          chefName: chefList[index].name ?? "null");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorConst.customWhite,
                      ),
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Text(
                          "${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        title: Text(
                          chefList[index].name ?? "null",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text("data");
            }
          }),
    );
  }

  void sendOrderToChef({
    required BuildContext context,
    required String dishname,
    required String quantity,
    required String chefName,
    required String chefId,
    required String orderId,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Order to Chef'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chef: $chefName'),
              kHeight(10),
              Text('Dish Name: $dishname'),
              Text('Quantity: $quantity'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  Map<String, dynamic> newOrder = {
                    'dishName': itemName,
                    'quantity': quantity,
                    'orderId': orderId,
                  };
                  await FirebaseFirestore.instance
                      .collection('chefs')
                      .doc(chefId)
                      .update({
                    'orders': FieldValue.arrayUnion([newOrder]),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Succesfully sended")));
                } on FirebaseException catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message!)));
                }

                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
