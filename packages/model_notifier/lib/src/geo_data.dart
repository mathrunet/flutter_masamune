part of model_notifier;

/// Stores location data.
///
/// Please inherit and use it.
@immutable
class GeoData {
  /// Stores location data.
  ///
  /// Please inherit and use it.
  const GeoData();

  static const double _r = 6378.137;

  /// Latitude.
  double get latitude => 0;

  /// Longitude.
  double get longitude => 0;

  /// Location name.
  String get name => "";

  /// Hash of [GeoData].
  String get hash => "";

  /// All neighbors of [GeoData].
  List<String> get neighbors => const [];

  /// Returns a hash list in the area by passing [radius].
  List<String> regionHash([double radius = 1.0]) => const [];

  /// Calculate the distance between two points.
  ///
  /// [data]: GeoData.
  double distance(GeoData data) {
    final y2 = pi * data.longitude / 180.0;
    final y1 = pi * longitude / 180.0;
    final x2 = pi * data.latitude / 180.0;
    final x1 = pi * latitude / 180.0;
    return _r * acos(sin(y1) * sin(y2) + cos(y1) * cos(y2) * cos(x2 - x1));
  }

  /// Calculate the direction between tow points.
  ///
  /// [target]: Target geoData.
  double direction(GeoData target) {
    final y2 = pi * target.longitude / 180.0;
    final y1 = pi * longitude / 180.0;
    final x2 = pi * target.latitude / 180.0;
    final x1 = pi * latitude / 180.0;
    final w = 180 *
        atan2(
          sin(x2 - x1),
          cos(y1) * tan(y2) - sin(y1) * cos(x2 - x1),
        ) /
        pi;
    return w - 90;
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ name.hashCode;

  /// Returns a string representation of this object.
  @override
  String toString() {
    return "$name[$latitude° N,$longitude° E]";
  }
}
