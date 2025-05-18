import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

/// Model class representing a product in the store
@JsonSerializable()
class Product {
  /// Unique identifier for the product
  final int id;
  
  /// Product title/name
  final String title;
  
  /// Product price
  final double price;
  
  /// Detailed product description
  final String description;
  
  /// Product category
  final String category;
  
  /// URL to product image
  final String image;
  
  /// Product rating information
  final Rating rating;

  /// Creates a new Product instance
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  /// Creates a Product instance from JSON data
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  /// Converts the Product instance to JSON data
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// Gets the formatted price with currency symbol
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Gets the formatted rating (e.g., "4.5/5.0")
  String get formattedRating => '${rating.rate}/5.0';

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $formattedPrice)';
  }
}

/// Model class representing a product's rating
@JsonSerializable()
class Rating {
  /// Average rating value (0.0 to 5.0)
  final double rate;
  
  /// Total number of ratings
  final int count;

  /// Creates a new Rating instance
  Rating({
    required this.rate,
    required this.count,
  });

  /// Creates a Rating instance from JSON data
  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  /// Converts the Rating instance to JSON data
  Map<String, dynamic> toJson() => _$RatingToJson(this);

  /// Gets the formatted rating count (e.g., "1,234 ratings")
  String get formattedCount => '$count ${count == 1 ? 'rating' : 'ratings'}';

  @override
  String toString() {
    return 'Rating(rate: $rate, count: $count)';
  }
}
