import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

//ogogdiig shared preferences deer hadgalj dahin unshij ashigladag
class CartProvider with ChangeNotifier {
  //UI g shineclehiin tyld ovloj avsan
  List<CartItem> _items = [];

  CartProvider() {
    loadCartFromPrefs(); //ene funkts ni shared preferences ees unshij items huvsagchid onooh uuregtei
  }

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cartItems');

      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart data: $e');
    }
  }

  Future<void> saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('cartItems', cartData);
    } catch (e) {
      print('Error saving cart data: $e');
    }
  }

  //addItem ni sagsand baraa nemdeg hereglegch omno songoson bol zovhon too hemjeeg nemegduuldeg
  void addItem(Product product, String size) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == product.id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          category: product.category,
          size: size,
        ),
      );
    }

    saveCartToPrefs(); //sagsni ogogdliig JSON ruu horvuulj shared ruu hadgaldag.
    notifyListeners();
  }

  void removeItem(int id, String size) {
    _items.removeWhere((item) => item.id == id && item.size == size);
    saveCartToPrefs();
    notifyListeners();
  }

  void decreaseQuantity(int id, String size) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity -= 1;
      } else {
        _items.removeAt(existingItemIndex);
      }

      saveCartToPrefs();
      notifyListeners();
    }
  }

  void increaseQuantity(int id, String size) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.id == id && item.size == size,
    );

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
      saveCartToPrefs();
      notifyListeners();
    }
  }

  //buh baraag arilgadag
  void clear() {
    _items = [];
    saveCartToPrefs();
    notifyListeners();
  }
}
