part of firebase_model_notifier;

extension FirebaseGeoMapExtensions<K, V> on Map<K, V> {
  /// Get the geo point corresponding to [key] in the map.
  ///
  /// If [key] is not found, the geo point of [orElse] is returned.
  GeoPoint getAsGeoPoint(K key, [GeoPoint? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? const GeoPoint(0, 0);
    }
    return (this[key] as GeoPoint?) ?? orElse ?? const GeoPoint(0, 0);
  }

  /// Get the firebase geo data corresponding to [key] in the map.
  ///
  /// If [key] is not found, the firebase geo data of [orElse] is returned.
  FirebaseGeoData getAsFirebaseGeoData(K key, [FirebaseGeoData? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? FirebaseGeoData();
    }
    return (this[key] as FirebaseGeoData?) ?? orElse ?? FirebaseGeoData();
  }
}

extension NullableFirebaseGeoMapExtensions<K, V> on Map<K, V>? {
  /// Get the geo point corresponding to [key] in the map.
  ///
  /// If [key] is not found, the geo point of [orElse] is returned.
  GeoPoint getAsGeoPoint(K key, [GeoPoint? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? const GeoPoint(0, 0);
    }
    return (this![key] as GeoPoint?) ?? orElse ?? const GeoPoint(0, 0);
  }

  /// Get the firebase geo data corresponding to [key] in the map.
  ///
  /// If [key] is not found, the firebase geo data of [orElse] is returned.
  FirebaseGeoData getAsFirebaseGeoData(K key, [FirebaseGeoData? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? FirebaseGeoData();
    }
    return (this![key] as FirebaseGeoData?) ?? orElse ?? FirebaseGeoData();
  }
}
