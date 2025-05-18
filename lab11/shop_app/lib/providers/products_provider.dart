import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

//ene ni buteegdehuunii jagsaaltiig serverees tataj avah, hadgalah, durtai baraag nemeh hasah
//state managementiin neg heseg yum.
//change notifier ashiglasan shaltgaan ni state oorchlogdoh burt UI g dahin zurahiin tuld
class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final List<Product> _favorites = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _error = '';

  ProductsProvider() {
    fetchProducts();
  }

  List<Product> get items => [..._items];
  List<Product> get favorites => [..._favorites];
  bool get isLoading => _isLoading;
  String get error => _error;
  //fetch products ni APIService ashiglan buh buteegdehuunii medeellig tataj _items huvsagchid hadgaldag.

  Future<void> fetchProducts() async {
    _isLoading = true; //achaalj ehleh
    _error = ''; //UI d aldaa gej haruulahad ashiglaj baigaa
    notifyListeners();

    try {
      final products = await _apiService.getProducts();
      _items = products;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Product findById(int id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //herev baraa favourites jagsaaltand baival ustgaj, ugui bol nemdeg.
  void toggleFavorite(Product product) {
    final isExist = _favorites.any((item) => item.id == product.id);

    if (isExist) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }

    notifyListeners();
  }

  //ogogdson id tai buteegdehuun favourites jagsaaltand baigaa esehiig shalgadag
  bool isFavorite(int id) {
    return _favorites.any((product) => product.id == id);
  }
}
