import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

///Google Authentication class
class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  /// Signs in the user with Google credentials.
  Future<User?> signInWithGoogle() async {
    try {
      // Prompt user to select a Google account
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      // Return null if the user cancels the sign-in process
      if (googleSignInAccount == null) return null;

      // Get authentication details from the selected Google account
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      

      // Sign in with Google Auth credentials
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      // Retrieve the user information
      final User? user = authResult.user;

      // Return the authenticated user
      return user;
    } catch (e) {
      // Print and return null in case of errors
      print(e.toString());
      return null;
    }
  }

  /// Signs out the user from both Google and Firebase.
  Future<void> signOutFromGoogle() async {
    // Sign out from Google
    await googleSignIn.signOut();

    // Sign out from Firebase
    await _auth.signOut();
  }
}

//
// Future<dynamic> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//     final GoogleSignInAuthentication? googleAuth =
//     await googleUser?.authentication;
//
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   } on Exception catch (e) {
//     // TODO
//     print('exception->$e');
//   }
// }

// Future<bool> signOutFromGoogle() async {
//   try {
//     await FirebaseAuth.instance.signOut();
//     return true;
//   } on Exception catch (_) {
//     return false;
//   }
// }
