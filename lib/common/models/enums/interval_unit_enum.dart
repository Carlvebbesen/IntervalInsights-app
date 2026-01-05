enum IntervalUnit {
  m,
  km,
  sec,
  min;

  /// Helper to map the string units back to our Enum

  static IntervalUnit fromString(String value) {
    return IntervalUnit.values.firstWhere(
      (e) => e.name.toLowerCase() == value,
      orElse: () => IntervalUnit.m,
    );
  }
}
