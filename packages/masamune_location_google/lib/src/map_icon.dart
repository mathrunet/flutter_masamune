part of masamune_location_google;

/// Definition class for downloading icon images for use in GoogleMap.
///
/// Pass to [MapView.iconSettings].
///
/// GoogleMapで利用するアイコン画像をダウンロードするための定義クラス。
///
/// [MapView.iconSettings]に渡します。
class MapIconSetting {
  /// Definition class for downloading icon images for use in GoogleMap.
  ///
  /// Pass to [MapView.iconSettings].
  ///
  /// GoogleMapで利用するアイコン画像をダウンロードするための定義クラス。
  ///
  /// [MapView.iconSettings]に渡します。
  MapIconSetting(
    this.path, {
    this.width = 100,
  }) : icon = null;

  MapIconSetting._({
    required this.path,
    this.width = 100,
    required this.icon,
  });

  /// Path of the icon image.
  ///
  /// Specify the relative path corresponding to the image to be acquired at [rootBundle].
  ///
  /// アイコンイメージのパス。
  ///
  /// [rootBundle]にてイメージを取得するのでそれに対応した相対パスを指定します。
  final String path;

  /// Size of the icon image.
  ///
  /// アイコンイメージのサイズ。
  final int width;

  /// Actual icon image data.
  ///
  /// This is passed to [Marker.icon], etc.
  ///
  /// 実際のアイコンイメージのデータ。
  ///
  /// これを[Marker.icon]などに渡します。
  final BitmapDescriptor? icon;

  /// Copy [MapIconSetting].
  ///
  /// [MapIconSetting]をコピーします。
  MapIconSetting copyWith({
    String? path,
    int? width,
    BitmapDescriptor? icon,
  }) {
    return MapIconSetting._(
      path: path ?? this.path,
      width: width ?? this.width,
      icon: icon ?? this.icon,
    );
  }
}
