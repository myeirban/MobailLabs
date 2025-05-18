import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

//hamgiin chuhal zuil yum,Hereglegchiin medeelliig API bolon JSON file ashiglan tataj avdag
//Mon hereglegchiig nevtruuldeg zereg uildliig hariutsdag.
class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  //buh huseltend niitleg baidlaar ashigladag
  // Hayag ruu GET huselt yavuulj, serverees buh medeelliig tataj avdag.
  Future<List<Product>> getProducts() async {
    try {
      //aldaag barij medee ogdog.
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Id aar ni buteegdehuuniig haygaas tataj avdag uuregtei
  Future<Product> getProduct(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  // assets/user.json file dotorh hereglegchiin medeelliig achaalj
  //JSON oos User obiektuud bolon horvuulj butsaadag
  Future<List<User>> getUsers() async {
    try {
      // pubspec.yaml file d zaasan asset failiig unshij ,JSON iig string helbereer butsaadag.
      final jsonString = await rootBundle.loadString('assets/users.json');
      List<dynamic> data = json.decode(jsonString);
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // tohiroh hereglegchiig butsaadag
  Future<User?> loginUser(String username, String password) async {
    try {
      final users = await getUsers();
      for (var user in users) {
        if (user.username == username && user.password == password) {
          return user;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
