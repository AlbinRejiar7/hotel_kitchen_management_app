import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/utils/mediaquery.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/home_page.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_admin/sign_in_screen_admin.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_chef/sign_in_screen.dart';
import 'package:hotel_kitchen_management_app/view/chefs_pages/chef_home_page.dart';

import '../widgets/custom_card_widget.dart';

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
    final currentUser = authInstance.currentUser;
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
                      onTap: () async {
                        if (currentUser == null) {
                          Navigator.of(context)
                              .push(SlidePageRoute(page: SigninPageAdmin()));
                        } else {
                          final user = authInstance.currentUser;
                          final userId = user!.uid;
                          await FirebaseFirestore.instance
                              .collection("admins")
                              .doc(userId)
                              .get()
                              .then((snapshot) {
                            if (snapshot["role"] == "admin") {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Navigator.of(context).pushReplacement(
                                  SlidePageRoute(page: AdminHomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('You are Signed in as a chef!'),
                                ),
                              );
                            }
                          });
                        }
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
                      onTap: () async {
                        if (currentUser == null) {
                          Navigator.of(context)
                              .push(SlidePageRoute(page: SingInPageChef()));
                        } else {
                          final user = authInstance.currentUser;
                          final userId = user!.uid;
                          await FirebaseFirestore.instance
                              .collection("chefs")
                              .doc(userId)
                              .get()
                              .then((snapshot) {
                            if (snapshot["role"] == "chef") {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Navigator.of(context).pushReplacement(
                                  SlidePageRoute(page: ChefHomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('You are Signed in as a admin!'),
                                ),
                              );
                            }
                          });
                        }
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
