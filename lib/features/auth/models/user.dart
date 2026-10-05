import 'address.dart';
import 'role.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profileImage;
  final bool active;
  final List<Address> addresses;
  final List<Role> roles;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.profileImage,
    this.active = true,
    this.addresses = const [],
    this.roles = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      active: json['active'] as bool? ?? true,
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      roles: (json['role'] as List<dynamic>? ?? [])
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  String get displayName => name.isNotEmpty ? name : email;
}
