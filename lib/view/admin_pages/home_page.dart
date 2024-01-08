import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/inventory_pages/inventory_screen.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/menu_pages/menu_screen.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/order_pages/order_screen.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_admin/sign_in_screen_admin.dart';
import 'package:hotel_kitchen_management_app/widgets/custom_card_widget.dart';

import '../../utils/mediaquery.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    Future<dynamic> _showLogoutDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    Text("DO YOU WANT TO LOGOUT?"),
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel)),
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SigninPageAdmin()));
                        authInstance.signOut();

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Logout Successfull")));
                      },
                      icon: const Icon(Icons.done))
                ],
              ));
    }

    var height = CustomeSize.customHeight(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
        title: const Text(
          "Admin Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCardWidget(
                onTap: () {
                  Navigator.of(context).push(SlidePageRoute(page: OrderPage()));
                },
                height: height * 0.8,
                textScale: textScale,
                roleName: "Order Screen",
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/512/6632/6632848.png"),
            CustomCardWidget(
                onTap: () => Navigator.of(context)
                    .push(SlidePageRoute(page: const InventoryScreen())),
                height: height * 0.8,
                textScale: textScale,
                roleName: "Inventory Screen",
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/512/5449/5449904.png"),
            CustomCardWidget(
                onTap: () => Navigator.of(context)
                    .push(SlidePageRoute(page: const MenuPage())),
                height: height * 0.8,
                textScale: textScale,
                roleName: "Menu Screen",
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/512/3059/3059065.png")
          ],
        ),
      ),
    );
  }
}
