import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/profile_screen.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';
import 'package:tomatogame/global/common/toast.dart';


import '../../../../GameLogics/game2.dart';
import '../../../../GameLogics/random_num.dart';
import '../../google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  late  AuthenticationService _authService = AuthenticationService(); // Create an instance of AuthenticationService

  HomePage({Key? key}) : super(key: key) {
    _authService = AuthenticationService(); // Initialize in the constructor
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tomato Game"),
        automaticallyImplyLeading: false, // Set this to false to hide the back arrow
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                height: 30,
              ),

              //Calling Game API
              // Game(),
              SizedBox(
                height: 600, // Provide a fixed height as an example
                child: Game2(),
              ),


              //Testing Random Number Generator
              // RandomNum(),


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
