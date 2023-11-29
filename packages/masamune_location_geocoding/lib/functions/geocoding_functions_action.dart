part of '/masamune_location_geocoding.dart';

/// [FunctionsAction] for obtaining location information from an address.
///
/// 住所から位置情報を取得するための[FunctionsAction]。
///
/// {@macro functions_action}
class GeocodingFunctionsAction
    extends FunctionsAction<GeocodingFunctionsActionFunctionsActionResponse> {
  /// [FunctionsAction] for obtaining location information from an address.
  ///
  /// 住所から位置情報を取得するための[FunctionsAction]。
  ///
  /// {@macro functions_action}
  const GeocodingFunctionsAction({
    required this.address,
  });

  /// The address you want to search.
  ///
  /// 検索したいアドレス。
  final String address;

  @override
  String get action => "geocoding";

  @override
  DynamicMap? toMap() {
    return {
      "address": address,
    };
  }

  @override
  GeocodingFunctionsActionFunctionsActionResponse toResponse(DynamicMap map) {
    final results = map.getAsList<Map>("results");
    if (results.isEmpty) {
      return const GeocodingFunctionsActionFunctionsActionResponse(
        latitude: 0,
        longitude: 0,
      );
    }
    final geometry = results.first
        .map((key, value) => MapEntry(key.toString(), value))
        .getAsMap("geometry");
    if (geometry.isEmpty) {
      return const GeocodingFunctionsActionFunctionsActionResponse(
        latitude: 0,
        longitude: 0,
      );
    }
    final location = geometry
        .map((key, value) => MapEntry(key.toString(), value))
        .getAsMap("location")
        .map((key, value) => MapEntry(key.toString(), value));
    if (location.isEmpty) {
      return const GeocodingFunctionsActionFunctionsActionResponse(
        latitude: 0,
        longitude: 0,
      );
    }
    final latitude = location.get("lat", 0.0);
    final longitude = location.get("lng", 0.0);
    return GeocodingFunctionsActionFunctionsActionResponse(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

/// Response to [FunctionsAction] to obtain location information from an address.
///
/// 住所から位置情報を取得するための[FunctionsAction]のレスポンス。
class GeocodingFunctionsActionFunctionsActionResponse
    extends FunctionsActionResponse {
  /// Response to [FunctionsAction] to obtain location information from an address.
  ///
  /// 住所から位置情報を取得するための[FunctionsAction]のレスポンス。
  const GeocodingFunctionsActionFunctionsActionResponse({
    required this.latitude,
    required this.longitude,
  });

  /// Latitude.
  ///
  /// 緯度。
  final double latitude;

  /// Longitude.
  ///
  /// 経度。
  final double longitude;
}
