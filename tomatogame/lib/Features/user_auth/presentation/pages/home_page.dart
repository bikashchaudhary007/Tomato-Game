import 'package:flutter/material.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/profile_screen.dart';
import '../../../../GameLogics/game.dart';
import '../../google_sign_in/google_sign_in.dart';

/// A widget representing the home page of the Tomato Game application.
class HomePage extends StatelessWidget {
  late AuthenticationService _authService =
      AuthenticationService(); // Create an instance of AuthenticationService

  /// Constructor for the [HomePage] widget.
  HomePage({Key? key}) : super(key: key) {
    _authService = AuthenticationService(); // Initialize in the constructor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tomato Game"),
        automaticallyImplyLeading:
            false, // Set this to false to hide the back arrow
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to the ProfileScreen when the profile icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),

              //The Game widget
              SizedBox(
                height: 600, // Provide a fixed height as an example
                child: Game(),
              ),

              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
