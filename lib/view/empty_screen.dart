// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../utils/mediaquery.dart';

class EmptyScreen extends StatelessWidget {
  final String text;
  const EmptyScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var height = CustomeSize.customHeight(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
                height: height * 0.3,
                "https://cdn-icons-png.flaticon.com/512/7380/7380036.png"),
          ),
          Text(
            textScaleFactor: textScale,
            "Oops Your $text is Empty",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: textScale * 20),
          ),
        ],
      ),
    );
  }
}
