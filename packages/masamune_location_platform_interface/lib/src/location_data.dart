part of '/masamune_location_platform_interface.dart';

/// Location data class.
///
/// 位置情報のデータクラス。
@immutable
class LocationData {
  const LocationData({
    required this.longitude,
    required this.latitude,
    required this.timestamp,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  /// Location data class.
  ///
  /// 位置情報のデータクラス。
  factory LocationData.fromJson(DynamicMap json) {
    return LocationData(
      latitude: json.get("latitude", 0.0),
      longitude: json.get("longitude", 0.0),
      timestamp: json.getAsDateTime("timestamp"),
      accuracy: json.get("accuracy", 0.0),
      altitude: json.get("altitude", 0.0),
      heading: json.get("heading", 0.0),
      speed: json.get("speed", 0.0),
      speedAccuracy: json.get("speed_accuracy", 0.0),
    );
  }

  /// The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  ///
  /// 正規化された度単位でのこの位置の緯度。-90.0から+90.0（両方とも含む）の間。
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  ///
  /// 度単位でのこの位置の経度。-180（排他）から+180（含む）の間。
  final double longitude;

  /// The time at which this position was determined.
  ///
  /// この位置が決定された時刻。
  final DateTime? timestamp;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned
  /// value is 0.0.
  ///
  /// デバイスの高度（メートル単位）。
  ///
  /// 高度はすべてのデバイスで利用できるわけではありません。この場合、返される値は0.0です。
  final double? altitude;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  ///
  /// 位置の推定水平精度（メートル単位）。
  ///
  /// 精度はすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double? accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is
  /// 0.0.
  ///
  /// デバイスが進行している方向の度数。
  ///
  /// ヘッディングはすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double? heading;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  ///
  /// The speed is not available on all devices. In these cases the value is
  /// 0.0.
  ///
  /// 地上の秒速メートルでデバイスが移動している速度。
  ///
  /// 速度はすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double? speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  ///
  /// この位置の推定速度精度（秒速メートル単位）。
  ///
  /// speedAccuracyはすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double? speedAccuracy;

  /// Converts from internal location information to [GeoValue].
  ///
  /// 内部の位置情報から[GeoValue]に変換します。
  GeoValue toGeoValue({
    double radiusKm = 1.0,
  }) {
    return GeoValue(latitude: latitude, longitude: longitude);
  }

  /// Convert [LocationData] to a Json map.
  ///
  /// [LocationData]をJsonマップに変換します。
  DynamicMap toJson() {
    final time = timestamp?.millisecondsSinceEpoch;
    return {
      "latitude": latitude,
      "longitude": longitude,
      if (time != null) "timestamp": time,
      "accuracy": accuracy,
      "altitude": altitude,
      "heading": heading,
      "speed": speed,
      "speed_accuracy": speedAccuracy,
    };
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      accuracy.hashCode ^
      altitude.hashCode ^
      heading.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      timestamp.hashCode;

  @override
  String toString() {
    return "Latitude: $latitude, Longitude: $longitude";
  }
}
