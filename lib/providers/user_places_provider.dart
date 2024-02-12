import 'package:favorite_places_app/models/place.dart'; // Place model
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For state management
import 'dart:io'; // For file operations
// For getting the system path
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path; // For path operations
import 'package:sqflite/sqflite.dart' as sql; // For SQLite database operations
import 'package:sqflite/sqlite_api.dart'; // SQLite API for database interaction

// Asynchronous function to initialize or get the database
Future<Database> _getDatabase() async {
  // Getting the path to the database
  final dbPath = await sql.getDatabasesPath();
  // Opening the database, creating it if it doesn't exist
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'), // Database file path
    // Creating the table if the database is created for the first time
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1, // Database version
  );
  return db; // Returning the database instance
}

// Notifier class for managing user places
class UserPlacesNotifier extends StateNotifier<List<Place>> {
  // Initializing with an empty list of places
  UserPlacesNotifier() : super(const []);

  // Method to load places from the database
  Future<void> loadPlaces() async {
    final db = await _getDatabase(); // Getting the database
    // Querying the user_places table
    final data = await db.query('user_places');
    // Mapping the query result to a list of Place objects
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['title'] as String,
            // Creating a File object for the image
            image: File(row['image'] as String),
            // Creating a PlaceLocation object
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();

    state = places; // Updating the state with the loaded places
  }

  // Method to add a new place to the database and update the state
  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    // Getting the application directory
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path); // Extracting the filename
    // Copying the image to the app directory
    final copiedImage = await image.copy('${appDirectory.path}/$filename');

    // Creating a new Place object
    final newPlace = Place(name: title, image: copiedImage, location: location);

    // Getting the database
    final db = await _getDatabase();

    // Inserting the new place into the database
    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    // Updating the state with the new place
    state = [newPlace, ...state];
  }
}

// Provider for the UserPlacesNotifier, using StateNotifierProvider for state management
final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
