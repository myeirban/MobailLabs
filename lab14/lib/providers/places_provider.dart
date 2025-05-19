import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/place.dart';
//change notifier ashiglasnaar UI avtomataar shineclegddeg.
class PlacesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Place> _places = [];

//databasehelpertei shuud ajillagaa
//ene class ni gazriin medeelliig udirdaj ,sangaas achalah,nemeh,ustgah,haih zereg uildluudiig hiideg state management provider yum.
  List<Place> get places => [..._places];//_places iin jinhene jagsaaltad shuud oorclolt hiihees sergiildeg.


  //SQLite ogogdliin sangiin buh medeelliig achaalj,_places jagsaaltad horvuulj hadgaldag.
  Future<void> loadPlaces() async {
    final dataList = await _dbHelper.getPlaces();
    _places = dataList.map((item) => Place.fromMap(item)).toList();
    notifyListeners();//UI-g shinecledeg.
  }

  //shine Place obiektiig ogogdliin sand nemeed,_places jagsaaltad shine Place ID-taigaar oruulj,nemj ogdog..
  Future<void> addPlace(Place place) async {
    final id = await _dbHelper.insertPlace(place.toMap());
    _places.add(Place(
      id: id,
      title: place.title,
      image: place.image,
      location: place.location,
      description: place.description,
    ));
    notifyListeners();
  }

  //id-aar haij tuhain medeelliig ogogdliin sangaas,places jagsaaltaas ustgana.
  Future<void> deletePlace(int id) async {
    final place = _places.firstWhere((place) => place.id == id);
    
    if (!kIsWeb) {//web deer ajillaj bui esehiig shalgaj zurag ustgah uildliig hiideg.
      final imageFile = File(place.image);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }
    
    await _dbHelper.deletePlace(id);
    _places.removeWhere((place) => place.id == id);
    notifyListeners();//UI-g shinecledeg.
  }

  // place iig place jagsaaltaas olno
  Future<void> deletePlaceImage(int id) async {
    final place = _places.firstWhere((place) => place.id == id);
    
    if (!kIsWeb) {
      final imageFile = File(place.image);//image iin path aar
      if (await imageFile.exists()) {
        await imageFile.delete();//ustgah
      }
    }
    
    // null bolgoson.
    await _dbHelper.updatePlaceImage(id, '');
    

    final index = _places.indexWhere((p) => p.id == id);
    if (index != -1) {
      _places[index] = Place(
        id: place.id,
        title: place.title,
        image: '',
        location: place.location,
        description: place.description,
      );
      notifyListeners();
    }
  }

  //id aar ni jagsaaltaas haij oldog,oldohgui bol null butsaadag.
  Place? getPlaceById(int id) {
    try {
      return _places.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }
} 