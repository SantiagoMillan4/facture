/// One reusable service/item: a description and its default unit price.
///
/// Prices are integer cents (the tax math never touches floats). The UI
/// enters dollars; the form converts.
class CatalogItem {
  const CatalogItem({
    required this.id,
    required this.description,
    required this.unitPriceCents,
  });

  final String id;
  final String description;
  final int unitPriceCents;

  CatalogItem copyWith({String? description, int? unitPriceCents}) =>
      CatalogItem(
        id: id,
        description: description ?? this.description,
        unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'unitPriceCents': unitPriceCents,
      };

  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
        id: json['id'] as String? ?? '',
        description: json['description'] as String? ?? '',
        unitPriceCents: (json['unitPriceCents'] as num?)?.toInt() ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogItem &&
          id == other.id &&
          description == other.description &&
          unitPriceCents == other.unitPriceCents;

  @override
  int get hashCode => Object.hash(id, description, unitPriceCents);

  /// Fresh ids for user-created items.
  static String newId() =>
      'ci${DateTime.now().microsecondsSinceEpoch}';
}
