part of '/masamune.dart';

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
    return Asset.image(value.toString(), defaultAssetURI: defaultAssetURI);
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

/// This is an extension method of [ModelQueryBase].
///
/// [ModelQueryBase]の拡張メソッドです。
extension ModelQueryBaseExtensions<TModel extends Listenable>
    on ModelQueryBase<TModel> {
  /// Get [TModel] while monitoring it with the widget associated with [ref] in the same way as `ref.model`.
  ///
  /// `ref.model`と同じように[ref]に関連するウィジェットで監視を行いつつ[TModel]を取得します。
  TModel watch(RefHasApp ref) {
    return ref.model(this);
  }

  /// Get [TModel] stored in [ref] in the same way as `ref.model`.
  ///
  /// `ref.model`と同じように[ref]に格納されている[TModel]を取得します。
  TModel read(AppRef ref) {
    return ref.model(this);
  }
}
