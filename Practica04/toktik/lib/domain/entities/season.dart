enum Season {
  auto,
  normal,
  halloween,
  christmas,
  valentine,
}

extension SeasonX on Season {
  String get storageKey => name;

  String get label {
    switch (this) {
      case Season.auto:
        return 'AUTO';
      case Season.normal:
        return 'NORMAL';
      case Season.halloween:
        return 'HALLOWEEN';
      case Season.christmas:
        return 'CHRISTMAS';
      case Season.valentine:
        return 'VALENTINE';
    }
  }

  static Season fromStorage(String? value) {
    if (value == null || value.isEmpty) return Season.auto;
    return Season.values.firstWhere(
      (s) => s.name == value,
      orElse: () => Season.auto,
    );
  }
}
