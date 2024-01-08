import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/controller/loading_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/color_constants.dart';
import '../../../widgets/auth_widgets/custom_text_field.dart';

class MenuAddItemScreen extends StatefulWidget {
  const MenuAddItemScreen({super.key});

  @override
  State<MenuAddItemScreen> createState() => _MenuAddItemScreenState();
}

class _MenuAddItemScreenState extends State<MenuAddItemScreen> {
  final TextEditingController dishNameContoller = TextEditingController();
  final TextEditingController priceContoller = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loadingStateController = Provider.of<LoadingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add an item",
        ),
      ),
      body: LoadingOverlay(
        isLoading: loadingStateController.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                  hintText: "Enter Dish Name",
                  labelText: "Dish Name",
                  controller: dishNameContoller),
              kHeight(20),
              CustomTextField(
                  hintText: "Enter Price",
                  labelText: "price",
                  controller: priceContoller),
              kHeight(20),
              CustomTextField(
                  hintText: "Paste the ImageUrl",
                  labelText: "ImageUrl",
                  controller: imageController),
              ElevatedButton.icon(
                label: const Text(
                  "Add Dish",
                  style: TextStyle(color: ColorConst.customWhite),
                ),
                icon: const Icon(
                  Icons.upload,
                  color: ColorConst.customWhite,
                ),
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(ColorConst.customGreen)),
                onPressed: () async {
                  {
                    loadingStateController.setLoading(true);
                    try {
                      final uuid = const Uuid().v4();

                      await FirebaseFirestore.instance
                          .collection("menu")
                          .doc(uuid)
                          .set({
                        "itemId": uuid,
                        "dishName": dishNameContoller.text.toUpperCase(),
                        "price": priceContoller.text,
                        "imageUrl": imageController.text,
                        "createdAt": Timestamp.now()
                      });
                      loadingStateController.setLoading(false);

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Successfully added")));
                      dishNameContoller.clear();
                      priceContoller.clear();
                      imageController.clear();
                    } on FirebaseException catch (error) {
                      loadingStateController.setLoading(false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Durations.extralong1,
                          content: Text(error.message!)));
                    } catch (error) {
                      loadingStateController.setLoading(false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text("You need to fill everything")));
                    } finally {
                      loadingStateController.setLoading(false);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    priceContoller.dispose();
    dishNameContoller.dispose();
    imageController.dispose();
    super.dispose();
  }
}
