import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Product> _items = [];
  final List<Product> _favorites = [];
  bool _isLoading = false;
  String _error = '';

  ProductsProvider(this._apiService);

  List<Product> get items => [..._items];

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> fetchProducts() async {
    if (_items.isNotEmpty) return; //dahin tatahgui baih hamgaalalt hiisen

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final products = await _apiService.getProducts();
      _items = products;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Product findById(int id) {
    return _items.firstWhere((product) => product.id == id);
  } //Tuhain id tai baraag first where ashiglaj butsaana.

  void toggleFavorite(Product product) {
    final isExist = _favorites.any((item) => item.id == product.id);

    if (isExist) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }

    notifyListeners(); //UI g avtomataar shinechlegdehed ashigladag.
  }

  bool isFavorite(int id) {
    return _favorites.any((product) => product.id == id);
  }

  Future<void> refreshProducts() async {
    _items = [];
    await fetchProducts();
  }

  List<Product> getByCategory(String category) {
    //category g songovol te angilliin baraag haruulna.
    return _items.where((product) => product.category == category).toList();
  }
}
