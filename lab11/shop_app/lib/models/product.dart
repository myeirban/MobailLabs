class Product {
  final int id; //final ni tuhain huvsagchiig neg l udaa todorhoilj baigaa
  final String title;
  final double price;
  final String description;
  final String category; //tsaashdaa buleglehed ashiglagddag
  final String image;
  final Map<String, dynamic> rating; //unelgeenii dundaj,niit unelgee
  //class product buteegdehuuuni delgerengui medeelliig hadgaldag
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
  //fromJson funkts ni json formattai ogogdliig avch tuunig product object bolgon horvuuldeg
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price:
          json['price']
              .toDouble(), //tsaashdaa price deer urjuuleh uildel hiih uchraas double torold horvuulj bn
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating,
    };
  }
}
