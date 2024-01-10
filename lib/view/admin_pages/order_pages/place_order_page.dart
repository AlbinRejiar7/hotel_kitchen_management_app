import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final TextEditingController dishNameContoller = TextEditingController();
  final TextEditingController qunatityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  initInfo() {
    var andriodInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: andriodInit);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("..........onMessage.........");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('pushnotification', "pushnotification",
              importance: Importance.max,
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: false);
      NotificationDetails platformchannelspecific =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformchannelspecific,
          payload: message.data['body']);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    await sendNotificationToToken();
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

  Future<void> sendNotificationToToken() async {
    const String serverKey =
        'AAAAmMF-kSg:APA91bEsyP-zEL79p408ztUJRJDIsZ39sDh1pqzYkZQj75ey6gxzz4iSV0U6bXmNTjltE73J60sL3nuuijfm3jFrPfvmgtwoK_TY6oMO6MRE06htVI5W8U2d_FGMiSKvPXM62m7GdrD0';
    const String adminDeviceToken =
        'f8GKaQJPQtqUreSmAGWJ8M:APA91bHhrOAgjKzmLeTPvBhjEGxBn-6WOgpksGpMxp2OnWUJadLr4rXrYejbT9rfO0xoNgZbGgy3T2uyMkDOIYH_x1vEACK7J1LUVNmK_0n5_cphRAG-QQmcaOxXL1qTRUjuV-NasY3O';

    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': 'Food orderd by customer',
            'title': 'New Order',
          },
          'notification': <String, dynamic>{
            'title': 'New Order',
            'body': 'Food orderd by customer',
            'android_channel_id': 'default_channel_id',
          },
          'to': adminDeviceToken,
        }),
      );

      print('FCM Response Status Code: ${response.statusCode}');
      print('FCM Response Body: ${response.body}');
    } catch (e) {
      print('FCM Error: $e');
    }
  }
}
