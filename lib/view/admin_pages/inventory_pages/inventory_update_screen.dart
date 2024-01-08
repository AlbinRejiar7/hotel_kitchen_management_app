import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/controller/inventory_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_text_field.dart';
import 'package:hotel_kitchen_management_app/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../controller/loading_controller.dart';

class ItemUpdatePage extends StatefulWidget {
  final int index;
  const ItemUpdatePage({super.key, required this.index});

  @override
  State<ItemUpdatePage> createState() => _ItemUpdatePageState();
}

class _ItemUpdatePageState extends State<ItemUpdatePage> {
  late InventoryProvider inventoryProvider;
  late TextEditingController itemNameController;
  late TextEditingController qunatityController;
  late TextEditingController imageUrlController;
  @override
  void initState() {
    super.initState();

    inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    itemNameController = TextEditingController(
        text: inventoryProvider.invItems[widget.index].itemName);

    qunatityController = TextEditingController(
        text: inventoryProvider.invItems[widget.index].quantity);

    imageUrlController = TextEditingController(
        text: inventoryProvider.invItems[widget.index].imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    var loadingStateController = Provider.of<LoadingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Your Inventory items"),
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
                        await FirebaseFirestore.instance
                            .collection("inventory")
                            .doc(
                                inventoryProvider.invItems[widget.index].itemId)
                            .update({
                          'itemName': itemNameController.text.toUpperCase(),
                          'quantity': qunatityController.text,
                          'unitOfMeasure': unitProvider.unit,
                          'imageUrl': imageUrlController.text,
                        });

                        loadingStateController.setLoading(false);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
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
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
