part of "/masamune_test.dart";

/// Device settings for Masamune Test.
///
/// Masamune Testのデバイス設定。
class MasamuneTestDevice {
  /// Device settings for Masamune Test.
  ///
  /// Masamune Testのデバイス設定。
  const MasamuneTestDevice({
    required this.size,
    required this.name,
    this.devicePixelRatio = 1.0,
    this.textScaleFactor = 1.0,
    this.brightness = Brightness.light,
    this.safeArea = const EdgeInsets.all(0),
  });

  /// [phonePortrait] matches specs of iphone16, but with lower DPI for performance.
  ///
  /// [phonePortrait]はiphone16の仕様に合わせたデバイス設定です。パフォーマンス向上のため、DPIを1.0に設定しています。
  static const MasamuneTestDevice phonePortrait = MasamuneTestDevice(
    name: "phone_portrait",
    size: Size(430, 932),
    safeArea: EdgeInsets.fromLTRB(0, 59, 0, 34),
  );

  /// [phoneLandscape] matches specs of iphone16, but in landscape mode.
  ///
  /// [phoneLandscape]はiphone16の仕様に合わせたデバイス設定です。パフォーマンス向上のため、DPIを1.0に設定しています。
  static const MasamuneTestDevice phoneLandscape = MasamuneTestDevice(
    name: "phone_landscape",
    size: Size(932, 430),
    safeArea: EdgeInsets.fromLTRB(59, 0, 34, 0),
  );

  /// [tabletLandscape] example of tablet that in landscape mode.
  ///
  /// [tabletLandscape]はタブレットの仕様に合わせたデバイス設定です。
  static const MasamuneTestDevice tabletLandscape = MasamuneTestDevice(
    name: "tablet_landscape",
    size: Size(1366, 1024),
  );

  /// [tabletPortrait] example of tablet that in portrait mode.
  ///
  /// [tabletPortrait]はタブレットの仕様に合わせたデバイス設定です。
  static const MasamuneTestDevice tabletPortrait = MasamuneTestDevice(
    name: "tablet_portrait",
    size: Size(1024, 1366),
  );

  /// [name] specify device name. Ex: Phone, Tablet, Watch.
  ///
  /// [name]はデバイスの名前を指定します。例: Phone, Tablet, Watch。
  final String name;

  /// [size] specify device screen size. Ex: Size(1366, 1024)).
  ///
  /// [size]はデバイスの画面サイズを指定します。例: Size(1366, 1024)。
  final Size size;

  /// [devicePixelRatio] specify device Pixel Ratio.
  ///
  /// [devicePixelRatio]はデバイスのピクセル比を指定します。
  final double devicePixelRatio;

  /// [textScaleFactor] specify custom text scale factor.
  ///
  /// [textScaleFactor]はテキストのスケールを指定します。
  final double textScaleFactor;

  /// [brightness] specify platform brightness.
  ///
  /// [brightness]はデバイスの明るさを指定します。
  final Brightness brightness;

  /// [safeArea] specify insets to define a safe area.
  ///
  /// [safeArea]はデバイスの安全領域を指定します。
  final EdgeInsets safeArea;

  /// [copyWith] convenience function for [MasamuneTestDevice] modification.
  ///
  /// [copyWith]は[MasamuneTestDevice]の設定を変更するための便利な関数です。
  MasamuneTestDevice copyWith({
    Size? size,
    double? devicePixelRatio,
    String? name,
    double? textScale,
    Brightness? brightness,
    EdgeInsets? safeArea,
  }) {
    return MasamuneTestDevice(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScaleFactor: textScale ?? textScaleFactor,
      brightness: brightness ?? this.brightness,
      safeArea: safeArea ?? this.safeArea,
    );
  }

  /// [dark] convenience method to copy the current device and apply dark theme.
  ///
  /// [dark]は現在のデバイスの設定をコピーし、ダークテーマを適用した新しいデバイスを返します。
  MasamuneTestDevice dark() {
    return MasamuneTestDevice(
      size: size,
      devicePixelRatio: devicePixelRatio,
      textScaleFactor: textScaleFactor,
      brightness: Brightness.dark,
      safeArea: safeArea,
      name: "${name}_dark",
    );
  }

  @override
  String toString() {
    return "Device: $name, "
        "${size.width}x${size.height} @ $devicePixelRatio, "
        "text: $textScaleFactor, $brightness, safe: $safeArea";
  }
}
