import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_bus/screen/error_screen.dart';
import 'package:smart_bus/screen/home_screen.dart';
import 'package:smart_bus/screen/loading_screen.dart';
import 'package:smart_bus/screen/login_screen.dart';
import 'package:smart_bus/screen/register_screen.dart';

void main() {
  runApp(MyApp());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorScreen();
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
    );
  }
}
