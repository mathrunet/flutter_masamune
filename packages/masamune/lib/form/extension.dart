part of masamune;

/// Extension methods for [FormMediaValue].
///
/// [FormMediaValue]の拡張メソッドです。
extension FormMediaValueExtensions on FormMediaValue {
  /// Get a [ImageProvider].
  ///
  /// If [defaultAssetURI] is specified, use [defaultAssetURI] if [ImageProvider] cannot be obtained.
  ///
  /// If [type] is not [FormMediaType.image], use [defaultAssetURI].
  ///
  /// [ImageProvider]を取得します。
  ///
  /// [defaultAssetURI]が指定されている場合、[ImageProvider]が取得できない場合は[defaultAssetURI]を使用します。
  ///
  /// また[type]が[FormMediaType.image]でない場合は[defaultAssetURI]を使用します。
  ImageProvider toImageProvider([String defaultAssetURI = "assets/image.png"]) {
    if (type != FormMediaType.image) {
      return Asset.image(defaultAssetURI);
    }
    return Asset.image(uri.toString(), defaultAssetURI);
  }

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
    if (uri.isEmpty) {
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
    if (uri.isEmpty) {
      return null;
    }
    if (type != FormMediaType.video) {
      throw Exception("The original FormMediaType is not FormMediaType.video");
    }
    return ModelVideoUri(uri);
  }
}

/// Extension methods for [ControllerQueryBase<FormController>].
///
/// [ControllerQueryBase<FormController>]の拡張メソッドです。
extension FormControllerQueryBaseExtensions<TModel>
    on ControllerQueryBase<FormController<TModel>> {
  /// Get [FormController<TModel>] while monitoring it with the widget associated with [ref] in the same way as `ref.page.controller`.
  ///
  /// `ref.page.controller`と同じように[ref]に関連するウィジェットで監視を行いつつ[FormController<TModel>]を取得します。
  FormController<TModel> watch(RefHasPage ref) {
    return ref.page.controller(this);
  }
}
