import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../providers/auth_provider.dart';

class FavoritesProvider with ChangeNotifier {
  //class durtai baraag hadgaldag,shared pref ashiglaj hereglegch tus burt hadgalsan,
  final List<Product> _favoriteItems = [];
  static const String _favoritesKeyPrefix = 'favorites_';
  int? _userId;

  FavoritesProvider();

  List<Product> get favoriteItems => [..._favoriteItems];

  bool isFavorite(String productId) {
    return _favoriteItems.any((product) => product.id.toString() == productId);
  }

  void setUserId(int? userId) {
    //zonhon tuhain hereglegchiin durtai baraag haruulna
    if (_userId != userId) {
      _userId = userId;
      _loadFavorites();
    }
  }

  void toggleFavorite(Product product) {
    //Durtai hesegt baraag nemj,hasah uuregtei
    if (_userId == null) return;

    final existingIndex =
        _favoriteItems.indexWhere((item) => item.id == product.id);

    if (existingIndex >= 0) {
      _favoriteItems.removeAt(existingIndex);
      debugPrint('Removed product ${product.id} from favorites');
    } else {
      _favoriteItems.add(product);
      debugPrint('Added product ${product.id} to favorites');
    }
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(String productId) {
    //ene durtai jagsaaltaas buteegdehuuniig hasahad ashiglasn
    if (_userId == null) return;

    _favoriteItems.removeWhere((product) => product.id.toString() == productId);
    debugPrint('Removed product $productId from favorites');
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    if (_userId == null) {
      _favoriteItems.clear();
      notifyListeners();
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('${_favoritesKeyPrefix}${_userId}');

      if (favoritesJson != null) {
        debugPrint('Loading favorites for user $_userId');
        final List<dynamic> decodedData = json.decode(favoritesJson);
        _favoriteItems.clear();
        _favoriteItems.addAll(
          decodedData
              .map((item) {
                try {
                  return Product.fromJson(item);
                } catch (e) {
                  debugPrint(
                      'Error parsing product: $e'); //tuhain ye dyu bolj baaigaag hynahad tusalsan
                  return null;
                }
              })
              .whereType<Product>()
              .toList(),
        );
        debugPrint('Loaded ${_favoriteItems.length} favorites');
        notifyListeners();
      } else {
        debugPrint('No favorites found for user $_userId');
        _favoriteItems.clear();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favoriteItems.clear();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    if (_userId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(
        _favoriteItems
            .map((item) {
              try {
                return item.toJson();
              } catch (e) {
                debugPrint('Error serializing product: $e');
                return null;
              }
            })
            .where((item) => item != null)
            .toList(),
      );
      await prefs.setString('${_favoritesKeyPrefix}${_userId}', favoritesJson);
      debugPrint('Saved ${_favoriteItems.length} favorites for user $_userId');
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }
}
