/// Client domain model.
///
/// A client is who an invoice is billed to. Tax registration numbers are the
/// SUPPLIER's (the freelancer's) and live in the business profile / settings;
/// the optional numbers here are the client's own, kept for B2B records.
///
/// Clients live on-device only (local-first): the repository persists them
/// as JSON in SharedPreferences. No account, no cloud.
library;

/// A freelance client.
class Client {
  const Client({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.tpsNumber,
    this.tvqNumber,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String notes;

  /// Client's own GST/TPS registration number, if known. Optional.
  final String? tpsNumber;

  /// Client's own QST/TVQ registration number, if known. Optional.
  final String? tvqNumber;

  /// When the client was added. Null for records saved before this field
  /// existed — treated as the oldest when sorting. New clients get stamped
  /// by [ClientsNotifier.saveClient].
  final DateTime? createdAt;

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? notes,
    String? tpsNumber,
    String? tvqNumber,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      tpsNumber: tpsNumber ?? this.tpsNumber,
      tvqNumber: tvqNumber ?? this.tvqNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'notes': notes,
    'tpsNumber': tpsNumber,
    'tvqNumber': tvqNumber,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    address: json['address'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
    tpsNumber: json['tpsNumber'] as String?,
    tvqNumber: json['tvqNumber'] as String?,
    createdAt: json['createdAt'] is int
        ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
        : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          address == other.address &&
          notes == other.notes &&
          tpsNumber == other.tpsNumber &&
          tvqNumber == other.tvqNumber &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    phone,
    address,
    notes,
    tpsNumber,
    tvqNumber,
    createdAt,
  );
}
