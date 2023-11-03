import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';
import 'package:tomatogame/global/common/toast.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Welcome to HomePage of Tomato Game'),
          ),

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
    );
  }
}
