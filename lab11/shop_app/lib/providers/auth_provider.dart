import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

//change notifier bol UI g shinechleh bolomj ogdog.
class AuthProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _error = '';

  AuthProvider() {
    autoLogin(); //hereglegchiin medeelliig unshij hereglegchiig avtomataar nevtruuldeg
  }

  User? get user => _user;
  bool get isAuth => _user != null;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> autoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('userData');

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
        notifyListeners(); //UI g oorchlogdsniig helj ,dahin zurahad tusaldag.
      }
    } catch (e) {
      print('Auto login failed: $e');
    }
  }

  //gol uureg ni APIService eer damjuulan hereglegchiin ner, nuuts ugeer servert huselt ilgeedeg.
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final user = await _apiService.loginUser(username, password);

      if (user != null) {
        _user = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', json.encode(user.toJson()));
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error =
            'Invalid username or password'; //error huvsagchid hadgalagdaj baigaa
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //shared preferences ogogdlig tohooromj deer hadgalah bolomj olgodog.
  Future<void> logout() async {
    _user = null; //user null bolno.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData'); //shared preferences dotorh zuiliig ustgana.
    notifyListeners();
  }
}
