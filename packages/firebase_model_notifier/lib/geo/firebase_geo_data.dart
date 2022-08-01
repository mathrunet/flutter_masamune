part of firebase_model_notifier;

/// GeoData for Firestore.
@immutable
class FirebaseGeoData extends GeoData {
  /// GeoData for Firestore.
  ///
  /// Specify [latitude] and [longitude] to set the location information.
  FirebaseGeoData({
    double latitude = 0,
    double longitude = 0,
    String? name,
  })  : _geoFirePoint = _GeoFirePoint(latitude, longitude),
        _name = name ?? "";

  /// GeoData for Firestore.
  ///
  /// Set the location information by specifying [geoPoint].
  FirebaseGeoData.fromGeoPoint(GeoPoint geoPoint, {String? name})
      : this(
          latitude: geoPoint.latitude,
          longitude: geoPoint.longitude,
          name: name,
        );

  /// GeoData for Firestore.
  ///
  /// Set the location information by specifying [getData].
  FirebaseGeoData.fromGeoData(GeoData geoData, {String? name})
      : this(
          latitude: geoData.latitude,
          longitude: geoData.longitude,
          name: name ?? geoData.name,
        );

  final _GeoFirePoint _geoFirePoint;

  /// Location name.
  @override
  String get name {
    if (_name.isNotEmpty) {
      return _name;
    }
    return "$latitude,$longitude";
  }

  final String _name;

  /// Latitude of location.
  @override
  double get latitude => _geoFirePoint.latitude;

  /// Longitude of location.
  @override
  double get longitude => _geoFirePoint.longitude;

  /// Geographical distance between two Co-ordinates.
  ///
  /// Calculates the distance between [to] and [from].
  static double distanceBetween({
    required _Coordinates to,
    required _Coordinates from,
  }) {
    return _GeoFirePoint.distanceBetween(to: to, from: from);
  }

  /// Neighboring geo-hashes of [hash].
  static List<String> neighborsOf({required String hash}) {
    return _GeoFirePoint.neighborsOf(hash: hash);
  }

  /// Hash of [GeoData].
  @override
  String get hash {
    return _geoFirePoint.hash;
  }

  /// All neighbors of [GeoData].
  @override
  List<String> get neighbors {
    return _geoFirePoint.neighbors;
  }

  /// [GeoPoint] of [GeoData].
  GeoPoint get geoPoint {
    return _geoFirePoint.geoPoint;
  }

  /// [Coorinates] of [GeoData].
  _Coordinates get coords {
    return _geoFirePoint.coords;
  }

  /// Returns a hash list in the area by passing [radius].
  @override
  List<String> regionHash([double radius = 1.0]) {
    if (radius <= 0) {
      return const [];
    }
    final precision = _GeoUtility.setPrecision(radius);
    final centerHash = hash.substring(0, precision);
    return _GeoFirePoint.neighborsOf(hash: centerHash)..add(centerHash);
  }

  /// Calculate the distance between two points.
  @override
  double distance(GeoData data) {
    return distanceBetween(
      from: coords,
      to: _Coordinates(data.latitude, data.longitude),
    );
  }

  /// Raw data.
  DynamicMap get data {
    return {'geopoint': geoPoint, 'geohash': hash};
  }
}
