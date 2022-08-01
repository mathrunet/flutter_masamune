part of masamune_location;

/// Obtain location information.
///
/// If the location information is not listed, only the initial value is output.
LocationCompassData get location {
  final location = readProvider(locationProvider);
  return location.value;
}
