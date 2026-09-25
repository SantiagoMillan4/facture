/// Client domain model (scaffold stub).
///
/// A client is who an invoice is billed to. Tax registration numbers are the
/// SUPPLIER's (the freelancer's) and live in the business profile / settings;
/// the optional numbers here are the client's own, kept for B2B records.
///
/// TODO: persistence, per-client default payment terms / notes.
library;

/// A freelance client.
class Client {
  const Client({
    required this.id,
    required this.name,
    this.email = '',
    this.address = '',
    this.tpsNumber,
    this.tvqNumber,
  });

  final String id;
  final String name;
  final String email;
  final String address;

  /// Client's own GST/TPS registration number, if known. Optional.
  final String? tpsNumber;

  /// Client's own QST/TVQ registration number, if known. Optional.
  final String? tvqNumber;

  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? tpsNumber,
    String? tvqNumber,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      tpsNumber: tpsNumber ?? this.tpsNumber,
      tvqNumber: tvqNumber ?? this.tvqNumber,
    );
  }
}
