class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? shippingAddress;
  final String? profileImageUrl;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.shippingAddress,
    this.profileImageUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      shippingAddress: json['shipping_address'],
      profileImageUrl: json['profile_image_url'],
      role: json['role'] ?? 'Buyer',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'shipping_address': shippingAddress,
      'profile_image_url': profileImageUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}