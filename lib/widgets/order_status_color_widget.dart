import 'package:flutter/material.dart';

Color getOrderStatusColor(String orderStatus) {
  switch (orderStatus) {
    case 'pending':
      return Colors.blue;
    case 'approved':
      return Colors.orange;
    case 'inprogress':
      return Colors.yellow;
    case 'ready':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
