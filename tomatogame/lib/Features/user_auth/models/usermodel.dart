/// Represents a user in the application with essential information.
class UserModel {
  /// The unique identifier for the user.
  final String uid;

  /// The display name of the user.
  final String displayName;

  /// The email address of the user.
  final String email;

  /// The password of the user.
  final String password;

  /// The display name from Google sign-in, if applicable.
  final String? googleDisplayName;

  /// The email address from Google sign-in, if applicable.
  final String? googleEmail;

  /// Constructor for creating a new instance of the [UserModel] class.
  ///
  /// Parameters:
  /// - uid: The unique identifier for the user.
  /// - displayName: The display name of the user.
  /// - email: The email address of the user.
  /// - password: The password of the user.
  /// - googleDisplayName: The display name from Google sign-in (optional).
  /// - googleEmail: The email address from Google sign-in (optional).
  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.password,
    this.googleDisplayName,
    this.googleEmail,
  });
}
