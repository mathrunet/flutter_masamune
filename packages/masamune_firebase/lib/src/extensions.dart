part of masamune_firebase;

extension UserExtensions on User {
  /// If the user data is empty, `true`.
  bool get isEmpty {
    return uid.isEmpty;
  }

  /// `true` if the user data does not come from.
  bool get isNotEmpty {
    return uid.isNotEmpty;
  }
}

extension NullableUserExtensions on User? {
  /// If the user data is empty, `true`.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.uid.isEmpty;
  }

  /// `true` if the user data does not come from.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.uid.isNotEmpty;
  }
}

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
