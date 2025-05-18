// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      date: json['date'] as String,
      product: json['product'] as Map<String, dynamic>,
      size: json['size'] as String,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'date': instance.date,
      'product': instance.product,
      'size': instance.size,
    };
