// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomeSize {
  static double customHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double customWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }
}
