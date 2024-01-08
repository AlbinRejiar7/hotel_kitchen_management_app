import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final double? height, width;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  bool obscureText;
  final void Function(String?)? onSaved;

  CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.height,
    this.width,
    this.validator,
    this.suffixIcon,
    this.obscureText = false,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(borderSide: BorderSide())),
      ),
    );
  }
}
