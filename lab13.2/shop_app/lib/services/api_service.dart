import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cart_item.dart';

//hamgiin chuhal zuil yum,Hereglegchiin medeelliig API bolon JSON file ashiglan tataj avdag
//Mon hereglegchiig nevtruuldeg zereg uildliig hariutsdag.
//class ni json fail ashiglan medeelel tatah ,nevtreh,token hadgalah zereg uurgiig hariutsdag.
class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  final _storage =
      const FlutterSecureStorage(); //hereglegchiin token ayulgui hadgalahad ashiglasan
  String? _token;
  static const int _timeoutSeconds = 10;
  static const int _maxRetries = 3;

  Future<void> _setToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'auth_token');
  } //api d auth header damjuulahad ashiglasan

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

        await Future.delayed(Duration(seconds: retryCount));
      }
    }
    throw Exception('Failed after $_maxRetries retries');
  }

  //buh huseltend niitleg baidlaar ashigladag
  // Hayag ruu GET huselt yavuulj, serverees buh medeelliig tataj avdag.
  Future<List<Product>> getProducts() async {
    return _makeRequest<List<Product>>(
      request: () async {
        final response = await http.get(Uri.parse('$_baseUrl/products'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Failed to load products',
    );
  }

  // Id aar ni buteegdehuuniig haygaas tataj avdag uuregtei
  Future<Product> getProduct(int id) async {
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
    return _makeRequest<List<User>>(
      request: () async {
        final jsonString = await rootBundle.loadString('assets/users.json');
        List<dynamic> data = json.decode(jsonString);
        return data.map((json) => User.fromJson(json)).toList();
      },
      errorMessage: 'Failed to load users',
    );
  }

  // Hereglegchdiin jagsaaltaas user/pass taarch buig
  Future<User?> loginUser(String username, String password) async {
    return _makeRequest<User?>(
      request: () async {
        final response = await http.get(Uri.parse('$_baseUrl/users'));
        if (response.statusCode == 200) {
          final List<dynamic> users = json.decode(response.body);
          for (var userData in users) {
            if (userData['username'] == username &&
                userData['password'] == password) {
              return User.fromJson(userData);
            }
          }
          return null;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Login failed',
    );
  }

  // api d /auth/login-d post ilgeej token avch hadgaldag
  Future<Map<String, dynamic>> login(String username, String password) async {
    return _makeRequest<Map<String, dynamic>>(
      request: () async {
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
          return data;
        } else {
          throw Exception('Server returned status code ${response.statusCode}');
        }
      },
      errorMessage: 'Login failed',
    );
  }

  // hereglegchiin sagsiig tatdag
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
          body: json.encode(item.toJson()),
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
}
