part of firebase_model_notifier;

class _GeoFirePoint {
  _GeoFirePoint(this.latitude, this.longitude);

  static final _GeoUtility _util = _GeoUtility();
  double latitude, longitude;

  static double distanceBetween({
    required _Coordinates to,
    required _Coordinates from,
  }) {
    return _GeoUtility.distance(to, from);
  }

  static List<String> neighborsOf({required String hash}) {
    return _util.neighbors(hash);
  }

  String get hash {
    return _util.encode(latitude, longitude, 9);
  }

  List<String> get neighbors {
    return _util.neighbors(hash);
  }

  GeoPoint get geoPoint {
    return GeoPoint(latitude, longitude);
  }

  _Coordinates get coords {
    return _Coordinates(latitude, longitude);
  }

  double distance({
    required double lat,
    required double lng,
  }) {
    return distanceBetween(from: coords, to: _Coordinates(lat, lng));
  }

  DynamicMap get data {
    return {'geopoint': geoPoint, 'geohash': hash};
  }

  double haversineDistance({required double lat, required double lng}) {
    return _GeoFirePoint.distanceBetween(
      from: coords,
      to: _Coordinates(lat, lng),
    );
  }
}

class _Coordinates {
  _Coordinates(this.latitude, this.longitude);

  double latitude;
  double longitude;
}
