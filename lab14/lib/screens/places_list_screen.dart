  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import '../providers/places_provider.dart';
  import 'place_detail.dart';

  class PlacesListScreen extends StatelessWidget {
    const PlacesListScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Places'),
        ),
        body: Consumer<PlacesProvider>(
          builder: (ctx, placesProvider, child) {
            final places = placesProvider.places;
            if (places.isEmpty) {
              return const Center(
                child: Text('No places added yet!'),
              );
            }
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (ctx, index) {
                final place = places[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(place.image),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      place.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Location: ${place.location}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (place.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Description: ${place.description}',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    trailing: IconButton(
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
                                onPressed: () {
                                  placesProvider.deletePlace(place.id!);
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => PlaceDetailScreen(placeId: place.id!),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }