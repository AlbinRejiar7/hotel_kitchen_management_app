import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifcations() async {
    await firebaseMessaging.requestPermission();

    final fcmtoken = await firebaseMessaging.getToken();
    print("token $fcmtoken");
  }
}
