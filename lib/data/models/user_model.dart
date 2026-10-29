class UserModel {
  final int id;
  final String userName;
  final String email;
  final String idNumber;
  final String firstName;
  final String lastName;
  final bool isActive;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.idNumber,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      userName: json['userName'] as String,
      email: json['email'] as String,
      idNumber: json['idNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      isActive: json['isActive'] as bool,
      roles: List<String>.from(json['roles'] as List),
    );
  }

  String get fullName => '$firstName $lastName'.trim();
  String get roleName => roles.isEmpty ? 'Usuario' : roles.first;
  String get initials => fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0])
      .join();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'idNumber': idNumber,
      'firstName': firstName,
      'lastName': lastName,
      'isActive': isActive,
      'roles': roles,
    };
  }
}
