import 'package:json_annotation/json_annotation.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../services/api_service.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final int id;
  final int userId;
  final int productId;
  int quantity;
  final String date;
  final Map<String, dynamic>
      product; //JSON ogogdliig buten hadgalah zoriulalttai
  final String size;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.date,
    required this.product,
    required this.size,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
  double get total => getPrice() * quantity;
  void incrementQuantity() {
    quantity += 1;
  }

  bool decrementQuantity() {
    if (quantity > 1) {
      quantity -= 1;
      return false;
    }
    return true;
  }

  double get price => (product['price'] as num).toDouble();

  String get title => product['title'] as String;

  String get image => product['image'] as String;

  String get category => product['category'] as String;

  double getPrice() => price;
  String getTitle() => title;
  String getImage() => image;
  String getCategory() => category;

  @override
  String toString() {
    return 'CartItem(id: $id, userId: $userId, productId: $productId, quantity: $quantity, date: $date, size: $size)';
  }
}
