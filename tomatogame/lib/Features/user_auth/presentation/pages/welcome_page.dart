import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/home_page.dart';
import '../../google_sign_in/google_sign_in.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Tomato Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
                'https://lottie.host/b18117b4-2a8a-4d60-a627-754e5d253c3f/C6zXElsRDE.json'),
            SizedBox(height: 20),
            Text(
              "Hey Gamers !!! Let's Play",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 50,width: 250),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary:  Colors.green.withOpacity(0.5),
                    elevation: 25,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Text('Start Playing'),
              ),
            ),

            SizedBox(height: 100),

            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await _authService.signOutFromGoogle();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                width: 150,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2, 2), // Controls the position of the shadow
                      blurRadius: 5,       // Controls the spread of the shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "LogOut",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
