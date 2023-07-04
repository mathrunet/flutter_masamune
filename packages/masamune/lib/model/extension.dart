part of masamune;

/// Extension methods for [ModelImageUri].
///
/// [ModelImageUri]の拡張メソッドです。
extension ModelImageUriExtensions on ModelImageUri {
  /// Get a [ImageProvider].
  ///
  /// If [defaultAssetURI] is specified, use [defaultAssetURI] if [ImageProvider] cannot be obtained.
  ///
  /// [ImageProvider]を取得します。
  ///
  /// [defaultAssetURI]が指定されている場合、[ImageProvider]が取得できない場合は[defaultAssetURI]を使用します。
  ImageProvider image([String defaultAssetURI = "assets/image.png"]) {
    return Asset.image(value.toString(), defaultAssetURI);
  }
}
