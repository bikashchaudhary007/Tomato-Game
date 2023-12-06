import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  primary:  Colors.green.withOpacity(0.5),
                  // primary:  Color(0xFF516728).withOpacity(0.5),
                  elevation: 25,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              child: Text('Start Playing'),
            ),


          ],
        ),
      ),
    );
  }
}
