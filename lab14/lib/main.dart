import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/places_provider.dart';
import 'screens/place_detail_screen.dart';
import 'screens/add_place_screen.dart';

void main() {
  runApp(const MyApp());//anh run app ashiglan MyApp ajilluuldag
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
//initstate() ashiglan ogogdliig anh achaaldag.
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => //microtask ashiglan widget buren buteegdsenii daraa loadPlaces() funktsiig ajilluuldag.
      Provider.of<PlacesProvider>(context, listen: false).loadPlaces()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Places'),
        actions: [
          IconButton(//+ tovch darahad MaterialPageRoute oor damjuulan shiljdeg
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
          //list view builder ni item uudiig dinamikaar buteej UI achaalal bagatai bailgah uuregtei
          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (ctx, index) {
              final place = places[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(File(place.image)),//zurag ni tohooromjiin Dotood fail sistem hadgalagdsan.
                ),
                title: Text(place.title),
                subtitle: Text(place.location),
                onTap: () {//jagsaaltiin mor deer darval PlaceDetailScreen ruu tuhain gazrin id-g dmjuulan shiljine.
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
