import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/places_provider.dart';
import 'screens/place_detail_screen.dart';
import 'screens/add_place_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => PlacesProvider(),
      child: MaterialApp(
        title: 'PicLoc',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PlacesScreen(),
      ),
    );
  }
}

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<PlacesProvider>(context, listen: false).loadPlaces()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
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
              return ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(File(place.image)),
                ),
                title: Text(place.title),
                subtitle: Text(place.location),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => PlaceDetailScreen(placeId: place.id!),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
