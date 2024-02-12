import 'package:favorite_places_app/providers/user_places_provider.dart'; // Provider for user places management
import 'package:favorite_places_app/screens/add_place_screen.dart'; // Screen for adding a new place
import 'package:favorite_places_app/widgets/places_list.dart'; // Widget to display a list of places
import 'package:flutter/material.dart'; // Material Design package for Flutter UI components
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod for state management

// Defines a StatefulWidget that uses Riverpod for state management.
class PlacesScreen extends ConsumerStatefulWidget {
  // Constructor with an optional key parameter
  const PlacesScreen({super.key});

  // Creates the state for this widget
  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreen();
  }
}

class _PlacesScreen extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture; // Future to load places from the database

  @override
  void initState() {
    super.initState();
    // Initializes _placesFuture by loading places when the widget is first created
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    // Watches the userPlacesProvider for changes
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'), // AppBar title
        actions: [
          IconButton(
            onPressed: () {
              // Navigates to the AddPlaceScreen when the add icon is tapped
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add), // Add icon in the AppBar
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Padding for the body content
        child: FutureBuilder(
          future: _placesFuture, // The future that loads places
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  // Shows a loading indicator while waiting
                  ? const Center(child: CircularProgressIndicator())
                  // Passes the loaded places to the PlacesList widget
                  : PlacesList(
                      places: userPlaces,
                    ),
        ),
      ),
    );
  }
}
