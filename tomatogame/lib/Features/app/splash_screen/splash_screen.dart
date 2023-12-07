import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A splash screen that displays a Lottie animation before navigating to another screen.
class SplashScreen extends StatefulWidget {
  /// The child widget to navigate to after the splash screen.
  final Widget? child;

  /// Constructor for the [SplashScreen] widget.
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // For 4 second delayed
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          //Lottie animation
          child: Lottie.network(
              'https://lottie.host/a8404503-3401-41ab-a2fa-a2f4abaff61a/oAv5Rx7hFD.json'),
        ),
      ],
    ));
  }
}
