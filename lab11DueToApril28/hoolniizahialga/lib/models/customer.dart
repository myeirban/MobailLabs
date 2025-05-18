import 'package:flutter/material.dart';
import 'item.dart';

// Customer gedeg klassiig todorhoilj bn
class Customer {
  String name;
  String email;
  ImageProvider imageProvider;
  List<Item> items = [];

  Customer({
    required this.name,
    required this.email,
    required this.imageProvider,
    List<Item>? items,
  }) {
    if (items != null) {
      this.items = items;
    }
  }

  String get formattedTotalItemPrice {
    int totalPrice = 0;
    for (var item in items) {
      totalPrice += item.price;
    }
    return '$totalPrice₮';
  }
}
