import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid_item.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context
          .read<ProductsProvider>()
          .fetchProducts(), //delgets neegdeh yed buteegdehuunii medeelliig tataj eheldeg.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shop.title')
            .tr(), //garchigiig olon hel deer haruulah bolomjtoi bolgoj ogson
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite), //delgetsuuded shiljuulsen
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, productsProvider, child) {
          if (productsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productsProvider.error.isNotEmpty) {
            return Center(child: Text(productsProvider.error));
          } //aldaanii txtiig haruuldag

          return GridView.builder(
            //butegdehuun buriig suljee baidlaar haruulah zoriulalttai.
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //ene grid heden bagan baih,hoorondiin zai
              crossAxisCount: 2, //2bagantai grid
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: productsProvider.items.length,
            itemBuilder: (ctx, i) => ProductGridItem(
              //neg buteegdehuunii UI element
              product: productsProvider.items[i],
            ),
          );
        },
      ),
    );
  }
}
