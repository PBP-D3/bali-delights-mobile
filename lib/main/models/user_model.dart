// If not used anymore, you can delete this file.
// Otherwise, keep it only if other parts of your app utilize the User model.

class User {
  final String username;
  final int id;

  User({
    required this.username,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      id: json['id'],
    );
  }
}

bool isAdmin() => false; // Update based on your role logic}