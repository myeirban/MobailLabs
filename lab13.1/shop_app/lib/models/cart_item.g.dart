part of 'cart_item.dart';

/// JSON ogogdloos CartItem obiekt uusgeh funkts
CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
    id: (json['id'] as num).toInt(),
    userId: (json['userId'] as num).toInt(),
    productId: (json['productId'] as num).toInt(),
    quantity: (json['quantity'] as num).toInt(),
    date: json['date'] as String,
    product: json['product'] as Map<String, dynamic>,
    size: json['size'] as String,
  );
}

/// CartItem obiektiig JSON ruu horvuuldeg
Map<String, dynamic> _$CartItemToJson(CartItem instance) {
  return {
    'id': instance.id,
    'userId': instance.userId,
    'productId': instance.productId,
    'quantity': instance.quantity,
    'date': instance.date,
    'product': instance.product,
    'size': instance.size,
  };
}
