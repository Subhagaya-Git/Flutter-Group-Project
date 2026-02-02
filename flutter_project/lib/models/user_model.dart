class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? shippingAddress;
  final String? profileImageUrl;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.shippingAddress,
    this.profileImageUrl,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'],
      shippingAddress: json['shipping_address'],
      profileImageUrl: json['profile_image_url'],
      role: json['role'] ?? 'Buyer',
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
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? shippingAddress,
    String? profileImageUrl,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
    );
  }
}