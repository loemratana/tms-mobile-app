class Permission {
  final int id;
  final String name;
  final String resource;
  final String action;
  final String? description;

  const Permission({
    required this.id,
    required this.name,
    required this.resource,
    required this.action,
    this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      resource: json['resource'] as String? ?? '',
      action: json['action'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}

class Role {
  final int roleId;
  final String roleName;
  final bool active;
  final String? description;
  final List<Permission> permissions;

  const Role({
    required this.roleId,
    required this.roleName,
    this.active = true,
    this.description,
    this.permissions = const [],
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['roleId'] as int? ?? 0,
      roleName: json['roleName'] as String? ?? '',
      active: json['active'] as bool? ?? true,
      description: json['description'] as String?,
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
