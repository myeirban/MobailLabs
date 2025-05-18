import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/app_drawer.dart';

//Ene screen state hadgalahgui,harin product provider oos buh dinamic dataa avch bn.UI ni consumer oor damjuuldag.
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Products'), //daraa ni baraa haij bolohoor hiij ogson.
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      drawer:
          const AppDrawer(), //ene ni tses bogood oor tsonh ruu shiljihed zoriulagdsan.
      body: Consumer<ProductsProvider>(
        //UI oorclogdohod avtomataar shineclegdene.
        builder: (ctx, productsProvider, child) {
          if (productsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } //hereglegchid loading icon haruulna

          if (productsProvider.error.isNotEmpty) {
            return Center(
              child: Text(
                'An error occurred: ${productsProvider.error}',
                textAlign: TextAlign.center,
              ),
            );
            //buteegdehuunii medeelel tatah yavtsad aldaa garval error text uusne.
          }

          final products = productsProvider.items;

          if (products.isEmpty) {
            return const Center(child: Text('No products found!'));
          } //hereb buteegdehuun baihgui bol iim txt haruuldag.

          return GridView.builder(
            //hereglegchiin dlgetsin hemjeend dinamikaar uzuuldeg.
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
