
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Displays a toast message using the Fluttertoast package.
///
/// Parameters:
/// - message: The text message to be displayed in the toast.
void showToast({required String message}){
  Fluttertoast.showToast(
      msg: message, // The message to be displayed
      toastLength: Toast.LENGTH_SHORT, // Duration of the toast
      gravity: ToastGravity.BOTTOM, // Toast position (e.g., BOTTOM, TOP)
      timeInSecForIosWeb: 1, // Duration of the toast on iOS and web
      backgroundColor: Colors.blue, // Background color of the toast
      textColor: Colors.white, // Text color of the toast message
      fontSize: 16.0, // Font size of the toast messagewhite,
  );
}