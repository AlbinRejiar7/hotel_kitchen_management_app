// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/model/menu_dish_model.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/utils/page_navigation_animation_widget.dart';
import 'package:hotel_kitchen_management_app/view/admin_pages/menu_pages/menu_addItem_screen.dart';
import 'package:hotel_kitchen_management_app/view/empty_screen.dart';

import '../../../utils/mediaquery.dart';
import 'update_menu_item_screen.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    var height = CustomeSize.customHeight(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Menu"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, SlidePageRoute(page: const MenuAddItemScreen()));
              },
              icon: const Icon(Icons.add_circle_outline_sharp))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('menu').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.active) {
              List<MenuItems> dishes =
                  snapshot.data!.docs.map<MenuItems>((doc) {
                return MenuItems.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();

              return dishes.isNotEmpty
                  ? ListView.builder(
                      itemCount: dishes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MenuWidget(
                          id: dishes[index].itemId,
                          textScale: textScale,
                          height: height,
                          dishName: dishes[index].dishName,
                          dishPrice: dishes[index].price.toString(),
                          dishImage: dishes[index].imageUrl,
                        );
                      },
                    )
                  : const EmptyScreen(
                      text: "Menu",
                    );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Text('Error: SomethingWentWrong');
            }
          }),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final String dishName;
  final String dishPrice;
  final String dishImage;
  final String id;
  const MenuWidget({
    super.key,
    required this.textScale,
    required this.height,
    required this.dishName,
    required this.dishPrice,
    required this.dishImage,
    required this.id,
  });

  final double textScale;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorConst.customWhite),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        textScaleFactor: textScale,
                        dishName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: textScale * 24,
                            fontWeight: FontWeight.bold)),
                    kHeight(10),
                    Text(
                        textScaleFactor: textScale,
                        "₹ ${dishPrice}",
                        style: TextStyle(
                            fontSize: textScale * 18,
                            color: ColorConst.customGreen))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          dishImage,
                        )),
                    borderRadius: BorderRadius.circular(20)),
                height: height * 0.2,
                width: height * 0.2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlidePageRoute(
                            page: UpdateMenuItemPage(
                                name: dishName,
                                price: dishPrice,
                                imageUrl: dishImage,
                                id: id)));
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("menu")
                          .doc(id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Successfully Deleted")));
                    } on FirebaseException catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message!)));
                    }
                  },
                  icon: const Icon(Icons.delete)),
            ],
          )
        ],
      ),
    );
  }
}
