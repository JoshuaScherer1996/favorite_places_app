import 'dart:convert'; // For JSON encoding and decoding.
import 'package:favorite_places_app/models/place.dart'; // Place model for holding location data.
import 'package:favorite_places_app/screens/map_screen.dart'; // Screen for displaying and picking locations on a map.
import 'package:flutter/material.dart'; // Material Design widgets for Flutter.
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps widget for Flutter.
import 'package:location/location.dart'; // Plugin for accessing the device's location.
import 'package:http/http.dart' as http; // HTTP client for making requests.

// A StatefulWidget for inputting a location, either by selecting on a map or using the current location.
class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    // Callback to pass the selected location back to the parent widget.
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation; // The currently picked location.
  // Indicates whether the app is currently fetching the location.
  var _isGettingLocation = false;

  // Generates a URL for a static map image based on the picked location.
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;
    // Uses Google Maps Static API to generate the image URL.
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:B%7C$lat,$long&key=AIzaSyDwxyjyCz-vuG0wGWyu8rkDGzkiOn65xxA';
  }

  // Saves the place with the provided latitude and longitude, and retrieves the address using the Google Geocoding API.
  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDwxyjyCz-vuG0wGWyu8rkDGzkiOn65xxA');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    // Extracts the address from the response.
    final address = responseData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false; // Resets the loading state.
    });

    // Passes the picked location back to the parent widget.
    widget.onSelectLocation(_pickedLocation!);
  }

  // Gets the current location of the device.
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Checks if location services are enabled and requests permission if necessary.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // Exits if services are not enabled after the request.
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // Exits if permission is not granted.
      }
    }

    setState(() {
      _isGettingLocation = true; // Sets the loading state.
    });

    // Fetches the current location.
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      return; // Exits if the location data is incomplete.
    }

    _savePlace(lat, long); // Saves the fetched location.
  }

  // Opens the map screen for manually selecting a location.
  void _selectOnMap() async {
    // Navigates to the MapScreen and waits for a location (LatLng) to be returned.
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    // Checks if a location was picked. If not (user navigated back without selection), the method returns early.
    if (pickedLocation == null) {
      return;
    }

    // Saves the selected location using the latitude and longitude.
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    // Defines the default content for the location preview.
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    // If a location has been picked, updates the preview content to show the location image.
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage, // The URL to the static map image.
        fit: BoxFit.cover, // Ensures the image covers the container fully.
        // Expands the image to fill the container's height.
        height: double.infinity,
        // Expands the image to fill the container's width.
        width: double.infinity,
      );
    }

    // Shows a loading indicator while the current location is being fetched.
    if (_isGettingLocation == true) {
      previewContent = const CircularProgressIndicator();
    }

    // The main widget layout.
    return Column(
      children: [
        Container(
          height: 170, // Fixed height for the location preview container.
          width: double
              .infinity, // Expands the container to fill the width of its parent.
          alignment: Alignment
              .center, // Centers the preview content within the container.
          decoration: BoxDecoration(
            border: Border.all(
              width: 1, // Border thickness.
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.2), // Border color, slightly transparent.
            ),
          ),
          child:
              previewContent, // The dynamic content based on the location selection state.
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distributes the buttons evenly in the row.
          children: [
            TextButton.icon(
              onPressed:
                  _getCurrentLocation, // Triggers fetching the current location.
              icon: const Icon(Icons
                  .location_on), // Icon for the "get current location" button.
              label:
                  const Text('Get current location'), // Label for the button.
            ),
            TextButton.icon(
              onPressed:
                  _selectOnMap, // Opens the map for manual location selection.
              icon:
                  const Icon(Icons.map), // Icon for the "select on map" button.
              label: const Text('Select on map'), // Label for the button.
            ),
          ],
        ),
      ],
    );
  }
}
