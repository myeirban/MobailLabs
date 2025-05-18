class Place {
  final int? id;
  final String title;
  final String image;
  final String location;
  final String? description;

  Place({
    this.id,
    required this.title,
    required this.image,
    required this.location,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'location': location,
      'description': description,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      location: map['location'],
      description: map['description'],
    );
  }
} 