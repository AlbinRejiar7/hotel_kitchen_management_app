import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApiService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCmToken = await _firebaseMessaging.getToken();
    print("tokennnnn:$fCmToken");
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional');
    } else {
      print('user Declined oru not accepted');
    }
  }
}
