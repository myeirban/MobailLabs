import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isFavorite = favoritesProvider.isFavorite(product.id.toString());

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (!authProvider.isAuth) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('messages.login_required_favorites').tr(),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pushNamed('/login');
                      return;
                    }
                    favoritesProvider.toggleFavorite(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite ? 'favorites.removed' : 'favorites.added').tr(),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  product.category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${product.rating.rate} (${product.rating.count})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (!authProvider.isAuth) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('messages.login_required_cart').tr(),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.of(context).pushNamed('/login');
                          return;
                        }
                        cartProvider.addItem(product, 'M');
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('cart.add').tr(),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'cart.remove'.tr(),
                              onPressed: () {
                                cartProvider.removeItem(product.id, 'M');
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 