// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotel_kitchen_management_app/controller/auth_controller/password_contolller.dart';
import 'package:hotel_kitchen_management_app/controller/inventory_controller.dart';
import 'package:hotel_kitchen_management_app/controller/loading_controller.dart';
import 'package:hotel_kitchen_management_app/controller/order_controller.dart';
import 'package:hotel_kitchen_management_app/firebase_push_notifcation.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/utils/mediaquery.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/home_page.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_admin/sign_in_screen_admin.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_chef/sign_in_screen.dart';
import 'package:hotel_kitchen_management_app/view/chefs_pages/chef_home_page.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'widgets/custom_card_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifcations();

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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? selectedRole;
  @override
  Widget build(BuildContext context) {
    var height = CustomeSize.customHeight(context);
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    var currentUser = authInstance.currentUser;
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
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                    print(selectedRole);
                  });
                },
                items: ['admin', 'chef'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Role',
                  border: OutlineInputBorder(),
                ),
              ),
              kHeight(20),
              selectedRole == 'admin'
                  ? CustomCardWidget(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            SlidePageRoute(
                                page: currentUser != null
                                    ? AdminHomePage()
                                    : SigninPageAdmin()));
                      },
                      height: height,
                      textScale: textScale,
                      roleName: "admin",
                      imageUrl:
                          "https://www.pngmart.com/files/21/Admin-Profile-Vector-PNG-Clipart.png")
                  : SizedBox(),
              kHeight(10),
              selectedRole == 'chef'
                  ? CustomCardWidget(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            SlidePageRoute(
                                page: currentUser != null
                                    ? ChefHomePage()
                                    : SingInPageChef()));
                      },
                      imageSize: 0.25,
                      height: height,
                      textScale: textScale,
                      roleName: "chef",
                      imageUrl:
                          "https://www.freepnglogos.com/uploads/chef-png/png-psd-download-chef-cook-vector-illustration-14.png",
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
