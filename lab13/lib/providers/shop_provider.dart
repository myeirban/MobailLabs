import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SharedPreferences _prefs;

  List<Product> _products = [];
  Cart? _cart;
  bool _isLoading = false;
  String? _token;
  String _language = 'en';

  ShopProvider(this._prefs) {
    _loadLanguage();
  }

  List<Product> get products => _products;
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String get language => _language;

  Future<void> _loadLanguage() async {
    _language = _prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    await _prefs.setString('language', language);
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _apiService.login(username, password);
      await _secureStorage.write(key: 'token', value: _token);
      // For testing, we'll use a hardcoded user ID since the API doesn't return it
      await loadCart(1); // Using user ID 1 for testing
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    if (_products.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cart = await _apiService.getCart(userId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product, int quantity) async {
    if (_cart == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedCart = await _apiService.addToCart(_cart!.userId, product.id, quantity);
      _cart = updatedCart;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCart(List<CartItem> products) async {
    if (_cart == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.updateCart(_cart!.id, products);
      _cart = Cart(
        id: _cart!.id,
        userId: _cart!.userId,
        date: _cart!.date,
        products: products,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 