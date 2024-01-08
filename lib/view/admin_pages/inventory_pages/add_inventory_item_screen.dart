import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/controller/inventory_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_text_field.dart';
import 'package:hotel_kitchen_management_app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/loading_controller.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController qunatityController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loadingStateController = Provider.of<LoadingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Inventory items"),
      ),
      body: LoadingOverlay(
        isLoading: loadingStateController.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                  hintText: "Enter Item Name",
                  labelText: "Name",
                  controller: itemNameController),
              kHeight(20),
              CustomTextField(
                  hintText: "Enter Quantity",
                  labelText: "Quantity",
                  controller: qunatityController),
              kHeight(20),
              CustomTextField(
                  hintText: "Paste Image Url Here",
                  labelText: "ImageUrl",
                  controller: imageUrlController),
              kHeight(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Select  Item's Unit",
                    style: TextStyle(fontSize: 20),
                  ),
                  Consumer<InventoryProvider>(
                      builder: (context, unitProvider, child) {
                    return DropdownButton<String>(
                      value: unitProvider.unit,
                      onChanged: (newValue) {
                        unitProvider.changeCurrentUnit(newValue);
                      },
                      items: <String>['kg', 'pieces', 'liters', 'grams']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
              Consumer<InventoryProvider>(
                  builder: (context, unitProvider, child) {
                return ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(ColorConst.customGreen)),
                  onPressed: () async {
                    {
                      loadingStateController.setLoading(true);
                      try {
                        final uuid = const Uuid().v4();

                        await FirebaseFirestore.instance
                            .collection("inventory")
                            .doc(uuid)
                            .set({
                          "itemId": uuid,
                          "itemName": itemNameController.text.toUpperCase(),
                          "quantity": qunatityController.text,
                          "unitOfMeasure": unitProvider.unit,
                          "imageUrl": imageUrlController.text,
                          "createdAt": Timestamp.now()
                        });
                        loadingStateController.setLoading(false);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Successfully added")));
                        qunatityController.clear();
                        itemNameController.clear();
                        imageUrlController.clear();
                      } on FirebaseException catch (error) {
                        loadingStateController.setLoading(false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Durations.extralong1,
                            content: Text(error.message!)));
                      } catch (error) {
                        loadingStateController.setLoading(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 500),
                                content: Text("You need to fill everything")));
                      } finally {
                        loadingStateController.setLoading(false);
                      }
                    }
                  },
                  label: const Text(
                    "Upload Item",
                    style: TextStyle(color: ColorConst.customWhite),
                  ),
                  icon: const Icon(
                    Icons.upload,
                    color: ColorConst.customWhite,
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
