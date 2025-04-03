// Importing necessary packages
import 'package:flutter/material.dart'; // Provides material design widgets for UI
import 'package:firebase_core/firebase_core.dart'; // Firebase core for initializing Firebase
import 'package:notes/pages/home_page.dart'; // Your custom home page
import 'firebase_options.dart'; // Firebase configuration options

// Main function which starts the app
void main() async {
  // Ensures that the Flutter engine is properly initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initializes Firebase with the configuration options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Uses Firebase options from firebase_options.dart
  );
  
  // Starts the Flutter app by running the MyApp widget
  runApp(MyApp());
}

// The MyApp widget is the root widget of your app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Returns a MaterialApp widget that is the main container for the app
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the "debug" banner during development
      home: HomePage(), // Sets the home screen of the app to HomePage widget
    );
  }
}
