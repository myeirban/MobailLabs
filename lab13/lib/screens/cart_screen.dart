import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../models/product.dart';
import '../models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<ShopProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.cart == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final cart = provider.cart;
          if (cart == null || cart.products.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          return ListView.builder(
            itemCount: cart.products.length,
            itemBuilder: (context, index) {
              final cartItem = cart.products[index];
              final product = provider.products.firstWhere(
                (p) => p.id == cartItem.productId,
                orElse: () => Product(
                  id: cartItem.productId,
                  title: 'Loading...',
                  price: 0,
                  description: '',
                  category: '',
                  image: '',
                  rating: Rating(rate: 0, count: 0),
                ),
              );

              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product.title),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              final updatedProducts =
                                  List<CartItem>.from(cart.products);
                              final itemIndex = updatedProducts.indexWhere(
                                  (item) => item.productId == product.id);
                              if (itemIndex != -1) {
                                if (updatedProducts[itemIndex].quantity > 1) {
                                  updatedProducts[itemIndex] = CartItem(
                                    productId: product.id,
                                    quantity:
                                        updatedProducts[itemIndex].quantity - 1,
                                  );
                                  provider.updateCart(updatedProducts);
                                } else {
                                  updatedProducts.removeAt(itemIndex);
                                  provider.updateCart(updatedProducts);
                                }
                              }
                            },
                    ),
                    Text(cartItem.quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              final updatedProducts =
                                  List<CartItem>.from(cart.products);
                              final itemIndex = updatedProducts.indexWhere(
                                  (item) => item.productId == product.id);
                              if (itemIndex != -1) {
                                updatedProducts[itemIndex] = CartItem(
                                  productId: product.id,
                                  quantity:
                                      updatedProducts[itemIndex].quantity + 1,
                                );
                                provider.updateCart(updatedProducts);
                              }
                            },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
