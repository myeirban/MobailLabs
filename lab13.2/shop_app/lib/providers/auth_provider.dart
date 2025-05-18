import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

/// Provider class that manages authentication state and user data.
/// Handles user login, logout, and auto-login functionality using SharedPreferences.
class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _error = '';
  static const String _userDataKey = 'userData';
  FavoritesProvider? _favoritesProvider;
  CartProvider? _cartProvider;

  AuthProvider() {
    autoLogin(); //hereglegchiin medeelliig unshij hereglegchiig avtomataar nevtruuldeg
  }

  void setProviders(
      FavoritesProvider favoritesProvider, CartProvider cartProvider) {
    _favoritesProvider = favoritesProvider;
    _cartProvider = cartProvider;
  }

  User? get user => _user;

  bool get isAuth =>
      _user != null; //isauth deeree hereglegch nevtersen esehiig shalgana

  bool get isLoading => _isLoading;

  String get error => _error;
//app ehlehed hereglegchiin medeelel shar/pr d hadgalagdaj baigaag shalgaad ter hereglegchiig avtomataar nevtruuldeg.
  Future<void> autoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);

      if (userData != null) {
        final decodedData = json.decode(userData) as Map<String, dynamic>;
        _user = User(
          id: decodedData['id'],
          username: decodedData['username'],
          email: decodedData['email'],
          password: decodedData['password'],
          name: decodedData['name'],
          phone: decodedData['phone'],
          avatar: decodedData['avatar'] ?? '',
        );
        _favoritesProvider?.setUserId(_user?.id);
        _cartProvider?.setUserId(_user?.id);
        notifyListeners(); //UI g oorchlogdsniig helj ,dahin zurahad tusaldag.
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true; //api duudalt bolj baigaa esehiig shalgasan
    _error = '';
    notifyListeners();

    try {
      final user = await _apiService.loginUser(username, password);

      if (user != null) {
        _user = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userDataKey, json.encode(user.toJson()));
        _favoritesProvider?.setUserId(user.id);
        _cartProvider?.setUserId(user.id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error =
            'Invalid username or password'; //error huvsagchid hadgalagdaj baigaa
        _isLoading = false;
        notifyListeners();
        return false; //herev nuuts ug buruu bol false butsaana.API servertei holbogdoh yed aldaa garval
      }
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// nevtersen hereglegchiin user obiektiig ustgadag.
  Future<void> logout() async {
    _user = null; //user null bolno.
    _favoritesProvider?.setUserId(null);
    _cartProvider?.setUserId(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove(_userDataKey); //shared preferences dotorh zuiliig ustgana.
    notifyListeners();
  }
}
