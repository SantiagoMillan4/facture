import 'client.dart';

/// Sort orders for the client directory.
enum ClientSort {
  nameAsc,
  nameDesc,
  newestFirst,
  oldestFirst;

  /// Key persisted in SharedPreferences.
  String get storageKey => name;

  static ClientSort fromStorageKey(String? key) =>
      values.firstWhere((s) => s.storageKey == key, orElse: () => nameAsc);

  /// Compares two clients under this sort order. Clients without a
  /// [Client.createdAt] (saved before the field existed) count as oldest;
  /// ties fall back to name order so the list is stable.
  int compare(Client a, Client b) {
    switch (this) {
      case ClientSort.nameAsc:
        return _byName(a, b);
      case ClientSort.nameDesc:
        return _byName(b, a);
      case ClientSort.newestFirst:
        return _byRecency(a, b, descending: true);
      case ClientSort.oldestFirst:
        return _byRecency(a, b, descending: false);
    }
  }

  static int _byName(Client a, Client b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());

  static int _byRecency(Client a, Client b, {required bool descending}) {
    final createdA = a.createdAt;
    final createdB = b.createdAt;
    final int byTime;
    if (createdA == null && createdB == null) {
      byTime = 0;
    } else if (createdA == null) {
      byTime = -1; // No timestamp counts as oldest.
    } else if (createdB == null) {
      byTime = 1;
    } else {
      byTime = createdA.compareTo(createdB);
    }
    if (byTime != 0) return descending ? -byTime : byTime;
    return _byName(a, b);
  }
}
