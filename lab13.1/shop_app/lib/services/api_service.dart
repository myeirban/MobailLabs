import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

//shared preferencees ees iluu ayulgui.
//hamgiin chuhal zuil yum,Hereglegchiin medeelliig API bolon JSON file ashiglan tataj avdag
//Mon hereglegchiig nevtruuldeg zereg uildliig hariutsdag.
class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  final _storage =
      const FlutterSecureStorage(); //ayuilgui bailgah zorilgoor ashiglasan.
  String? _token;
  static const int _timeoutSeconds = 10;
  static const int _maxRetries = 3;
  static const String _favoritesKeyPrefix = 'user_favorites_';
  List<User>? _cachedUsers;
  List<Product>? _cachedProducts;

  Future<void> _setToken(String token) async {
    //login amjilttai bolbol back aas irsen
    //kodiig ene funktseer Fluuterseucrestoga d hadgaldag.
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    await _loadToken();
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<T> _makeRequest<T>({
    required Future<T> Function() request,
    required String errorMessage,
  }) async {
    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        return await request().timeout(
          Duration(seconds: _timeoutSeconds),
          onTimeout: () {
            throw TimeoutException('Request timed out');
          },
        );
      } catch (e) {
        retryCount++;
        if (retryCount == _maxRetries) {
          throw Exception('$errorMessage: ${e.toString()}');
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: retryCount));
      }
    }
    throw Exception('Failed after $_maxRetries retries');
  }

  //buh huseltend niitleg baidlaar ashigladag
  // Hayag ruu GET huselt yavuulj, serverees buh medeelliig tataj avdag.
  Future<List<Product>> getProducts() async {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    return _makeRequest<List<Product>>(
      //rest API ashiglan ogogdol tatdag.
      request: () async {
        final response = await http.get(Uri.parse('$_baseUrl/products'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          _cachedProducts = data.map((json) => Product.fromJson(json)).toList();
          return _cachedProducts!;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to load products',
    );
  }

  // Id aar ni buteegdehuuniig haygaas tataj avdag uuregtei
  Future<Product> getProduct(int id) async {
    if (_cachedProducts != null) {
      final product = _cachedProducts!.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Product not found'),
      );
      return product;
    }

    return _makeRequest<Product>(
      request: () async {
        final response = await http.get(Uri.parse('$_baseUrl/products/$id'));
        if (response.statusCode == 200) {
          return Product.fromJson(json.decode(response.body));
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to load product',
    );
  }

  // assets/user.json file dotorh hereglegchiin medeelliig achaalj
  //JSON oos User obiektuud bolon horvuulj butsaadag
  Future<List<User>> getUsers() async {
    if (_cachedUsers != null) {
      return _cachedUsers!;
    }

    return _makeRequest<List<User>>(
      request: () async {
        final jsonString = await rootBundle.loadString('assets/users.json');
        List<dynamic> data = json.decode(jsonString);
        _cachedUsers = data.map((json) => User.fromJson(json)).toList();
        return _cachedUsers!;
      },
      errorMessage: 'Failed to load users',
    );
  }

  // Authenticates a user using the FakeStore API
  Future<User?> loginUser(String username, String password) async {
    return _makeRequest<User?>(
      request: () async {
        // First try to get token from API
        try {
          final response = await http.post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'username': username,
              'password': password,
            }),
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            await _setToken(data['token']);
            
            // Get user data from local storage
            final users = await getUsers();
            final user = users.firstWhere(
              (u) => u.username == username && u.checkPassword(password),
              orElse: () => throw Exception('User not found'),
            );
            return user;
          }
        } catch (e) {
          debugPrint('API login failed: $e');
        }

        // If API login fails, try local authentication
        final users = await getUsers();
        for (var user in users) {
          if (user.username == username && user.checkPassword(password)) {
            final token = base64Encode(utf8.encode('${user.id}:${user.username}'));
            await _setToken(token);
            return user;
          }
        }
        return null;
      },
      errorMessage: 'Login failed',
    );
  }

  // Login user
  Future<Map<String, dynamic>> login(String username, String password) async {
    return _makeRequest<Map<String, dynamic>>(
      request: () async {
        final response = await http.post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': username, //hereglegchiin ner nuuts ugiig POST huslteer
            //auth/login endpoint ruu yavuuldag.
            'password': password,
          }),
        ); //back amjilttai bol token butsaana.
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          await _setToken(data['token']);
          return data;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Login failed',
    );
  }

  // hereglegchiin sagstai holbootoi uildel hiideg.
  Future<List<CartItem>> getUserCart(int userId) async {
    return _makeRequest<List<CartItem>>(
      request: () async {
        final response = await http.get(
          Uri.parse('$_baseUrl/carts/user/$userId'),
          headers: await _getHeaders(),
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => CartItem.fromJson(json)).toList();
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to load cart',
    );
  }

  // Add item to cart
  Future<bool> addToCart(int userId, CartItem item) async {
    return _makeRequest<bool>(
      request: () async {
        final response = await http.post(
          Uri.parse('$_baseUrl/carts'),
          headers: await _getHeaders(),
          body: json.encode({
            'userId': userId,
            'date': DateTime.now().toIso8601String(),
            'products': [item.toJson()],
          }),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to add item to cart',
    );
  }

  // Update item in cart
  Future<bool> updateCartItem(CartItem item) async {
    return _makeRequest<bool>(
      request: () async {
        final response = await http.put(
          Uri.parse('$_baseUrl/carts/${item.id}'),
          headers: await _getHeaders(),
          body: json.encode(item.toJson()),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to update cart item',
    );
  }

  // Remove item from cart
  Future<bool> removeFromCart(int cartId) async {
    return _makeRequest<bool>(
      request: () async {
        final response = await http.delete(
          Uri.parse('$_baseUrl/carts/$cartId'),
          headers: await _getHeaders(),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to remove item from cart',
    );
  }

  // Clear user's cart
  Future<bool> clearCart(int userId) async {
    return _makeRequest<bool>(
      request: () async {
        final response = await http.delete(
          Uri.parse('$_baseUrl/carts/user/$userId'),
          headers: await _getHeaders(),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to clear cart',
    );
  }

  Future<User?> getUserByUsername(String username) async {
    return _makeRequest<User?>(
      request: () async {
        final response = await http.get(Uri.parse('$_baseUrl/users'));
        if (response.statusCode == 200) {
          final List users = json.decode(response.body);
          for (var user in users) {
            if (user['username'] == username) {
              return User.fromJson(user);
            }
          }
          return null;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to get user',
    );
  }

  Future<List<Product>> getUserFavorites(int userId) async {
    return _makeRequest<List<Product>>(
      request: () async {
        final response = await http.get(
          Uri.parse('$_baseUrl/favorites/user/$userId'),
          headers: await _getHeaders(),
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to load favorites',
    );
  }

  Future<bool> addToFavorites(int userId, Product product) async {
    return _makeRequest<bool>(
      request: () async {
        final response = await http.post(
          Uri.parse('$_baseUrl/favorites'),
          headers: await _getHeaders(),
          body: json.encode({
            'userId': userId,
            'productId': product.id,
          }),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to add to favorites',
    );
  }

  Future<bool> removeFromFavorites(int userId, int productId) async {
    return _makeRequest<bool>(
      request: () async {
        final response = await http.delete(
          Uri.parse('$_baseUrl/favorites/user/$userId/product/$productId'),
          headers: await _getHeaders(),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to remove from favorites',
    );
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }
}
