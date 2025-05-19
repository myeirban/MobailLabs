import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import '../providers/places_provider.dart';
//ene bol hereglegch shine gazar nemeh bolomjtoi delgets bogood zurag avah,bairlal
// oloh,garchig bolon,tailbar bicih bolomjtoi
class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();//tsenher ni formiin niit toloviig udirdaj avah,zorilgotoi
  final _titleController = TextEditingController();//text talbaruudiin utgiig udirdaj hadgalah zorilgotoi
  final _descriptionController = TextEditingController();
  dynamic _pickedImage;
  LocationData? _currentLocation;
//1.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);//utasnii cameriig neej zurah avch baiga heseg
    if (pickedImage == null) return;

    setState(() {
      if (kIsWeb) {//app web orchind ajillaj bnu gedgiig shalgaj,zurag File bish path helbereer hadgalahiig shiiddeg.
        _pickedImage = pickedImage.path;
      } else {
        _pickedImage = File(pickedImage.path);
      }
    });
  }
//2.
  Future<void> _getCurrentLocation() async {
    final location = Location();//location plugin iin obiekt uusgej bn
    try {
      final locationData = await location.getLocation();//tohooromjoos gazriin bairshliig avdag.
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {//bairshil avch chadahgui bol hereglegchid scaffold messenger ashiglan snackBar gargaj, aldaani tuhai medegdsen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not get location. Please try again.'),
        ),
      );
    }
  }

//3.formiig shalgaj,zurag bolon bairshil baigaa esehiig shalgaj ,Place obiekt uusgej
// PlacesProvider ashiglan ogodliig hadgalna.
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
//bid zovhon ogogdold uildel hiij baigaa yum
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
  void dispose() {//textEditingController uudiig tseverlej ogson,sanah oig aldagdalgui choloolohiin tuld ashigladag.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 