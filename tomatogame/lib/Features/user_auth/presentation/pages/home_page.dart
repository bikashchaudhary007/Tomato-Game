import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatogame/Features/user_auth/game_api_integration/game_api.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';
import 'package:tomatogame/global/common/toast.dart';

import '../../../../GameLogics/random_num.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tomato Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [

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
            GameApi(),

            //Testing Random Number Generator
            // RandomNum(),

            
            SizedBox(
              height: 30,
            ),

            GestureDetector(
              // onTap: _signIn,
              onTap: (){
                // print("Logout Button Clicked");
                FirebaseAuth.instance.signOut();
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
    );
  }
}
