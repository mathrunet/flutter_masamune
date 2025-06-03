part of "/masamune_location.dart";

/// [Exception] when location services are not available.
///
/// 位置情報サービスが利用できない場合の[Exception]。
class LocationServiceNotAvailableException implements Exception {
  /// [Exception] when location services are not available.
  ///
  /// 位置情報サービスが利用できない場合の[Exception]。
  const LocationServiceNotAvailableException(this.message);

  /// A message describing the error.
  ///
  /// エラーを説明するメッセージ。
  final String message;

  @override
  String toString() {
    return "LocationServiceNotAvailableException: $message";
  }
}
