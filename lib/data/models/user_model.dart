class UserModel {
  final int id;
  final String userName;
  final String email;
  final String idNumber;
  final String firstName;
  final String lastName;
  final bool isActive;
  final List<String> roles;

  // Datos usados al preparar solicitudes.
  final String _password;
  final String _roleName;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.idNumber,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.roles,
  }) : _password = '',
       _roleName = '';

  UserModel._createRequest({
    required this.userName,
    required this.email,
    required this.idNumber,
    required this.firstName,
    required this.lastName,
    required this._password,
    required this._roleName,
  }) : id = 0,
       isActive = false,
       roles = const [];

  UserModel._updateRequest({
    required this.id,
    required this.userName,
    required this.email,
    required this.idNumber,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this._roleName,
  }) : roles = const [],
       _password = '';

  static UserModel fromCreateJson({
    required String userName,
    required String email,
    required String idNumber,
    required String firstName,
    required String lastName,
    required String password,
    required String roleName,
  }) {
    return UserModel._createRequest(
      userName: userName,
      email: email,
      idNumber: idNumber,
      firstName: firstName,
      lastName: lastName,
      password: password,
      roleName: roleName,
    );
  }

  static UserModel fromUpdateJson({
    required int id,
    required String userName,
    required String email,
    required String idNumber,
    required String firstName,
    required String lastName,
    required String roleName,
    required bool isActive,
  }) {
    return UserModel._updateRequest(
      id: id,
      userName: userName,
      email: email,
      idNumber: idNumber,
      firstName: firstName,
      lastName: lastName,
      roleName: roleName,
      isActive: isActive,
    );
  }

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

  Map<String, dynamic> toCreateJson() {
    return {
      'userName': userName,
      'email': email,
      'idNumber': idNumber,
      'firstName': firstName,
      'lastName': lastName,
      'password': _password,
      'roleName': _roleName,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'idNumber': idNumber,
      'firstName': firstName,
      'lastName': lastName,
      'roleName': _roleName,
      'isActive': isActive,
    };
  }
}
