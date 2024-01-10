// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_kitchen_management_app/controller/auth_controller/password_contoller.dart';
import 'package:hotel_kitchen_management_app/controller/inventory_controller.dart';
import 'package:hotel_kitchen_management_app/controller/loading_controller.dart';
import 'package:hotel_kitchen_management_app/controller/order_controller.dart';
import 'package:hotel_kitchen_management_app/firebase_api.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  await FirebaseApiService().initNotifications();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PasswordProvider()),
    ChangeNotifierProvider(create: (context) => LoadingProvider()),
    ChangeNotifierProvider(create: (context) => InventoryProvider()),
    ChangeNotifierProvider(create: (context) => OrderProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.metrophobicTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey[300]),
            scaffoldBackgroundColor: Colors.grey[300]),
        home: SplashScreen());
  }
}
