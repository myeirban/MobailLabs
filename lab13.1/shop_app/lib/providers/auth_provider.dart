import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'favorites_provider.dart';
import 'package:flutter/material.dart';

/// Provider class that manages authentication state and user data.
/// Handles user login, logout, and auto-login functionality using SharedPreferences.
class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  static const String _userDataKey = 'userData';
  bool _isAuth = false;
  FavoritesProvider? _favoritesProvider;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  /// Returns the current user if logged in
  User? get user => _user;

  /// Returns whether a user is currently authenticated
  bool get isAuthenticated => _user != null;

  /// Returns the current loading state
  bool get isLoading => _isLoading;

  /// Returns the current error message if any
  String? get error => _error;

  /// Returns whether a user is currently authenticated
  bool get isAuth => _isAuth;

  void setFavoritesProvider(FavoritesProvider provider) {
    _favoritesProvider = provider;
    debugPrint('FavoritesProvider set in AuthProvider');
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');
      if (userData != null) {
        final decodedData = json.decode(userData) as Map<String, dynamic>;
        _user = User.fromJson(decodedData);
        _isAuth = true;
        debugPrint('Loaded user from prefs: ${_user?.username}');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from prefs: $e');
    }
  }

  Future<void> _saveUserToPrefs(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(user.toJson());
      await prefs.setString('userData', userData);
      debugPrint('Saved user to prefs: ${user.username}');
    } catch (e) {
      debugPrint('Error saving user to prefs: $e');
    }
  }

  /// Attempts to automatically log in the user using stored credentials
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
        _isAuth = true;
        _favoritesProvider?.setUserId(_user!.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
    }
  }

  /// Attempts to log in a user with the provided credentials
  /// Returns true if login is successful, false otherwise
  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.loginUser(username, password);
      if (user != null) {
        _user = user;
        _isAuth = true;
        await _saveUserToPrefs(user);
        debugPrint('User logged in successfully: ${user.username}');
        
        // Initialize favorites after successful login
        if (_favoritesProvider != null) {
          _favoritesProvider!.setUserId(user.id);
          debugPrint('Initialized favorites for user ${user.id}');
        } else {
          debugPrint('Warning: FavoritesProvider not set');
        }
      } else {
        _error = 'Invalid username or password';
        debugPrint('Login failed: Invalid credentials');
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Login error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logs out the current user and clears stored credentials
  Future<void> logout() async {
    try {
      await _apiService.logout();
      _user = null;
      _isAuth = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userData');
      debugPrint('User logged out successfully');
      
      // Clear favorites when logging out
      if (_favoritesProvider != null) {
        await _favoritesProvider!.clearFavorites();
        debugPrint('Cleared favorites on logout');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
        username: username,
        email: email,
        password: password, // In real app, this should be hashed
        name: username,
        phone: '',
        avatar: '',
      );

      // Save user to local storage
      await _saveUserToPrefs(newUser);
      _user = newUser;
      _isAuth = true;
      debugPrint('User registered successfully: ${newUser.username}');
      
      // Initialize favorites for new user
      if (_favoritesProvider != null) {
        _favoritesProvider!.setUserId(newUser.id);
        debugPrint('Initialized favorites for new user ${newUser.id}');
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Registration error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
