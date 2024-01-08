import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/widgets/loading_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/loading_controller.dart';
import '../../../widgets/auth_widgets/custom_text_field.dart';

class ItemOrderPage extends StatefulWidget {
  const ItemOrderPage({super.key});

  @override
  State<ItemOrderPage> createState() => _ItemOrderPageState();
}

class _ItemOrderPageState extends State<ItemOrderPage> {
  final TextEditingController dishNameContoller = TextEditingController();
  final TextEditingController qunatityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var adminDeviceToken =
        'dZv2ug14R6iEY0nDkED3Iv:APA91bHsRJJpAQhGarOwGgvOi5CH2X958Ugk8t-SmPC-dDHddbdOkhwWFx7hsTQ_Hrt-r3OyTx27G78yfeoZ8DAso2a3osTLG1_vFkN0Y3ftexqQ8nRhrN9YjSCZg6Ep3RZXHmzB-NMC';
    var loadingStateController = Provider.of<LoadingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ordering item",
        ),
      ),
      body: LoadingOverlay(
        isLoading: loadingStateController.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                  hintText: "Enter Dish Name",
                  labelText: "Dish Name",
                  controller: dishNameContoller),
              kHeight(20),
              CustomTextField(
                  hintText: "Enter quantity",
                  labelText: "quantity",
                  controller: qunatityController),
              ElevatedButton.icon(
                label: const Text(
                  "Order",
                  style: TextStyle(color: ColorConst.customWhite),
                ),
                icon: const Icon(
                  Icons.upload,
                  color: ColorConst.customWhite,
                ),
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(ColorConst.customGreen)),
                onPressed: () async {
                  loadingStateController.setLoading(true);
                  try {
                    final uuid = const Uuid().v4();

                    await FirebaseFirestore.instance
                        .collection("orders")
                        .doc(uuid)
                        .set({
                      "orderId": uuid,
                      "orderStatus": "pending",
                      "dishName": dishNameContoller.text.toUpperCase(),
                      "quantity": qunatityController.text,
                      "createdAt": Timestamp.now()
                    });
                    loadingStateController.setLoading(false);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Order has been placed")));
                    sendOrderNotificationToAdmin(adminDeviceToken);
                    dishNameContoller.clear();
                    qunatityController.clear();
                  } on FirebaseException catch (error) {
                    loadingStateController.setLoading(false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Durations.extralong1,
                        content: Text(error.message!)));
                  } catch (error) {
                    loadingStateController.setLoading(false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text("You need to fill everything")));
                  } finally {
                    loadingStateController.setLoading(false);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    qunatityController.dispose();
    dishNameContoller.dispose();

    super.dispose();
  }

  void sendOrderNotificationToAdmin(String adminDeviceToken) async {
    final String serverKey = '656081326376';
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final Map<String, dynamic> data = {
      'notification': {
        'title': 'New Order Received',
        'body': 'Check your admin panel for details.',
      },
      'to': adminDeviceToken,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: json.encode(data),
    );

    print('FCM Response: ${response.body}');
  }
}
