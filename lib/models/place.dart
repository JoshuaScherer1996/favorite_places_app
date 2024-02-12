import 'package:uuid/uuid.dart'; // For generating unique identifiers
import 'dart:io'; // For File I/O operations

// Creating a constant instance of Uuid to generate unique ids
const uuid = Uuid();

// Defines a class to hold the location details of a place
class PlaceLocation {
  // Constructor for initializing PlaceLocation with latitude, longitude, and address
  const PlaceLocation({
    required this.latitude, // Latitude of the location
    required this.longitude, // Longitude of the location
    required this.address, // Address of the location
  });

  final double latitude; // Latitude of the location, cannot be changed
  final double longitude; // Longitude of the location, cannot be changed
  final String address; // Address of the location, cannot be changed
}

// Defines a class to represent a place with its details
class Place {
  // Constructor for initializing a Place object
  // If an id is not provided, a new unique id is generated using uuid
  Place({
    required this.name, // Name of the place
    required this.image, // Image file of the place
    required this.location, // Location object representing the place's location
    // Optional id for the place; if not provided, a new id is generated
    String? id,
  }) : id = id ?? uuid.v4(); // Assigning a unique id using uuid if not provided

  final String id; // Unique identifier for the place, cannot be changed
  final String name; // Name of the place, cannot be changed
  final File image; // Image of the place, cannot be changed
  // Location details of the place, cannot be changed
  final PlaceLocation location;
}
