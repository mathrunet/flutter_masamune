part of masamune_location_platform_interface;

/// Data obtained from the terminal's compass.
///
/// 端末のコンパスから取得されたデータ。
@immutable
class CompassData {
  /// Data obtained from the terminal's compass.
  ///
  /// 端末のコンパスから取得されたデータ。
  const CompassData({
    required this.heading,
    required this.headingForCameraMode,
    required this.accuracy,
  });

  /// The heading, in degrees, of the device around its Z axis, or where the top of the device is pointing.
  ///
  /// Z軸を中心としたデバイスの進行方向 (度単位)、またはデバイスの上部が指している方向。
  final double? heading;

  /// The heading, in degrees, of the device around its X axis, or where the back of the device is pointing.
  ///
  /// X 軸を中心としたデバイスの進行方向 (度単位)、またはデバイスの背面が指している方向。
  final double? headingForCameraMode;

  /// The deviation error, in degrees, plus or minus from the heading.
  /// NOTE: for iOS this is computed by the platform and is reliable. For Android several values are hard-coded, and the true error could be more . or less than the value here.
  ///
  /// 機首方位からの偏差誤差 (度単位)。
  ///
  /// 注: iOS の場合、これはプラットフォームによって計算され、信頼性があります。 Android の場合、いくつかの値はハードコーディングされており、実際のエラーはさらに多くの値になる可能性があります。ここの値以下です。
  final double? accuracy;

  @override
  String toString() {
    return 'heading: $heading\nheadingForCameraMode: $headingForCameraMode\naccuracy: $accuracy';
  }

  @override
  int get hashCode =>
      heading.hashCode ^ headingForCameraMode.hashCode ^ accuracy.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
