import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackGroundMessage(RemoteMessage message) async {
  print("title : ${message.notification?.title}");
  print("title : ${message.notification?.body}");
  print("title : ${message.data}");
}

class FirebaseApiService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCmToken = await _firebaseMessaging.getToken();
    print("tokennnnn:$fCmToken");
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
  }
}
