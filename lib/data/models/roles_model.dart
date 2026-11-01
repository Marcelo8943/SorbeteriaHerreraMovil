class RolesModel {
  final int id;
  final String roleName;
  final String? roleDescription;
  final bool? isActive;

  const RolesModel({
    required this.id,
    required this.roleName,
    this.roleDescription,
    this.isActive,
  });

  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(
      id: json['id'] as int,
      roleName: json['roleName'] as String,
      roleDescription: json['roleDescription'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }
}
