import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/utils/mediaquery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.amberAccent,
            height: CustomeSize.customHeight(context),
            width: CustomeSize.customWidth(context)));
  }
}
