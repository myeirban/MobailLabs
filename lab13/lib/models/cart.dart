import 'package:json_annotation/json_annotation.dart';
part 'cart.g.dart'; //_$CartFormJson() bolon _$CartJson() zereg funktsuud ene filed bii boldog

//paketiin annotation bogood tuhain klassiig JSON ruu horvuuleh bolon
//json oos unshih funktsuudiig avtomataar uusgehed ashigladag.
//garaar bicihgui uchraas aldaa bagatai
@JsonSerializable()
class Cart {
  final int id;
  final int userId;
  final String date;
  final List<CartItem> products;

  Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}

@JsonSerializable()
class CartItem {
  final int productId;
  final int quantity;

  CartItem({
    required this.productId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
