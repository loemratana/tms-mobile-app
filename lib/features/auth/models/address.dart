class Address {
  final int id;
  final String street;
  final String city;
  final String? state;
  final String zipCode;
  final String country;
  final bool isDefault;

  const Address({
    required this.id,
    required this.street,
    required this.city,
    this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int? ?? 0,
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}
