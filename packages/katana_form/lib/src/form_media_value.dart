part of katana_form;

class _FormMediaValue extends FormMediaValue with MapMixin<String, dynamic> {
  const _FormMediaValue({
    FormMediaType type = FormMediaType.image,
    String? path,
  }) : super._(type: type, path: path);

  @override
  dynamic operator [](Object? key) {
    final map = toJson();
    return map[key];
  }

  @override
  void operator []=(String key, value) {
    throw UnsupportedError("Writing data is not supported.");
  }

  @override
  void clear() {
    throw UnsupportedError("Writing data is not supported.");
  }

  @override
  Iterable<String> get keys {
    final map = toJson();
    return map.keys;
  }

  @override
  dynamic remove(Object? key) {
    throw UnsupportedError("Writing data is not supported.");
  }
}

/// Class for values when handling media in forms.
///
/// Specify the media type in [type] with [FormMediaType]. Specify the actual path in [path].
///
/// Since mutual conversion to Json is possible with [FormMediaValue.fromJson] or [toJson], the data can be saved as is.
///
/// フォームでメディアを取り扱うときの値用のクラス。
///
/// [type]にメディアのタイプを[FormMediaType]で指定します。[path]に実際のパスを指定します。
///
/// [FormMediaValue.fromJson]や[toJson]でJsonに相互変換が可能なので、このままデータとして保存することができます。
@immutable
class FormMediaValue {
  /// Class for values when handling media in forms.
  ///
  /// Specify the media type in [type] with [FormMediaType]. Specify the actual path in [path].
  ///
  /// Since mutual conversion to Json is possible with [FormMediaValue.fromJson] or [toJson], the data can be saved as is.
  ///
  /// フォームでメディアを取り扱うときの値用のクラス。
  ///
  /// [type]にメディアのタイプを[FormMediaType]で指定します。[path]に実際のパスを指定します。
  ///
  /// [FormMediaValue.fromJson]や[toJson]でJsonに相互変換が可能なので、このままデータとして保存することができます。
  factory FormMediaValue({
    FormMediaType type = FormMediaType.image,
    String? path,
  }) {
    return _FormMediaValue(
      type: type,
      path: path,
    );
  }

  const FormMediaValue._({
    this.type = FormMediaType.image,
    this.path,
  });

  /// [FormMediaValue] from the Json map [map].
  ///
  /// Jsonマップ[map]から[FormMediaValue]を作成します。
  factory FormMediaValue.fromJson(Map<String, Object?> map) {
    final type = map.get(_kTypeKey, "");
    return FormMediaValue(
      type: FormMediaType.values.firstWhereOrNull((e) => e.name == type) ??
          FormMediaType.image,
      path: map.get(_kPathKey, ""),
    );
  }

  /// Specify the media type with [FormMediaType].
  ///
  /// メディアのタイプを[FormMediaType]で指定します。
  final FormMediaType type;

  /// Actual path.
  ///
  /// 実際のパス。
  final String? path;

  /// Convert [FormMediaValue] to a Json map.
  ///
  /// [FormMediaValue]をJsonマップに変換します。
  Map<String, Object?> toJson() {
    return {
      _kTypeKey: type.name,
      if (path.isNotEmpty) _kPathKey: path,
    };
  }

  /// Create another [FormMediaValue] by copying the value.
  ///
  /// Specify the media type in [type] with [FormMediaType]. Specify the actual path in [path].
  ///
  /// 値をコピーして別の[FormMediaValue]を作成します。
  ///
  /// [type]にメディアのタイプを[FormMediaType]で指定します。[path]に実際のパスを指定します。
  FormMediaValue copyWith({
    FormMediaType? type,
    String? path,
  }) {
    return FormMediaValue(
      type: type ?? this.type,
      path: path ?? this.path,
    );
  }

  @override
  int get hashCode => type.hashCode ^ path.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
