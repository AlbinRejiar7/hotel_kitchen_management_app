// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/controller/inventory_controller.dart';
import 'package:hotel_kitchen_management_app/utils/mediaquery.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/inventory_pages/add_inventory_item_screen.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/inventory_pages/inventory_update_screen.dart';
import 'package:hotel_kitchen_management_app/view/empty_screen.dart';
import 'package:provider/provider.dart';

import '../../../model/inventory_model.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var inventoryProvider = Provider.of<InventoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Screen"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, SlidePageRoute(page: AddItemPage()));
              },
              icon: Icon(Icons.add_circle_outline_sharp)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.active) {
            inventoryProvider.invItems = snapshot.data?.docs
                .map<InventoryItem>((doc) => InventoryItem.fromMap(doc.data()))
                .toList();
            return inventoryProvider.invItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: inventoryProvider.invItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final reversedIndex =
                            inventoryProvider.invItems.length - 1 - index;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: CustomeSize.customHeight(context) * 0.5,
                            width: CustomeSize.customWidth(context) * 0.5,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(82, 137, 192, 64),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          CustomeSize.customHeight(context) *
                                              0.13,
                                      child: Image.network(
                                        fit: BoxFit.cover,
                                        inventoryProvider
                                            .invItems[reversedIndex].imageUrl,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  SlidePageRoute(
                                                      page: ItemUpdatePage(
                                                    index: reversedIndex,
                                                  )));
                                            },
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            title: const Text(
                                                                "Are you sure you want to delete this Item ?"),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "No")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "inventory")
                                                                          .doc(
                                                                            inventoryProvider.invItems[reversedIndex].itemId,
                                                                          )
                                                                          .delete()
                                                                          .then((value) =>
                                                                              Navigator.pop(context));

                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              const SnackBar(content: Text("Successfully Deleted")));
                                                                    } on FirebaseException catch (e) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text(e.message!)));
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "Yes"))
                                                            ],
                                                          ));
                                            },
                                            icon: Icon(Icons.delete))
                                      ],
                                    )
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        inventoryProvider
                                            .invItems[reversedIndex].itemName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "x ${inventoryProvider.invItems[reversedIndex].quantity} ${inventoryProvider.invItems[reversedIndex].unitOfMeasure} ",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : EmptyScreen(
                    text: "inventory",
                  );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
