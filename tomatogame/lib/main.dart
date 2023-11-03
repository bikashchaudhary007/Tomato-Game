import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tomatogame/Features/app/splash_screen/splash_screen.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/login_page.dart';


/*
Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    runApp(const MyApp());

  /*
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyDUbbc0b1LnlNHFMQogc1EI5vIqe0ijK0g",
        appId: "1:975932705194:web:7b8bcda930220f541603d3",
        messagingSenderId: "975932705194",
        projectId: "tomatogame-17ae8"),
    );
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp();
   */
  // runApp(const MyApp());
}
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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



