class BusinessProfileModel {
  const BusinessProfileModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
  });

  final String name;
  final String phone;
  final String address;
  final String email;

  static BusinessProfileModel fromJson(Map<String, dynamic> json) {
    return BusinessProfileModel(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
    };
  }
}
