import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tomatogame/Features/app/splash_screen/splash_screen.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';

/// The main function to start the Flutter application.
Future<void> main() async {
  // Ensure that Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp();

  // Run the application.
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Constructor for the [MyApp] widget.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Disable the debug banner.
      debugShowCheckedModeBanner: false,
      // Set the application title.
      title: 'Tomato Game',

      // Define the theme.
      theme: ThemeData(
        // Customize the color scheme with a seed color.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),

      // Set the initial screen to the splash screen containing the login page.
      home: SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}
