/// Versioned JSON backup of the whole local database.
///
/// The payload is a plain map so it can be written to a `.json` file and
/// shared, then parsed back on import. Domain objects are intentionally
/// kept out: this layer only moves JSON around, so a future app version
/// can still read an old backup as long as the format version matches.
class BackupPayload {
  const BackupPayload({
    required this.exportedAt,
    required this.invoices,
    required this.clients,
    this.businessProfile,
    this.emailTemplate,
    this.catalogItems = const [],
  });

  static const format = 'facture-backup';

  /// Bumped whenever the payload shape changes in a breaking way.
  static const version = 1;

  final DateTime exportedAt;
  final List<Map<String, dynamic>> invoices;
  final List<Map<String, dynamic>> clients;
  final Map<String, dynamic>? businessProfile;
  final Map<String, dynamic>? emailTemplate;
  final List<Map<String, dynamic>> catalogItems;

  Map<String, dynamic> toJson() => {
        'format': format,
        'version': version,
        'exportedAt': exportedAt.toIso8601String(),
        'invoices': invoices,
        'clients': clients,
        if (businessProfile != null) 'businessProfile': businessProfile,
        if (emailTemplate != null) 'emailTemplate': emailTemplate,
        if (catalogItems.isNotEmpty) 'catalogItems': catalogItems,
      };

  /// Parses and validates a decoded backup document.
  ///
  /// Throws [FormatException] when the document is not a Facture backup,
  /// when its version is newer than this app understands, or when a
  /// section has the wrong shape. Unknown extra fields are ignored so
  /// newer backups stay forward-compatible where possible.
  factory BackupPayload.parse(Map<String, dynamic> json) {
    if (json['format'] != format) {
      throw const FormatException('Not a Facture backup file.');
    }
    final version = json['version'];
    if (version is! int || version > BackupPayload.version) {
      throw const FormatException('Unsupported backup version.');
    }
    return BackupPayload(
      exportedAt: DateTime.tryParse(json['exportedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      invoices: _mapList(json, 'invoices'),
      clients: _mapList(json, 'clients'),
      businessProfile: _mapOrNull(json, 'businessProfile'),
      emailTemplate: _mapOrNull(json, 'emailTemplate'),
      catalogItems: _mapList(json, 'catalogItems'),
    );
  }

  static List<Map<String, dynamic>> _mapList(
    Map<String, dynamic> json,
    String key,
  ) {
    final raw = json[key];
    if (raw == null) return const [];
    if (raw is! List) {
      throw FormatException('Invalid backup: "$key" must be a list.');
    }
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  static Map<String, dynamic>? _mapOrNull(
    Map<String, dynamic> json,
    String key,
  ) {
    final raw = json[key];
    if (raw == null) return null;
    if (raw is! Map<String, dynamic>) {
      throw FormatException('Invalid backup: "$key" must be an object.');
    }
    return raw;
  }
}
