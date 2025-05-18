import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/app_drawer.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      drawer: const AppDrawer(),
      body: Consumer<ProductsProvider>(
        builder: (ctx, productsProvider, child) {
          if (productsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productsProvider.error.isNotEmpty) {
            return Center(
              child: Text(
                'An error occurred: ${productsProvider.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final products = productsProvider.items;

          if (products.isEmpty) {
            return const Center(child: Text('No products found!'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ProductGridItem(product: products[i]),
          );
        },
      ),
    );
  }
}
