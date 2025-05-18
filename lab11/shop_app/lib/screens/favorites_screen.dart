import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/favorite_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final favorites = productsProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: !authProvider.isAuth
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You need to login to see your favorites',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : favorites.isEmpty
              ? const Center(
                  child: Text(
                    'You don\'t have any favorites yet',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (ctx, i) => FavoriteItem(
                    product: favorites[i],
                  ),
                ),
    );
  }
} 