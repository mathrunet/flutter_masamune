part of firebase_model_notifier;

class _GeoUtility {
  _GeoUtility() {
    for (var i = 0; i < BASE32_CODES.length; i++) {
      base32CodesDic.putIfAbsent(BASE32_CODES[i], () => i);
    }
  }

  static const double EARTH_EQ_RADIUS = 6378137;

  static const double EARTH_POLAR_RADIUS = 6357852.3;

  static double distance(_Coordinates location1, _Coordinates location2) {
    return calcDistance(
      location1.latitude,
      location1.longitude,
      location2.latitude,
      location2.longitude,
    );
  }

  static double calcDistance(
    double lat1,
    double long1,
    double lat2,
    double long2,
  ) {
    const double radius = (EARTH_EQ_RADIUS + EARTH_POLAR_RADIUS) / 2;
    final double latDelta = _toRadians(lat1 - lat2);
    final double lonDelta = _toRadians(long1 - long2);

    final double a = (sin(latDelta / 2) * sin(latDelta / 2)) +
        (cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(lonDelta / 2) *
            sin(lonDelta / 2));
    final double distance = radius * 2 * atan2(sqrt(a), sqrt(1 - a)) / 1000;
    return double.parse(distance.toStringAsFixed(3));
  }

  static double _toRadians(double num) {
    return num * (pi / 180.0);
  }

  static const BASE32_CODES = '0123456789bcdefghjkmnpqrstuvwxyz';
  Map<String, int> base32CodesDic = <String, int>{};

  void util() {
    for (var i = 0; i < BASE32_CODES.length; i++) {
      base32CodesDic.putIfAbsent(BASE32_CODES[i], () => i);
    }
  }

  static const encodeAuto = 'auto';

  static const sigfigHashLength = [0, 5, 7, 8, 11, 12, 13, 15, 16, 17, 18];

  String encode(dynamic latitude, dynamic longitude, dynamic numberOfChars) {
    if (numberOfChars == encodeAuto) {
      if (latitude.runtimeType == double || longitude.runtimeType == double) {
        throw Exception('string notation required for auto precision.');
      }
      final decSigFigsLat = (latitude as String).split('.')[1].length;
      final decSigFigsLon = (longitude as String).split('.')[1].length;
      final numberOfSigFigs = max(decSigFigsLat, decSigFigsLon);
      numberOfChars = sigfigHashLength[numberOfSigFigs];
    } else {
      numberOfChars ??= 9;
    }

    final chars = <String>[];
    int bits = 0, bitsTotal = 0, hashValue = 0;
    double maxLat = 90, minLat = -90, maxLon = 180, minLon = -180, mid;

    while (chars.length < numberOfChars) {
      if (bitsTotal.isEven) {
        mid = (maxLon + minLon) / 2;
        if (longitude > mid) {
          hashValue = (hashValue << 1) + 1;
          minLon = mid;
        } else {
          hashValue = (hashValue << 1) + 0;
          maxLon = mid;
        }
      } else {
        mid = (maxLat + minLat) / 2;
        if (latitude > mid) {
          hashValue = (hashValue << 1) + 1;
          minLat = mid;
        } else {
          hashValue = (hashValue << 1) + 0;
          maxLat = mid;
        }
      }

      bits++;
      bitsTotal++;
      if (bits == 5) {
        final code = BASE32_CODES[hashValue];
        chars.add(code);
        bits = 0;
        hashValue = 0;
      }
    }

    return chars.join('');
  }

  List<double> decodeBbox(String hashString) {
    var isLon = true;
    double maxLat = 90, minLat = -90, maxLon = 180, minLon = -180, mid;

    int hashValue = 0;
    final l = hashString.length;
    for (int i = 0; i < l; i++) {
      final code = hashString[i].toLowerCase();
      hashValue = base32CodesDic[code] ?? 0;

      for (var bits = 4; bits >= 0; bits--) {
        final bit = (hashValue >> bits) & 1;
        if (isLon) {
          mid = (maxLon + minLon) / 2;
          if (bit == 1) {
            minLon = mid;
          } else {
            maxLon = mid;
          }
        } else {
          mid = (maxLat + minLat) / 2;
          if (bit == 1) {
            minLat = mid;
          } else {
            maxLat = mid;
          }
        }
        isLon = !isLon;
      }
    }
    return [minLat, minLon, maxLat, maxLon];
  }

  Map<String, double> decode(String hashString) {
    final bbox = decodeBbox(hashString);
    final lat = (bbox[0] + bbox[2]) / 2;
    final lon = (bbox[1] + bbox[3]) / 2;
    final latErr = bbox[2] - lat;
    final lonErr = bbox[3] - lon;
    return {
      'latitude': lat,
      'longitude': lon,
      'latitudeError': latErr,
      'longitudeError': lonErr,
    };
  }

  String neighbor(String hashString, List<double> direction) {
    final lonLat = decode(hashString);
    final neighborLat =
        lonLat['latitude']! + direction[0] * lonLat['latitudeError']! * 2;
    final neighborLon =
        lonLat['longitude']! + direction[1] * lonLat['longitudeError']! * 2;
    return encode(neighborLat, neighborLon, hashString.length);
  }

  List<String> neighbors(String hashString) {
    final hashStringLength = hashString.length;
    final lonlat = decode(hashString);
    final lat = lonlat['latitude']!;
    final lon = lonlat['longitude']!;
    final latErr = lonlat['latitudeError']! * 2;
    final lonErr = lonlat['longitudeError']! * 2;

    String encodeNeighbor(neighborLatDir, neighborLonDir) {
      final neighborLat = lat + neighborLatDir * latErr;
      final neighborLon = lon + neighborLonDir * lonErr;
      return encode(neighborLat, neighborLon, hashStringLength);
    }

    final neighborHashList = [
      encodeNeighbor(1, 0),
      encodeNeighbor(1, 1),
      encodeNeighbor(0, 1),
      encodeNeighbor(-1, 1),
      encodeNeighbor(-1, 0),
      encodeNeighbor(-1, -1),
      encodeNeighbor(0, -1),
      encodeNeighbor(1, -1)
    ];

    return neighborHashList;
  }

  static int setPrecision(double km) {
    if (km <= 0.00477)
      return 9;
    else if (km <= 0.0382)
      return 8;
    else if (km <= 0.153)
      return 7;
    else if (km <= 1.22)
      return 6;
    else if (km <= 4.89)
      return 5;
    else if (km <= 39.1)
      return 4;
    else if (km <= 156)
      return 3;
    else if (km <= 1250)
      return 2;
    else
      return 1;
  }
}
