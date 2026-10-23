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

  static UserModel FromJson(Map<String, dynamic> json) {
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
