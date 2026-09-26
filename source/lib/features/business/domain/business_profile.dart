/// The user's tax registration status. This is an explicit declaration:
/// either registered to collect TPS/TVQ (with registration numbers shown
/// on taxed invoices) or a small supplier who must not charge them.
enum TaxRegistrationStatus {
  /// Registered for TPS/TVQ; registration numbers are shown on invoices
  /// that charge taxes.
  registered,

  /// $30k-or-less small supplier: not registered, must not charge TPS/TVQ.
  smallSupplier,
}

/// The freelancer's own business identity, stored on-device.
///
/// Appears on invoice PDFs (header) and drives the invoice form's tax
/// default: a small supplier gets taxes off, a registered business gets
/// them on. Nothing here is a legal filing — the user declares their own
/// status and remains responsible for its accuracy.
class BusinessProfile {
  const BusinessProfile({
    this.name = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.taxStatus = TaxRegistrationStatus.registered,
    this.tpsNumber = '',
    this.tvqNumber = '',
    this.logoPath,
  });

  final String name;
  final String address;
  final String phone;
  final String email;
  final TaxRegistrationStatus taxStatus;
  final String tpsNumber;
  final String tvqNumber;

  /// On-device path of the business logo image shown on invoice PDFs.
  /// Null when the user hasn't chosen one.
  final String? logoPath;

  /// True once the user has filled in at least a business name.
  bool get isSetUp => name.trim().isNotEmpty;

  /// Whether the profile declares the business registered for TPS/TVQ.
  bool get chargesTaxes =>
      taxStatus == TaxRegistrationStatus.registered;

  /// Registration numbers shown on taxed invoices (may be empty when the
  /// user hasn't entered them yet).
  bool get hasTaxNumbers =>
      tpsNumber.trim().isNotEmpty || tvqNumber.trim().isNotEmpty;

  BusinessProfile copyWith({
    String? name,
    String? address,
    String? phone,
    String? email,
    TaxRegistrationStatus? taxStatus,
    String? tpsNumber,
    String? tvqNumber,
    String? logoPath,
  }) {
    return BusinessProfile(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxStatus: taxStatus ?? this.taxStatus,
      tpsNumber: tpsNumber ?? this.tpsNumber,
      tvqNumber: tvqNumber ?? this.tvqNumber,
      logoPath: logoPath ?? this.logoPath,
    );
  }

  /// Clears the logo (copyWith can't null a field out).
  BusinessProfile withoutLogo() => BusinessProfile(
        name: name,
        address: address,
        phone: phone,
        email: email,
        taxStatus: taxStatus,
        tpsNumber: tpsNumber,
        tvqNumber: tvqNumber,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'phone': phone,
    'email': email,
    'taxStatus': taxStatus.name,
    'tpsNumber': tpsNumber,
    'tvqNumber': tvqNumber,
    if (logoPath != null) 'logoPath': logoPath,
  };

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    TaxRegistrationStatus status = TaxRegistrationStatus.registered;
    final raw = json['taxStatus'];
    if (raw == TaxRegistrationStatus.smallSupplier.name) {
      status = TaxRegistrationStatus.smallSupplier;
    }
    return BusinessProfile(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      taxStatus: status,
      tpsNumber: json['tpsNumber'] as String? ?? '',
      tvqNumber: json['tvqNumber'] as String? ?? '',
      logoPath: json['logoPath'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessProfile &&
          name == other.name &&
          address == other.address &&
          phone == other.phone &&
          email == other.email &&
          taxStatus == other.taxStatus &&
          tpsNumber == other.tpsNumber &&
          tvqNumber == other.tvqNumber &&
          logoPath == other.logoPath;

  @override
  int get hashCode => Object.hash(
    name,
    address,
    phone,
    email,
    taxStatus,
    tpsNumber,
    tvqNumber,
    logoPath,
  );
}
