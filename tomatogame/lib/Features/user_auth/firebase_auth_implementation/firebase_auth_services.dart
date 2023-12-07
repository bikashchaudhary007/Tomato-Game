

import 'package:firebase_auth/firebase_auth.dart';
import '../../../global/common/toast.dart';

/// Service class for Firebase Authentication operations.-
class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up a new user with the provided [email] and [password].
  ///
  /// Returns a [User] if the sign-up is successful, otherwise returns `null`.
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }

    }
    return null;
  }

  /// Sign in a user with the provided [email] and [password].
  ///
  /// Returns a [User] if the sign-in is successful, otherwise returns `null`.
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}

