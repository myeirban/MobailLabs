import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteItems = [];
  int? _userId;
  final ApiService _apiService = ApiService();
  static const String _favoritesKeyPrefix = 'favoriteItems_';

  FavoritesProvider() {
    _initializeFavorites();
  }

  Future<void> _initializeFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');
      if (userData != null) {
        final decodedData = json.decode(userData) as Map<String, dynamic>;
        final userId = decodedData['id'] as int;
        setUserId(userId);
        debugPrint('Initialized favorites for user $userId');
      }
    } catch (e) {
      debugPrint('Error initializing favorites: $e');
    }
  }

  List<Product> get favoriteItems => [..._favoriteItems];

  String get _userFavoritesKey => 'favoriteItems_${_userId ?? 'guest'}';

  bool isFavorite(String productId) {
    return _favoriteItems.any((product) => product.id.toString() == productId);
  }

  void setUserId(int userId) {
    if (_userId != userId) {
      _userId = userId;
      debugPrint('Setting user ID to $userId and loading favorites');
      _loadFavoritesFromPrefs();
    }
  }

  Future<void> _saveFavoritesToPrefs() async {
    if (_userId == null) {
      debugPrint('Cannot save favorites: No user ID set');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = _favoriteItems.map((item) => item.id.toString()).toList();
      await prefs.setStringList(_userFavoritesKey, favoriteIds);
      debugPrint('Successfully saved ${_favoriteItems.length} favorites for user $_userId');
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> _loadFavoritesFromPrefs() async {
    if (_userId == null) {
      debugPrint('Cannot load favorites: No user ID set');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_userFavoritesKey) ?? [];
      
      if (favoriteIds.isNotEmpty) {
        _favoriteItems.clear();
        
        // Get all products from API
        final products = await _apiService.getProducts();
        
        // Add products that are in favorites
        for (var id in favoriteIds) {
          final product = products.firstWhere(
            (p) => p.id.toString() == id,
            orElse: () => throw Exception('Product not found'),
          );
          _favoriteItems.add(product);
        }
        
        debugPrint('Successfully loaded ${_favoriteItems.length} favorites for user $_userId');
        notifyListeners();
      } else {
        debugPrint('No saved favorites found for user $_userId');
        _favoriteItems.clear();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favoriteItems.clear();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Product product) async {
    if (_userId == null) {
      debugPrint('Cannot toggle favorite: No user ID set');
      return;
    }
    
    try {
      final existingIndex = _favoriteItems.indexWhere((item) => item.id == product.id);
      if (existingIndex >= 0) {
        _favoriteItems.removeAt(existingIndex);
        debugPrint('Removed product ${product.id} from favorites');
      } else {
        _favoriteItems.add(product);
        debugPrint('Added product ${product.id} to favorites');
      }
      
      await _saveFavoritesToPrefs();
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> removeFavorite(String productId) async {
    if (_userId == null) {
      debugPrint('Cannot remove favorite: No user ID set');
      return;
    }
    
    try {
      final initialLength = _favoriteItems.length;
      _favoriteItems.removeWhere((product) => product.id.toString() == productId);
      
      if (_favoriteItems.length != initialLength) {
        debugPrint('Removed product $productId from favorites');
        await _saveFavoritesToPrefs();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  Future<void> clearFavorites() async {
    if (_userId == null) {
      debugPrint('Cannot clear favorites: No user ID set');
      return;
    }
    
    try {
      _favoriteItems.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userFavoritesKey);
      debugPrint('Successfully cleared all favorites for user $_userId');
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }
} 