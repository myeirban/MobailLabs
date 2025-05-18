import 'package:flutter/material.dart';

class Item {
  final String name;
  final int price;
  final String uid;
  final ImageProvider imageProvider;

  Item({
    required this.name,
    required this.price,
    required this.uid,
    required this.imageProvider,
  });
}
