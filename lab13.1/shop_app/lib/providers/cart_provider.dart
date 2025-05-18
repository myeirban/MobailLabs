import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';

/// Provider class that manages the shopping cart state.
/// Handles cart operations like adding, removing, and updating items,
/// as well as persisting cart data using SharedPreferences.
class CartProvider with ChangeNotifier {
  final ApiService _apiService;
  List<CartItem> _items = [];
  static const String _cartKey = 'cartItems';
  int? _userId;

  CartProvider(this._apiService) {
    loadCartFromPrefs();
  }

  /// Returns a copy of all cart items
  List<CartItem> get items => [..._items];

  /// Returns the total number of items in the cart
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calculates the total amount of all items in the cart
  double get totalAmount {
    return _items.fold(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  /// Loads cart data from SharedPreferences
  Future<void> loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);

      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart data: $e');
    }
  }

  /// Saves cart data to SharedPreferences
  Future<void> saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartData);
    } catch (e) {
      debugPrint('Error saving cart data: $e');
    }
  }

  void setUserId(int userId) {
    _userId = userId;
    loadCartFromPrefs();
    fetchCart();
  }

  Future<void> fetchCart() async {
    if (_userId != null) {
      try {
        final cartItems = await _apiService.getUserCart(_userId!);
        _items.clear();
        _items.addAll(cartItems);
        await saveCartToPrefs();
        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching cart: $e');
      }
    }
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: _userId!,
        productId: product.id,
        quantity: quantity,
        date: DateTime.now().toIso8601String(),
        product: product.toJson(),
        size: 'M',
      );
      _items.add(newItem);
      if (_userId != null) {
        await _apiService.addToCart(_userId!, newItem);
      }
    }
    
    await saveCartToPrefs();
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    final itemToRemove = _items.firstWhere((item) => item.productId == productId);
    _items.removeWhere((item) => item.productId == productId);
    await saveCartToPrefs();
    if (_userId != null) {
      await _apiService.removeFromCart(itemToRemove.id);
    }
    notifyListeners();
  }

  Future<void> decreaseQuantity(int id, String size) async {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity -= 1;
        await saveCartToPrefs();
        notifyListeners();
      } else {
        await removeItem(_items[existingItemIndex].productId);
      }
    }
  }

  Future<void> increaseQuantity(int id, String size) async {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
      await saveCartToPrefs();
      notifyListeners();
    }
  }

  Future<void> clear() async {
    _items.clear();
    await saveCartToPrefs();
    if (_userId != null) {
      await _apiService.clearCart(_userId!);
    }
    notifyListeners();
  }

  Future<void> removeItemCompletely(int id, String size) async {
    if (_userId == null) return;

    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      try {
        await _apiService.removeFromCart(_items[existingItemIndex].id);
        _items.removeAt(existingItemIndex);
        notifyListeners();
      } catch (error) {
        debugPrint('Error removing item from cart: $error');
      }
    }
  }

  Future<void> clearCartPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
      _items = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing cart prefs: $e');
    }
  }
}
