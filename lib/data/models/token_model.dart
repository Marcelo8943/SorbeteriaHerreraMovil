class TokenModel {
  final String token;
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final List<String> roles;
  final DateTime expiresAt;

  TokenModel({
    required this.token,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.roles,
    required this.expiresAt,
  });

  bool get isAccessTokenExpired => DateTime.now().isAfter(expiresAt);

  static TokenModel fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['token'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'roles': roles,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
