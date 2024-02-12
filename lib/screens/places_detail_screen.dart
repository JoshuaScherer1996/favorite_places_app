import 'package:favorite_places_app/models/place.dart'; // Model for place details
import 'package:favorite_places_app/screens/map_screen.dart'; // Screen to display the map
import 'package:flutter/material.dart'; // Material Design package for Flutter UI components

// Defines a StatelessWidget for displaying details of a place.
class PlaceDetailScreen extends StatelessWidget {
  // Constructor requiring a Place object to display its details.
  const PlaceDetailScreen({super.key, required this.place});

  final Place place; // The place whose details will be displayed

  // Getter to generate a static map image URL using Google Maps API.
  String get locationImage {
    final lat = place.location.latitude; // Latitude of the place.
    final long = place.location.longitude; // Longitude of the place.
    // Returns a URL for a static map centered on the place's location.
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:B%7C$lat,$long&key=AIzaSyDwxyjyCz-vuG0wGWyu8rkDGzkiOn65xxA';
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the detail screen.
    return Scaffold(
      appBar: AppBar(
        // Displays the name of the place in the AppBar.
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          // Displays the image of the place covering the entire screen.
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Overlay content on the bottom of the screen.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // GestureDetector to open the MapScreen when the static map is tapped.
                GestureDetector(
                  onTap: () {
                    // Navigates to MapScreen, passing the place's location and setting isSelecting to false.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MapScreen(
                          location: place.location,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  // Displays a circle avatar with the static map as the background image.
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                // Container for displaying the address of the place.
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  // Gradient decoration for the address container.
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  // Displays the address of the place.
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
