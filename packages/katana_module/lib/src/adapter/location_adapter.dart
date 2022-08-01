part of katana_module;

/// Module adapter for setting up location.
///
/// [LocationAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class LocationAdapter extends AdapterModule {
  const LocationAdapter();

  /// Check whether the location is currently being acquired.
  bool get isListened;

  /// Check the permission status of the current location.
  bool get isPermitted;

  /// This class manages and monitors location information.
  ///
  /// Execute [listen()] to request location permission and monitor for changes.
  Future<void> listen({
    Duration? updateInterval,
    Duration timeout = const Duration(seconds: 60),
  });

  /// Abandon location information acquisition.
  void unlisten();

  /// Obtain location information.
  ///
  /// If the location information is not listed, only the initial value is output.
  LocationCompassData get location;

  /// Adds a callback to be executed when location information is updated.
  void addListener(VoidCallback callback);

  /// Removes a callback to be executed when location information is updated.
  void removeListener(VoidCallback callback);
}

/// Class for saving location information and compass information.
@immutable
class LocationCompassData {
  /// Class for saving location information and compass information.
  const LocationCompassData({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.speedAccuracy,
    this.heading,
    this.time,
    this.verticalAccuracy,
    this.headingAccuracy,
    this.elapsedRealtimeNanos,
    this.elapsedRealtimeUncertaintyNanos,
    this.satelliteNumber,
    this.provider,
    this.headingForCameraMode,
  });

  // Latitude in degrees
  final double? latitude;

  /// Longitude, in degrees
  final double? longitude;

  /// Estimated vertical accuracy of this location, in meters.
  final double? verticalAccuracy;

  /// In meters above the WGS 84 reference ellipsoid. Derived from GPS informations.
  ///
  /// Always 0 on Web
  final double? altitude;

  /// In meters/second
  ///
  /// Always 0 on Web
  final double? speed;

  /// In meters/second
  ///
  /// Always 0 on Web
  final double? speedAccuracy;

  /// timestamp of the LocationData
  final double? time;

  /// Get the estimated bearing accuracy of this location, in degrees.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getBearingAccuracyDegrees()
  final double? headingAccuracy;

  /// Return the time of this fix, in elapsed real-time since system boot.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getElapsedRealtimeNanos()
  final double? elapsedRealtimeNanos;

  /// Get estimate of the relative precision of the alignment of the ElapsedRealtimeNanos timestamp.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getElapsedRealtimeUncertaintyNanos()
  final double? elapsedRealtimeUncertaintyNanos;

  /// The number of satellites used to derive the fix.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getExtras()
  final int? satelliteNumber;

  /// The name of the provider that generated this fix.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getProvider()
  final String? provider;

  // The heading, in degrees, of the device around its Z
  // axis, or where the top of the device is pointing.
  final double? heading;

  // The heading, in degrees, of the device around its X axis, or
  // where the back of the device is pointing.
  final double? headingForCameraMode;

  // The deviation error, in degrees, plus or minus from the heading.
  // NOTE: for iOS this is computed by the platform and is reliable. For
  // Android several values are hard-coded, and the true error could be more
  // or less than the value here.
  final double? accuracy;

  /// Copy the LocationCompassData.
  LocationCompassData copyWith({
    double? latitude,
    double? longitude,
    double? verticalAccuracy,
    double? altitude,
    double? speed,
    double? speedAccuracy,
    double? time,
    double? headingAccuracy,
    double? elapsedRealtimeNanos,
    double? elapsedRealtimeUncertaintyNanos,
    int? satelliteNumber,
    String? provider,
    double? heading,
    double? headingForCameraMode,
    double? accuracy,
  }) {
    return LocationCompassData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
      heading: heading ?? this.heading,
      time: time ?? this.time,
      verticalAccuracy: verticalAccuracy ?? this.verticalAccuracy,
      headingAccuracy: headingAccuracy ?? this.headingAccuracy,
      elapsedRealtimeNanos: elapsedRealtimeNanos ?? this.elapsedRealtimeNanos,
      elapsedRealtimeUncertaintyNanos: elapsedRealtimeUncertaintyNanos ??
          this.elapsedRealtimeUncertaintyNanos,
      satelliteNumber: satelliteNumber ?? this.satelliteNumber,
      provider: provider ?? this.provider,
      headingForCameraMode: headingForCameraMode ?? this.headingForCameraMode,
    );
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
  bool operator ==(Object other) => other.hashCode == hashCode;

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
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      altitude.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      heading.hashCode ^
      time.hashCode ^
      verticalAccuracy.hashCode ^
      headingAccuracy.hashCode ^
      elapsedRealtimeNanos.hashCode ^
      elapsedRealtimeUncertaintyNanos.hashCode ^
      satelliteNumber.hashCode ^
      provider.hashCode ^
      headingForCameraMode.hashCode;
}
