class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String password;
  final String? googleDisplayName;
  final String? googleEmail;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.password,
    this.googleDisplayName,
    this.googleEmail,
  });
}
