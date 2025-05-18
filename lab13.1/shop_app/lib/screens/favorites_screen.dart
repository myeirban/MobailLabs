import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; //olon helnii orcuulgii demjdeg
import '../providers/favorites_provider.dart';
import '../widgets/favorite_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: //json file dotroos favourites.title gesen utgii orchuulj haruuldag.
            Text('favorites.title').tr(), //tr ni translate gesen utgatai funkts
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favoriteItems = favoritesProvider.favoriteItems;

          if (favoriteItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'favorites.empty',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ).tr(),
                ],
              ),
            );
          }

          return ListView.builder(
            //olon elementtei jagsaltiig scroll hiihed ur ashigtai.
            padding: const EdgeInsets.all(
                16), //UI g goy haragduulahiin tuld dotor zai zai ogson
            itemCount: favoriteItems.length,
            itemBuilder: (ctx, i) => FavoriteItem(
              product: favoriteItems[
                  i], //neg buriin durtai baraag haruuldag custom widget
            ),
          );
        },
      ),
    );
  }
}
