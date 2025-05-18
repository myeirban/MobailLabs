import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Cart> getCart(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/carts/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Cart.fromJson(data[0]);
      }
      throw Exception('No cart found for user');
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<Cart> addToCart(int userId, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': [
          {
            'productId': productId,
            'quantity': quantity,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  Future<void> updateCart(int cartId, List<CartItem> products) async {
    final response = await http.put(
      Uri.parse('$baseUrl/carts/$cartId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'products': products.map((item) => item.toJson()).toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart');
    }
  }
}
