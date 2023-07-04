part of masamune;

/// Extension methods for [FormMediaValue].
///
/// [FormMediaValue]の拡張メソッドです。
extension FormMediaValueExtensions on FormMediaValue {
  /// Convert to [ModelImageUri].
  ///
  /// If [path] is empty, null is returned.
  ///
  /// Returns an error if the original [FormMediaType] is not [FormMediaType.image].
  ///
  /// [ModelImageUri]に変換します。
  ///
  /// [path]が空の場合はnullを返します。
  ///
  /// 元の[FormMediaType]が[FormMediaType.image]でない場合はエラーを返します。
  ModelImageUri? toModelImageUri() {
    if (path.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(path!);
    if (uri == null) {
      return null;
    }
    if (type != FormMediaType.image) {
      throw Exception("The original FormMediaType is not FormMediaType.image");
    }
    return ModelImageUri(uri);
  }

  /// Convert to [ModelVideoUri].
  ///
  /// If [path] is empty, null is returned.
  ///
  /// Returns an error if the original [FormMediaType] is not [FormMediaType.video].
  ///
  /// [ModelVideoUri]に変換します。
  ///
  /// [path]が空の場合はnullを返します。
  ///
  /// 元の[FormMediaType]が[FormMediaType.video]でない場合はエラーを返します。
  ModelVideoUri? toModelVideoUri() {
    if (path.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(path!);
    if (uri == null) {
      return null;
    }
    if (type != FormMediaType.video) {
      throw Exception("The original FormMediaType is not FormMediaType.video");
    }
    return ModelVideoUri(uri);
  }
}
