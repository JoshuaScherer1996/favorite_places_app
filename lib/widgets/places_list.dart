import 'package:favorite_places_app/models/place.dart'; // Model class for place data
import 'package:favorite_places_app/screens/places_detail_screen.dart'; // Detail screen for a place
import 'package:flutter/material.dart'; // Flutter material design package

// Defines a stateless widget to display a list of places
class PlacesList extends StatelessWidget {
  // Constructor for initializing PlacesList with a list of places
  const PlacesList({
    super.key, // Optional key parameter for widget identification
    required this.places, // List of places to be displayed
  });

  // Declaration of the list of places
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    // Checks if the places list is empty
    if (places.isEmpty) {
      // Returns a centered message if no places are added yet
      return Center(
        child: Text(
          'No places added yet.', // Message displayed when the list is empty
          // Styling for the text
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    // Returns a ListView if there are places in the list
    return ListView.builder(
      itemCount: places.length, // Number of places in the list
      itemBuilder: (cty, index) => ListTile(
        // Leading widget with a circle avatar displaying the place's image
        leading: CircleAvatar(
          radius: 26, // Size of the circle avatar
          backgroundImage: FileImage(places[index].image), // Image of the place
        ),
        // Title of the ListTile with the place's name
        title: Text(
          places[index].name, // Name of the place
          // Styling for the title
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        // Subtitle of the ListTile with the place's address
        subtitle: Text(
          places[index].location.address, // Address of the place
          // Styling for the subtitle
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        // Navigates to the place detail screen when the ListTile is tapped
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // Navigation to detail screen
              builder: (ctx) => PlaceDetailScreen(place: places[index]),
            ),
          );
        },
      ),
    );
  }
}
