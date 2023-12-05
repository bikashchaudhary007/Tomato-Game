import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/welcome_page.dart';
import 'package:tomatogame/Features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:tomatogame/global/common/toast.dart';
import 'package:tomatogame/Features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import '../../google_sign_in/google_sign_in.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final AuthenticationService _authService = AuthenticationService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(String signInMethod) async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? signInUser;

    try {
      if (signInMethod == 'email') {
        signInUser = await _auth.signInWithEmailAndPassword(email, password);
      } else if (signInMethod == 'google') {
        signInUser = await _authService.signInWithGoogle();
      }
    } catch (e) {
      print("$signInMethod Sign In failed: $e");
      showToast(message: "Sign In failed: $e");
    }

    if (signInUser != null) {
      showToast(message: "$signInMethod Sign In successfully");
      _navigateToHomePage(signInUser);
    } else {
      showToast(message: "$signInMethod Sign In failed");
    }

    setState(() {
      _isSigning = false;
    });
  }

  Future<void> _navigateToHomePage(User user) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _signIn('email');
                },
                child: _isSigning
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login"),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                            (route) => false,
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _signIn('google');
                },
                child: Text("Sign In with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
