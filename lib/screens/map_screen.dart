import 'package:favorite_places_app/models/place.dart'; // Model for place details
import 'package:flutter/material.dart'; // Material Design package for Flutter UI components
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps package for Flutter

// Defines a StatefulWidget for displaying a map screen.
class MapScreen extends StatefulWidget {
  // Constructor with optional parameters for initial location and mode of operation.
  const MapScreen({
    super.key,
    // Default location set to GooglePlex, can be overridden.
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    // Determines whether the user is selecting a location or viewing an existing one.
    this.isSelecting = true,
  });

  final PlaceLocation location; // The initial location to display on the map.
  final bool isSelecting; // Flag to enable or disable location selection.

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

// The state class for MapScreen to manage the map's state.
class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation; // Stores the user-selected location.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Changes the title based on whether the user is picking a location or not.
        title:
            Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        // If in selecting mode, show a save button to confirm the picked location.
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Return the picked location to the previous screen when saved.
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      // GoogleMap widget to display the map.
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null // Disable tap if not in selecting mode.
            : (position) {
                setState(() {
                  // Update state with new location on tap.
                  _pickedLocation = position;
                });
              },
        // Sets the initial camera position to the provided or default location.
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16, // Initial zoom level.
        ),
        // Configures markers based on the picked location or the initial location.
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'), // Unique ID for the marker.
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ), // Uses the picked location or falls back to the initial location.
                ),
              },
      ),
    );
  }
}
