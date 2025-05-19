class Place {//place class ni gazrin obiektiin ogogdliig hadgalah zagvar yum.
  final int? id;//id ni ogogdlin san avtomataar uusgedeg tul anh nemeh yed null baij bolno.
  final String title;
  final String image;
  final String location;
  final String? description;//zaaval tailbar ogoh shaardlagagui.

  Place({
    this.id,
    required this.title,//required ni tuhain tailbaruudiig zaaval baiguulagchid damjuulahiig shaarddag.
    required this.image,
    required this.location,
    this.description,
  });

  //place obiektiig Map<String, dynamic> helbert huvirgaj ogogdliig Place obiekt horvuuldeg.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'location': location,
      'description': description,
    };
  }

  //Ogogdliin san esvel JSON-oos irsen Map<String,dynamic> ogogdliig Place obiekt bolgon horvuuldeg.
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