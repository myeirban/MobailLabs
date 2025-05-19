import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import '../models/place.dart';
//ene delgets hereglegchiin nemsen gazriin zurag ,garchig ,bairshil,tailbariig
// delgerengui haruulj,ustgah uildliig hiideg
class PlaceDetailScreen extends StatelessWidget {
  final int placeId;

  const PlaceDetailScreen({Key? key, required this.placeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Place'),
                  content: const Text('Are you sure you want to delete this place?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Provider.of<PlacesProvider>(context, listen: false)
                            .deletePlace(placeId);
                        Navigator.of(ctx).pop();//alert dialog haasan
                        Navigator.of(context).pop();//hargalzah delgetsuudiig haasan.
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      //ene ni PlacesProvider -oos gazrin medeelliig avah, oorclogdson tohioldold UI-g shinecleh.
      body: Consumer<PlacesProvider>(
        builder: (ctx, placesProvider, child) {
          final place = placesProvider.getPlaceById(placeId);
          if (place == null) {//gazriin medeelel oldohguibol place...
            return const Center(child: Text('Place not found'));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (place.image.isNotEmpty) ...[
                  Stack(
                    children: [
                      if (kIsWeb)
                        Image.network(
                          place.image,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(
                          File(place.image),
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Image'),
                                content: const Text('Are you sure you want to delete this image?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Provider.of<PlacesProvider>(context, listen: false)
                                          .deletePlace(placeId);
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(//bairshil haruulsan
                        'Location: ${place.location}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      if (place.description != null) ...[
                        Text(
                          'Description:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          place.description!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 