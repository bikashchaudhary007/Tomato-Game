import 'package:flutter/material.dart';
import 'package:tomatogame/Features/app/splash_screen/splash_screen.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomato Game',
      home: SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}