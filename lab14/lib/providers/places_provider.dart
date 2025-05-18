import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/place.dart';

class PlacesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Place> _places = [];

  List<Place> get places => [..._places];

  Future<void> loadPlaces() async {
    final dataList = await _dbHelper.getPlaces();
    _places = dataList.map((item) => Place.fromMap(item)).toList();
    notifyListeners();
  }

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

  Future<void> deletePlace(int id) async {
    final place = _places.firstWhere((place) => place.id == id);
    
    if (!kIsWeb) {
      final imageFile = File(place.image);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }
    
    await _dbHelper.deletePlace(id);
    _places.removeWhere((place) => place.id == id);
    notifyListeners();
  }

  Place? getPlaceById(int id) {
    try {
      return _places.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }
} 