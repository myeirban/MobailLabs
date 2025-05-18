import 'package:json_annotation/json_annotation.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../services/api_service.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  //cart item class ni sagsand baigaa neg buteegdehuuniig tolooldog

  final int id; //cart item iin id

  final int userId; //hereglegchiiin id

  final int productId; //bute

  int quantity;

  final String date;

  final Map<String, dynamic>
      product; //buteegdehuuni medeelel json helbereer irdeg bolohoor fromjson hiihed tohiromjtoi

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

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  double get total => getPrice() * quantity;

  void incrementQuantity() {}

  bool decrementQuantity() {
    if (quantity > 1) {
      return false;
    }
    return true;
  }

//getter uud map<st,dyna> productdotorh medeelliig hylbar,shuud ashiglah zoriulttai
  @JsonKey(ignore: true)
  double get price => (product['price'] as num).toDouble();

  @JsonKey(ignore: true)
  String get title => product['title'] as String;

  @JsonKey(ignore: true)
  String get image => product['image'] as String;

  @JsonKey(ignore: true)
  String get category => product['category'] as String;

  double getPrice() => (product['price'] as num).toDouble();
  String getTitle() => product['title'] as String;
  String getImage() => product['image'] as String;
  String getCategory() => product['category'] as String;

  @override
  String toString() {
    return 'CartItem(id: $id, userId: $userId, productId: $productId, quantity: $quantity, date: $date, size: $size)';
  }
}
