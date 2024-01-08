// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_kitchen_management_app/controller/auth_controller/password_contolller.dart';
import 'package:hotel_kitchen_management_app/controller/inventory_controller.dart';
import 'package:hotel_kitchen_management_app/controller/loading_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/utils/mediaquery.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_admin/sign_in_screen_admin.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_chef/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'widgets/custom_card_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PasswordProvider()),
    ChangeNotifierProvider(create: (context) => LoadingProvider()),
    ChangeNotifierProvider(create: (context) => InventoryProvider())
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = CustomeSize.customHeight(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(80),
        child: Center(
          child: Column(
            children: [
              Text(
                textScaleFactor: textScale,
                "Choose your role",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: textScale * 30),
              ),
              kHeight(20),
              CustomCardWidget(
                  onTap: () {
                    Navigator.pushReplacement(
                        context, SlidePageRoute(page: SigninPageAdmin()));
                  },
                  height: height,
                  textScale: textScale,
                  roleName: "admin",
                  imageUrl:
                      "https://www.pngmart.com/files/21/Admin-Profile-Vector-PNG-Clipart.png"),
              kHeight(10),
              CustomCardWidget(
                onTap: () {
                  Navigator.pushReplacement(
                      context, SlidePageRoute(page: SingInPageChef()));
                },
                imageSize: 0.25,
                height: height,
                textScale: textScale,
                roleName: "chef",
                imageUrl:
                    "https://www.freepnglogos.com/uploads/chef-png/png-psd-download-chef-cook-vector-illustration-14.png",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
