part of katana;

/// Provides general extensions to [Random].
extension RandomExtensions on Random {
  /// Get a random number from [min] to [max].
  int rangeInt(int min, int max) =>
      ((nextDouble() * (max - min)) + min).toInt().limit(min, max);

  /// Get a random number from [min] to [max].
  double rangeDouble(double min, double max) =>
      ((nextDouble() * (max - min)) + min).limit(min, max);
}
