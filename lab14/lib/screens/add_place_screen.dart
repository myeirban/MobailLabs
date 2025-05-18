import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import '../providers/places_provider.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  dynamic _pickedImage;
  LocationData? _currentLocation;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;

    setState(() {
      if (kIsWeb) {
        _pickedImage = pickedImage.path;
      } else {
        _pickedImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();
    try {
      final locationData = await location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not get location. Please try again.'),
        ),
      );
    }
  }

  void _savePlace() {
    if (!_formKey.currentState!.validate() || _pickedImage == null || _currentLocation == null) {
      return;
    }

    final place = Place(
      title: _titleController.text,
      image: _pickedImage is File ? _pickedImage.path : _pickedImage,
      location: '${_currentLocation!.latitude}, ${_currentLocation!.longitude}',
      description: _descriptionController.text,
    );

    Provider.of<PlacesProvider>(context, listen: false).addPlace(place);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Picture'),
            ),
            if (_pickedImage != null) ...[
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: kIsWeb
                    ? Image.network(
                        _pickedImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Image.file(
                        _pickedImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            if (_currentLocation != null) ...[
              const SizedBox(height: 16),
              Text(
                'Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}',
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _savePlace,
              child: const Text('Save Place'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 