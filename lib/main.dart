import 'package:favorite_places_app/screens/places_screen.dart'; // Screen showing the list of places
import 'package:flutter_riverpod/flutter_riverpod.dart'; // State management using Riverpod
import 'package:flutter/material.dart'; // Material Design package for Flutter UI components
import 'package:google_fonts/google_fonts.dart'; // Google Fonts package for custom text themes

// Defining the application's color scheme using a dark theme as the basis.
final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark, // Setting the overall brightness to dark.
  // Primary color used throughout the app.
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  // Background color for screens and components.
  background: const Color.fromARGB(255, 56, 49, 66),
);

// Customizing the application's theme data.
final theme = ThemeData(useMaterial3: true).copyWith(
  // Sets the background color for scaffold widgets.
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme, // Applying the custom color scheme defined above.
  // Customizing text themes with Google Fonts.
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      // Setting a bold font weight for small titles.
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      // Setting a bold font weight for medium titles.
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      // Setting a bold font weight for large titles.
      fontWeight: FontWeight.bold,
    ),
  ),
);

// Entry point of the Flutter application.
void main() {
  runApp(
    // Wrapping the entire app with ProviderScope for Riverpod state management.
    const ProviderScope(
      child: MyApp(), // The root widget of the application.
    ),
  );
}

// The main application widget.
class MyApp extends StatelessWidget {
  // Constructor with optional key parameter.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title used in task manager and app switcher.
      title: 'Great Places',
      // Applying the custom theme data defined above.
      theme: theme,
      // Setting the initial route of the app to the PlacesScreen.
      home: const PlacesScreen(),
      // Removes the debug banner in the top right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}
