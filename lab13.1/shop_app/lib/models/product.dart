import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get formattedRating => '${rating.rate}/5.0';

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $formattedPrice)';
  }
}

@JsonSerializable()
class Rating {
  final double rate;
  final int count;
  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);

  String get formattedCount => '$count ${count == 1 ? 'rating' : 'ratings'}';

  @override
  String toString() {
    return 'Rating(rate: $rate, count: $count)';
  }
}
