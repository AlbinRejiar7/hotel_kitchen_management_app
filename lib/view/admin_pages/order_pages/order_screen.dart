// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_kitchen_management_app/model/order_model.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/empty_screen.dart';
import 'package:hotel_kitchen_management_app/widgets/order_status_color_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/custom_sizedbox.dart';
import 'chef_choosing_page.dart';
import 'place_order_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<void> requestStoragePermissions() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  Future getMobileDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      return directory?.path != null ? directory : null;
    }
    return null;
  }

  Future<void> savePdfToMobile(List<OrderModel> orders) async {
    await requestStoragePermissions();
    final ttf = await rootBundle.load('assets/fonts/unicodehelvetic.ttf');
    final helveticaUnicode = pw.Font.ttf(ttf);
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Order List',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            for (var order in orders)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Order ID: ${order.orderId ?? ''}',
                      style: pw.TextStyle(font: helveticaUnicode)),
                  pw.Text('Dish Name: ${order.dishName ?? ''}',
                      style: pw.TextStyle(font: helveticaUnicode)),
                  pw.Text('Quantity: ${order.quantity ?? ''}',
                      style: pw.TextStyle(font: helveticaUnicode)),
                  pw.Text('Status: ${order.orderStatus ?? ''}',
                      style: pw.TextStyle(font: helveticaUnicode)),
                  pw.Text(
                      'Created At: ${order.createdAt?.toDate().toString() ?? ''}',
                      style: pw.TextStyle(font: helveticaUnicode)),
                  pw.SizedBox(height: 10),
                ],
              ),
          ],
        );
      },
    ));

    final mobileDir = await getMobileDirectory();
    if (mobileDir == null) {
      return;
    }

    final file = File('${mobileDir.path}/my_pdf.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    late List<OrderModel> orders;
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(SlidePageRoute(page: ItemOrderPage()));
            },
            label: Text("mocking incoming orders"),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
              onPressed: () async {
                await savePdfToMobile(orders);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Successfully saved to your storage")));
              },
              icon: Icon(Icons.print),
              label: Text("Print Your Order List")),
          Flexible(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  orders = snapshot.data.docs
                      .map<OrderModel>((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return OrderModel.fromMap(data);
                  }).toList();

                  return orders.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            orders.sort((a, b) => b.createdAt!
                                .compareTo(a.createdAt ?? Timestamp.now()));
                            final reversedIndex = orders.length - 1 - index;
                            return Container(
                              padding: EdgeInsets.all(10),
                              color: getOrderStatusColor(orders[index]
                                  .orderStatus!
                                  .trim()
                                  .toLowerCase()),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Order Status"),
                                      kWidth(10),
                                      Text(orders[index].orderStatus ?? ""),
                                    ],
                                  ),
                                  ListTile(
                                    leading: Text(
                                      "${reversedIndex + 1}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    title: Text(orders[index].dishName ?? ""),
                                    subtitle: Text(orders[index]
                                        .createdAt!
                                        .toDate()
                                        .toString()),
                                    trailing: Column(
                                      children: [
                                        Text(
                                          "qunatity x${orders[index].quantity}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Flexible(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  tooltip:
                                                      "ASSIGN ORDER TO CHEF",
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        SlidePageRoute(
                                                            page:
                                                                ChoosechefPage(
                                                          itemName: orders[
                                                                      index]
                                                                  .dishName ??
                                                              "",
                                                          oderId: orders[index]
                                                                  .orderId ??
                                                              "",
                                                          quantity: orders[
                                                                      index]
                                                                  .quantity ??
                                                              "",
                                                        )));
                                                  },
                                                  icon: Icon(Icons.send)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : EmptyScreen(text: "Orders");
                } else {
                  return Center(child: Text("SOMETHING WENT WRONG"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
