part of masamune_location;

/// This class manages and monitors location information.
///
/// Execute [listen()] to request location permission and monitor for changes.
class LocationCore {
  const LocationCore._();

  /// Check whether the location is currently being acquired.
  static bool get isListened {
    final location = readProvider(locationProvider);
    return location.isListened;
  }

  /// Check the permission status of the current location.
  static bool get isPermitted {
    final location = readProvider(locationProvider);
    return location.isPermitted;
  }

  /// This class manages and monitors location information.
  ///
  /// Execute [listen()] to request location permission and monitor for changes.
  static Future<void> listen({
    Duration? updateInterval,
    Duration timeout = const Duration(seconds: 60),
  }) {
    final location = readProvider(locationProvider);
    return location.listen(
      timeout: timeout,
      updateInterval: updateInterval,
    );
  }

  /// Abandon location information acquisition.
  static void unlisten() {
    final location = readProvider(locationProvider);
    return location.unlisten();
  }

  /// Obtain location information.
  ///
  /// If the location information is not listed, only the initial value is output.
  static LocationCompassData get location {
    final location = readProvider(locationProvider);
    return location.value;
  }

  /// Adds a callback to be executed when location information is updated.
  static void addListener(VoidCallback callback) {
    final location = readProvider(locationProvider);
    location.addListener(callback);
  }

  /// Removes a callback to be executed when location information is updated.
  static void removeListener(VoidCallback callback) {
    final location = readProvider(locationProvider);
    location.removeListener(callback);
  }
}
