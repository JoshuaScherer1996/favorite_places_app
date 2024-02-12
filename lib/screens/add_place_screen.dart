import 'dart:io';
import 'package:favorite_places_app/models/place.dart'; // Importing the Place model
import 'package:favorite_places_app/providers/user_places_provider.dart'; // Importing the UserPlacesProvider
import 'package:favorite_places_app/widgets/image_input.dart'; // Importing custom widget for image input
import 'package:favorite_places_app/widgets/location_input.dart'; // Importing custom widget for location input
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importing Flutter Riverpod for state management

// A StatefulWidget that allows users to add a new place
class AddPlaceScreen extends ConsumerStatefulWidget {
  // Constructor with an optional key
  const AddPlaceScreen({super.key});

  // Creating the state for this widget
  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

// The state class for AddPlaceScreen
class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  // Controller for the title input field
  final _titleController = TextEditingController();
  File? _selectedImage; // Variable to store the selected image file
  PlaceLocation? _selectedLocation; // Variable to store the selected location

  // Method to save a new place
  void _savePlace() {
    // Getting the text from the title input
    final enteredTitle = _titleController.text;

    // Validation: checking if any of the fields are empty or null
    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return; // If validation fails, exit the function without saving
    }

    // Using the userPlacesProvider to add a new place with the entered details
    ref.read(userPlacesProvider.notifier).addPlace(
          enteredTitle,
          _selectedImage!,
          _selectedLocation!,
        );

    Navigator.of(context).pop(); // Navigating back to the previous screen
  }

  // Disposing the TextEditingController when the widget is disposed
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Building the UI for the AddPlaceScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              // Assigning the controller to the TextField
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            ImageInput(
              // Callback to get the selected image
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 10),
            LocationInput(
              // Callback to get the selected location
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace, // Button to trigger the save operation
              icon: const Icon(Icons.add), // Icon for the button
              label: const Text('Add Place'), // Text for the button
            ),
          ],
        ),
      ),
    );
  }
}
