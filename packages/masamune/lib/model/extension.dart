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
  ImageProvider toImageProvider([String defaultAssetURI = "assets/image.png"]) {
    return Asset.image(value.toString(), defaultAssetURI);
  }

  /// Convert to [FormMediaValue].
  ///
  /// If [value] is empty, null is returned.
  ///
  /// [FormMediaValue]に変換します。
  ///
  /// [value]が空の場合はnullを返します。
  FormMediaValue? toFormMediaValue() {
    if (value.isEmpty) {
      return null;
    }
    return FormMediaValue(uri: value, type: FormMediaType.image);
  }
}

/// Extension methods for [ModelVideoUri].
///
/// [ModelVideoUri]の拡張メソッドです。
extension ModelVideoUriExtensions on ModelVideoUri {
  /// Convert to [FormMediaValue].
  ///
  /// If [value] is empty, null is returned.
  ///
  /// [FormMediaValue]に変換します。
  ///
  /// [value]が空の場合はnullを返します。
  FormMediaValue? toFormMediaValue() {
    if (value.isEmpty) {
      return null;
    }
    return FormMediaValue(uri: value, type: FormMediaType.video);
  }
}
