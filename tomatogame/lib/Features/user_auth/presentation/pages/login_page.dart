import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/welcome_page.dart';
import 'package:tomatogame/Features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:tomatogame/global/common/toast.dart';
import 'package:tomatogame/Features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import '../../google_sign_in/google_sign_in.dart';

/// A widget representing the login page of the Tomato Game application.
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

  /// Handles the sign-in process based on the specified sign-in method.
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

  /// Navigates to the home page after successful sign-in.+
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
        title: Text("Tomato Game"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/tomato.png',
                width: 200,
                height: 200,
              ),

              Text(
                "Login Here",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

              //Login Button
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 50, width: 250),
                child: ElevatedButton(
                  onPressed: () async {
                    await _signIn('email');
                  },
                  child: _isSigning
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.withOpacity(0.5),
                      // primary:  Color(0xFF516728).withOpacity(0.5),
                      elevation: 25,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Divider(),

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
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 50, width: 250),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _signIn('google');
                  },
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 30,
                    height: 30,
                  ),
                  label: Text("Sign In with Google"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                      elevation: 25,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
