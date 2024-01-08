import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../controller/loading_controller.dart';
import '../../../utils/custom_sizedbox.dart';
import '../../../widgets/loading_widget.dart';

class UpdateMenuItemPage extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  const UpdateMenuItemPage(
      {super.key,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.id});

  @override
  State<UpdateMenuItemPage> createState() => _UpdateMenuItemPageState();
}

class _UpdateMenuItemPageState extends State<UpdateMenuItemPage> {
  late TextEditingController dishNameController;
  late TextEditingController priceController;
  late TextEditingController imageUrlController;
  @override
  void initState() {
    super.initState();
    dishNameController = TextEditingController(text: widget.name);

    priceController = TextEditingController(text: widget.price);

    imageUrlController = TextEditingController(text: widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    var loadingStateController = Provider.of<LoadingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Editing Screen"),
      ),
      body: LoadingOverlay(
        isLoading: loadingStateController.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CustomTextField(
                  hintText: "Enter Dish Name",
                  labelText: "Dish Name",
                  controller: dishNameController),
              kHeight(20),
              CustomTextField(
                  hintText: "Enter Price",
                  labelText: "price",
                  controller: priceController),
              kHeight(20),
              CustomTextField(
                  hintText: "Paste the ImageUrl",
                  labelText: "ImageUrl",
                  controller: imageUrlController),
              ElevatedButton.icon(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(ColorConst.customGreen)),
                onPressed: () async {
                  {
                    loadingStateController.setLoading(true);
                    try {
                      await FirebaseFirestore.instance
                          .collection("menu")
                          .doc(widget.id)
                          .update({
                        'dishName': dishNameController.text.toUpperCase(),
                        'imageUrl': imageUrlController.text,
                        'price': priceController.text,
                      });

                      loadingStateController.setLoading(false);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Successfully Updated")));
                    } on FirebaseException catch (error) {
                      loadingStateController.setLoading(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.message!)));
                    } catch (error) {
                      loadingStateController.setLoading(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    } finally {
                      loadingStateController.setLoading(false);
                    }
                  }
                },
                label: const Text(
                  "Update Item",
                  style: TextStyle(color: ColorConst.customWhite),
                ),
                icon: const Icon(
                  Icons.upload,
                  color: ColorConst.customWhite,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
