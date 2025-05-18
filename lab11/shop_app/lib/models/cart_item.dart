class CartItem {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  int quantity; //end oorchlogdoj bolno
  final String size; //s,m,l

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    this.quantity = 1, //hereglegch baraagaa songohdoo neg gej garaad irdeg.
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'quantity': quantity,
      'size': size,
    };
  }

  //json ogogdloos cart item obiekt uusgehed ashiglagddag.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      category: json['category'],
      quantity: json['quantity'],
      size: json['size'],
    );
  }

  double get total => price * quantity;
}
