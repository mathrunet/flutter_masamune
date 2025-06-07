part of "/katana_model.dart";

/// Define a model [GeoValue] that stores location information.
///
/// The base value is given as [value]. If not given, latitude and longitude are set to 0.
///
/// This can be passed to the server for searching by GeoHash.
///
/// 位置情報を保存する[GeoValue]をモデルとして定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合緯度・経度が0としてセットされます。
///
/// これをサーバーに渡すことでGeoHashによる検索が可能です。
@immutable
class ModelGeoValue extends ModelFieldValue<GeoValue>
    implements Comparable<ModelGeoValue> {
  /// Define a model [GeoValue] that stores location information.
  ///
  /// The base value is given as [value]. If not given, latitude and longitude are set to 0.
  ///
  /// This can be passed to the server for searching by GeoHash.
  ///
  /// 位置情報を保存する[GeoValue]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合緯度・経度が0としてセットされます。
  ///
  /// これをサーバーに渡すことでGeoHashによる検索が可能です。
  const factory ModelGeoValue([GeoValue? value]) = _ModelGeoValue;

  /// Define a model [GeoValue] that stores location information.
  ///
  /// The base value is given as [value]. If not given, latitude and longitude are set to 0.
  ///
  /// This can be passed to the server for searching by GeoHash.
  ///
  /// 位置情報を保存する[GeoValue]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合緯度・経度が0としてセットされます。
  ///
  /// これをサーバーに渡すことでGeoHashによる検索が可能です。
  const factory ModelGeoValue.fromDouble({
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) = _ModelGeoValueWithDouble;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelGeoValue.fromServer([GeoValue? value]) =
      _ModelGeoValue.fromServer;

  /// Convert from [json] map to [ModelGeoValue].
  ///
  /// [json]のマップから[ModelGeoValue]に変換します。
  factory ModelGeoValue.fromJson(DynamicMap json) {
    return ModelGeoValue.fromServer(
      GeoValue(
        latitude: json.get(kLatitudeKey, 0.0),
        longitude: json.get(kLongitudeKey, 0.0),
      ),
    );
  }

  const ModelGeoValue._([
    GeoValue? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelGeoValue";

  /// Key to save latitude.
  ///
  /// 緯度を保存しておくキー。
  static const kLatitudeKey = "@lagitude";

  /// Key to store longitude.
  ///
  /// 経度を保存しておくキー。
  static const kLongitudeKey = "@longitude";

  /// Key to save GeoHash.
  ///
  /// GeoHashを保存しておくキー。
  static const kGeoHashKey = "@geoHash";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  GeoValue get value => _value ?? const GeoValue(latitude: 0.0, longitude: 0.0);
  final GeoValue? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelGeoValue.typeString,
        kLatitudeKey: value.latitude,
        kLongitudeKey: value.longitude,
        kGeoHashKey: value.geoHash,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelGeoValue other) {
    return value.compareTo(other.value);
  }
}

@immutable
class _ModelGeoValueWithDouble extends _ModelGeoValue {
  const _ModelGeoValueWithDouble({
    required this.latitude,
    required this.longitude,
    this.radiusKm,
  }) : super();

  final double latitude;
  final double longitude;
  final double? radiusKm;

  @override
  GeoValue? get _value {
    return GeoValue(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm ?? 1.0,
    );
  }
}

@immutable
class _ModelGeoValue extends ModelGeoValue
    with ModelFieldValueAsMapMixin<GeoValue> {
  const _ModelGeoValue([
    super.value,
  ]) : super._();
  const _ModelGeoValue.fromServer([GeoValue? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelGeoValue] as [ModelFieldValue].
///
/// [ModelGeoValue]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelGeoValueConverter extends ModelFieldValueConverter<ModelGeoValue> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelGeoValue] as [ModelFieldValue].
  ///
  /// [ModelGeoValue]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelGeoValueConverter();

  @override
  String get type => ModelGeoValue.typeString;

  @override
  ModelGeoValue fromJson(Map<String, Object?> map) {
    return ModelGeoValue.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelGeoValue value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelGeoValue] available to [ModelQuery.filters].
///
/// [ModelGeoValue]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelGeoValueFilter extends ModelFieldValueFilter<ModelGeoValue> {
  /// Filter class to make [ModelGeoValue] available to [ModelQuery.filters].
  ///
  /// [ModelGeoValue]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelGeoValueFilter();

  @override
  String get type => ModelGeoValue.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.compareTo(b));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(s, target, (source, target) => source == target) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source == target) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.geoHash:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty(
            (t) => _hasMatch(
              source,
              t,
              (source, target) => RegExp("^$target").hasMatch(source),
            ),
          );
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(String source, String target) filter,
  ) {
    if (source is ModelGeoValue && target is ModelGeoValue) {
      return filter(source.value.geoHash, target.value.geoHash);
    } else if (source is ModelGeoValue && target is GeoValue) {
      return filter(source.value.geoHash, target.geoHash);
    } else if (source is GeoValue && target is ModelGeoValue) {
      return filter(source.geoHash, target.value.geoHash);
    } else if (source is ModelGeoValue && target is String) {
      return filter(source.value.geoHash, target);
    } else if (source is DynamicMap && target is String) {
      return filter(ModelGeoValue.fromJson(source).value.geoHash, target);
    } else if (source is String && target is ModelGeoValue) {
      return filter(source, target.value.geoHash);
    } else if (source is ModelGeoValue &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelGeoValue.typeString) {
      return filter(
          source.value.geoHash, ModelGeoValue.fromJson(target).value.geoHash);
    } else if (source is DynamicMap &&
        target is ModelGeoValue &&
        source.get(kTypeFieldKey, "") == ModelGeoValue.typeString) {
      return filter(
          ModelGeoValue.fromJson(source).value.geoHash, target.value.geoHash);
    } else if (source is GeoValue &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelGeoValue.typeString) {
      return filter(
          source.geoHash, ModelGeoValue.fromJson(target).value.geoHash);
    } else if (source is DynamicMap &&
        target is GeoValue &&
        source.get(kTypeFieldKey, "") == ModelGeoValue.typeString) {
      return filter(
          ModelGeoValue.fromJson(source).value.geoHash, target.geoHash);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelGeoValue.typeString &&
        target.get(kTypeFieldKey, "") == ModelGeoValue.typeString) {
      return filter(
        ModelGeoValue.fromJson(source).value.geoHash,
        ModelGeoValue.fromJson(target).value.geoHash,
      );
    }
    return null;
  }
}

/// Data to store location information.
///
/// Specify the latitude in [latitude] and longitude in [longitude]. Specify the radius of the range in [radiusKm] to generate a GeoHash accordingly.
///
/// Using [distance] and [direction], you can calculate the distance and direction to other location information.
///
/// Using [neighbors], you can get the surrounding GeoHash.
///
/// 位置情報を保存するためのデータ。
///
/// [latitude]に緯度、[longitude]に経度を指定します。[radiusKm]に範囲の半径を指定するとそれに応じたGeoHashが生成されます。
///
/// [distance]や[direction]を使うことで、他の位置情報との距離や方向を計算することができます。
///
/// [neighbors]を使うことで、周辺のGeoHashを取得することができます。
@immutable
class GeoValue implements Comparable<GeoValue> {
  /// Data to store location information.
  ///
  /// Specify the latitude in [latitude] and longitude in [longitude]. Specify the radius of the range in [radiusKm] to generate a GeoHash accordingly.
  ///
  /// Using [distance] and [direction], you can calculate the distance and direction to other location information.
  ///
  /// Using [neighbors], you can get the surrounding GeoHash.
  ///
  /// 位置情報を保存するためのデータ。
  ///
  /// [latitude]に緯度、[longitude]に経度を指定します。[radiusKm]に範囲の半径を指定するとそれに応じたGeoHashが生成されます。
  ///
  /// [distance]や[direction]を使うことで、他の位置情報との距離や方向を計算することができます。
  ///
  /// [neighbors]を使うことで、周辺のGeoHashを取得することができます。
  const GeoValue({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 1.0,
  }) : assert(radiusKm > 0.0, "[radiusKm] must be greater than 0.0");

  /// Calculates the distance between [from] and [to].
  ///
  /// Returned in kilometers.
  ///
  /// [from]と[to]の間の距離を計算します。
  ///
  /// km単位で返されます。
  static double distanceKmBetween({
    required GeoValue to,
    required GeoValue from,
  }) {
    return _GeoUtility.distance(from, to);
  }

  /// Calculates the direction from [from] to [to].
  ///
  /// Returned at a maximum of 180 degrees.
  ///
  /// [from]から[to]への方向を計算します。
  ///
  /// 最大180度で返されます。
  static double directionBetween({
    required GeoValue to,
    required GeoValue from,
  }) {
    return _GeoUtility.direction(from, to);
  }

  /// Returns the neighboring GeoHash for [center].
  ///
  /// [center]に対して隣り合うGeoHashを返します。
  static List<String> neighborsOf({required GeoValue center}) {
    return _util.neighbors(center.geoHash);
  }

  static final _GeoUtility _util = _GeoUtility();

  /// Radius to determine the extent of the GeoHash.
  ///
  /// GeoHashの範囲を決定するための半径。
  final double radiusKm;

  /// Latitude.
  ///
  /// 緯度。
  final double latitude;

  /// Longitude.
  ///
  /// 経度。
  final double longitude;

  /// Returns a GeoHash that contains [latitude] and [longitude] and has a range of [radiusKm].
  ///
  /// [latitude]と[longitude]が含まれ、[radiusKm]の範囲を持つGeoHashを返します。
  String get geoHash {
    return _util.encode(
      latitude,
      longitude,
      _GeoUtility.setPrecision(radiusKm),
    );
  }

  /// Returns the adjacent GeoHash.
  ///
  /// 隣り合うGeoHashを返します。
  List<String> get neighbors {
    return _util.neighbors(geoHash);
  }

  /// Returns the distance to [target].
  ///
  /// Returned in kilometers.
  ///
  /// [target]との距離を返します。
  ///
  /// km単位で返されます。
  double distanceKm(GeoValue target) {
    return distanceKmBetween(
      from: this,
      to: target,
    );
  }

  /// Calculates the direction to [target].
  ///
  /// Returned at a maximum of 180 degrees.
  ///
  /// [target]への方向を計算します。
  ///
  /// 最大180度で返されます。
  double direction(GeoValue target) {
    return directionBetween(
      from: this,
      to: target,
    );
  }

  /// Specify [radiusKm] to generate a new [GeoValue].
  ///
  /// [radiusKm]を指定して、新しい[GeoValue]を生成します。
  GeoValue withRadius(double radiusKm) {
    return copyWith(radiusKm: radiusKm);
  }

  /// Generate a new [GeoValue].
  ///
  /// 新たな[GeoValue]を生成します。
  GeoValue copyWith({
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) {
    return GeoValue(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return "($latitude, $longitude)";
  }

  @override
  int compareTo(GeoValue other) {
    return geoHash.compareTo(other.geoHash);
  }
}

class _GeoUtility {
  _GeoUtility() {
    for (var i = 0; i < base32Codes.length; i++) {
      base32CodesDic.putIfAbsent(base32Codes[i], () => i);
    }
  }
  static const base32Codes = "0123456789bcdefghjkmnpqrstuvwxyz";
  static const double earthEQRadius = 6378137.0;
  static const double earthPolarRadius = 6357852.3;
  static const encodeAuto = "auto";
  static const sigfigHashLength = [0, 5, 7, 8, 11, 12, 13, 15, 16, 17, 18];

  Map<String, int> base32CodesDic = <String, int>{};

  static double distance(GeoValue from, GeoValue to) {
    return _calcDistance(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  static double _calcDistance(
    double lat1,
    double long1,
    double lat2,
    double long2,
  ) {
    const double radius = (earthEQRadius + earthPolarRadius) / 2;
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

  static double direction(GeoValue from, GeoValue to) {
    return _calcDirection(
      to.latitude,
      to.longitude,
      from.latitude,
      from.longitude,
    );
  }

  static double _calcDirection(
    double lat1,
    double long1,
    double lat2,
    double long2,
  ) {
    final y2 = pi * long2 / 180.0;
    final y1 = pi * long1 / 180.0;
    final x2 = pi * lat2 / 180.0;
    final x1 = pi * lat1 / 180.0;
    final w = 180 *
        atan2(
          sin(x2 - x1),
          cos(y1) * tan(y2) - sin(y1) * cos(x2 - x1),
        ) /
        pi;
    return w - 90;
  }

  static double _toRadians(double num) {
    return num * (pi / 180.0);
  }

  void util() {
    for (var i = 0; i < base32Codes.length; i++) {
      base32CodesDic.putIfAbsent(base32Codes[i], () => i);
    }
  }

  String encode(dynamic latitude, dynamic longitude, dynamic numberOfChars) {
    if (numberOfChars == encodeAuto) {
      if (latitude.runtimeType == double || longitude.runtimeType == double) {
        throw Exception("string notation required for auto precision.");
      }
      final decSigFigsLat = (latitude as String).split(".")[1].length;
      final decSigFigsLon = (longitude as String).split(".")[1].length;
      final numberOfSigFigs = max(decSigFigsLat, decSigFigsLon);
      numberOfChars = sigfigHashLength[numberOfSigFigs];
    } else {
      numberOfChars ??= 9;
    }

    final chars = <String>[];
    var bits = 0, bitsTotal = 0, hashValue = 0;
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
        final code = base32Codes[hashValue];
        chars.add(code);
        bits = 0;
        hashValue = 0;
      }
    }

    return chars.join("");
  }

  List<double> decodeBbox(String hashString) {
    var isLon = true;
    double maxLat = 90, minLat = -90, maxLon = 180, minLon = -180, mid;

    var hashValue = 0;
    final l = hashString.length;
    for (var i = 0; i < l; i++) {
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
      "latitude": lat,
      "longitude": lon,
      "latitudeError": latErr,
      "longitudeError": lonErr,
    };
  }

  String neighbor(String hashString, List<double> direction) {
    final lonLat = decode(hashString);
    final neighborLat =
        lonLat["latitude"]! + direction[0] * lonLat["latitudeError"]! * 2;
    final neighborLon =
        lonLat["longitude"]! + direction[1] * lonLat["longitudeError"]! * 2;
    return encode(neighborLat, neighborLon, hashString.length);
  }

  List<String> neighbors(String hashString) {
    final hashStringLength = hashString.length;
    final lonlat = decode(hashString);
    final lat = lonlat["latitude"]!;
    final lon = lonlat["longitude"]!;
    final latErr = lonlat["latitudeError"]! * 2;
    final lonErr = lonlat["longitudeError"]! * 2;

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
    if (km <= 0.00477) {
      return 9;
    } else if (km <= 0.0382) {
      return 8;
    } else if (km <= 0.153) {
      return 7;
    } else if (km <= 1.22) {
      return 6;
    } else if (km <= 4.89) {
      return 5;
    } else if (km <= 39.1) {
      return 4;
    } else if (km <= 156) {
      return 3;
    } else if (km <= 1250) {
      return 2;
    } else {
      return 1;
    }
  }
}
