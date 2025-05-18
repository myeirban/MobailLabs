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
  static const String _cartKeyPrefix = 'cart_';
  int? _userId;

  CartProvider(this._apiService);

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
    if (_userId == null) {
      _items.clear();
      notifyListeners();
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('${_cartKeyPrefix}${_userId}');

      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      } else {
        _items.clear();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart data: $e');
    }
  }

  /// Saves cart data to SharedPreferences
  Future<void> saveCartToPrefs() async {
    if (_userId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('${_cartKeyPrefix}${_userId}', cartData);
    } catch (e) {
      debugPrint('Error saving cart data: $e');
    }
  }

  void setUserId(int? userId) {
    if (_userId != userId) {
      _userId = userId;
      loadCartFromPrefs();
    }
  }

  Future<void> fetchCart() async {
    if (_userId == null) return;
    try {
      _items = await _apiService.getUserCart(_userId!);
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching cart: $error');
    }
  }

  Future<void> addItem(Product product, String size) async {
    if (_userId == null) return;

    final existingItemIndex = _items.indexWhere(
      (item) => item.productId == product.id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      final updatedItem = CartItem(
        id: _items[existingItemIndex].id,
        userId: _userId!,
        productId: product.id,
        quantity: _items[existingItemIndex].quantity + 1,
        date: DateTime.now().toIso8601String(),
        product: product.toJson(),
        size: size,
      );

      try {
        await _apiService.updateCartItem(updatedItem);
        _items[existingItemIndex] = updatedItem;
        notifyListeners();
      } catch (error) {
        debugPrint('Error updating cart item: $error');
      }
    } else {
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: _userId!,
        productId: product.id,
        quantity: 1,
        date: DateTime.now().toIso8601String(),
        product: product.toJson(),
        size: size,
      );

      try {
        await _apiService.addToCart(_userId!, newItem);
        _items.add(newItem);
        notifyListeners();
      } catch (error) {
        debugPrint('Error adding item to cart: $error');
      }
    }
    saveCartToPrefs();
  }

  Future<void> removeItem(int id, String size) async {
    if (_userId == null) return;

    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        final updatedItem = CartItem(
          id: _items[existingItemIndex].id,
          userId: _userId!,
          productId: _items[existingItemIndex].productId,
          quantity: _items[existingItemIndex].quantity - 1,
          date: DateTime.now().toIso8601String(),
          product: _items[existingItemIndex].product,
          size: size,
        );

        try {
          await _apiService.updateCartItem(updatedItem);
          _items[existingItemIndex] = updatedItem;
          notifyListeners();
        } catch (error) {
          debugPrint('Error updating cart item: $error');
        }
      } else {
        try {
          await _apiService.removeFromCart(_items[existingItemIndex].id);
          _items.removeAt(existingItemIndex);
          notifyListeners();
        } catch (error) {
          debugPrint('Error removing item from cart: $error');
        }
      }
    }
    saveCartToPrefs();
  }

  Future<void> decreaseQuantity(int id, String size) async {
    await removeItem(id, size);
  }

  Future<void> increaseQuantity(int id, String size) async {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      final updatedItem = CartItem(
        id: _items[existingItemIndex].id,
        userId: _userId!,
        productId: _items[existingItemIndex].productId,
        quantity: _items[existingItemIndex].quantity + 1,
        date: DateTime.now().toIso8601String(),
        product: _items[existingItemIndex].product,
        size: size,
      );

      try {
        await _apiService.updateCartItem(updatedItem);
        _items[existingItemIndex] = updatedItem;
        notifyListeners();
      } catch (error) {
        debugPrint('Error updating cart item: $error');
      }
    }
  }

  /// Clears all items from the cart
  Future<void> clear() async {
    if (_userId == null) return;
    try {
      await _apiService.clearCart(_userId!);
      _items = [];
      notifyListeners();
    } catch (error) {
      debugPrint('Error clearing cart: $error');
    }
    saveCartToPrefs();
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
}
