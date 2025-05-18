import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

/// Provider class that manages the state of products in the application.
/// Handles fetching products from the server, managing favorites, and product-related operations.
class ProductsProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Product> _items = [];
  final List<Product> _favorites = [];
  bool _isLoading = false;
  String _error = '';

  ProductsProvider(this._apiService);

  /// Returns a copy of all products
  List<Product> get items => [..._items];

  /// Returns a copy of favorite products
  List<Product> get favorites => List.unmodifiable(_favorites);

  /// Returns the current loading state
  bool get isLoading => _isLoading;

  /// Returns the current error message if any
  String get error => _error;

  /// Fetches products from the API and updates the state
  Future<void> fetchProducts() async {
    if (_items.isNotEmpty) return; // Don't fetch if we already have products

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final products = await _apiService.getProducts();
      _items = products;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Finds a product by its ID
  /// Throws [StateError] if product is not found
  Product findById(int id) {
    return _items.firstWhere((product) => product.id == id);
  }

  /// Toggles the favorite status of a product
  void toggleFavorite(Product product) {
    final isExist = _favorites.any((item) => item.id == product.id);

    if (isExist) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }

    notifyListeners();
  }

  /// Checks if a product is in favorites
  bool isFavorite(int id) {
    return _favorites.any((product) => product.id == id);
  }

  Future<void> refreshProducts() async {
    _items = []; // Clear existing products
    await fetchProducts();
  }

  List<Product> getByCategory(String category) {
    return _items.where((product) => product.category == category).toList();
  }
}
