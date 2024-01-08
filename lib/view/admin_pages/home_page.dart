import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/inventory_pages/inventory_screen.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/menu_pages/menu_screen.dart';
import 'package:hotel_kitchen_management_app/widgets/custom_card_widget.dart';

import '../../utils/mediaquery.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var height = CustomeSize.customHeight(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
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
                  // Navigator.of(context)
                  //     .push(SlidePageRoute(page: Order()));
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
