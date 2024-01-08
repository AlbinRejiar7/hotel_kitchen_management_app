import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String buttonName;
  final void Function() onPressed;
  const CustomButton({
    super.key,
    required this.buttonName,
    this.height,
    this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: const MaterialStatePropertyAll(
              ColorConst.customOrange,
            )),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: const TextStyle(
              color: ColorConst.customWhite, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
