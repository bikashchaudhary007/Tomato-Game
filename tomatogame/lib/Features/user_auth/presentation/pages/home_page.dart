import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatogame/GameLogics/game.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';
import 'package:tomatogame/global/common/toast.dart';


import '../../../../GameLogics/random_num.dart';
import '../../google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  final String userName;
  late  AuthenticationService _authService = AuthenticationService(); // Create an instance of AuthenticationService

  HomePage({Key? key, required this.userName}) : super(key: key) {
    _authService = AuthenticationService(); // Initialize in the constructor
  }

  // const HomePage({super.key, required this.userName});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tomato Game"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$userName", style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24
              ),),

              /*
              //Level and Scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //Level
                  Container(
                    width: 120,
                    height: 35,
                    // color: Colors.redAccent,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(18)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Level", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                        ),),

                        Text("07", style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        ),),
                      ],
                    ),
                  ),

                  //Score
                  Container(
                    width: 120,
                    height: 35,
                    // color: Colors.redAccent,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(18)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Text("Level", style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 24
                        // ),),

                        Text("250", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
               */

              SizedBox(
                height: 30,
              ),

              //Calling Game API
              Game(),

              //Testing Random Number Generator
              // RandomNum(),

              
              SizedBox(
                height: 30,
              ),

              GestureDetector(
                // onTap: _signIn,
                onTap: () async {
                  // print("Logout Button Clicked");
                  // Sign out from Firebase
                  FirebaseAuth.instance.signOut();

                  // Sign out from Google
                  await _authService.signOutFromGoogle();

                  Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
                  showToast(message: "Successfully sign out");

                },
                child: Container(
                  width: 100, //double.infinity
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Center(child: Text("LogOut", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
