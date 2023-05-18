part of katana_form;

// TODO: MapMixinが使えるようになったら置き換え
class _FormMediaValue extends FormMediaValue with _MapMixin<String, dynamic> {
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

  @override
  Iterable get values {
    final map = toJson();
    return map.values;
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

// TODO: MapMixinが使えるようになったら削除
mixin _MapMixin<K, V> implements Map<K, V> {
  @override
  Iterable<K> get keys;
  @override
  V? operator [](Object? key);
  @override
  operator []=(K key, V value);
  @override
  V? remove(Object? key);
  @override
  void clear();

  @override
  Map<RK, RV> cast<RK, RV>() => Map.castFrom<K, V, RK, RV>(this);
  @override
  void forEach(void Function(K key, V value) action) {
    for (K key in keys) {
      action(key, this[key] as V);
    }
  }

  @override
  void addAll(Map<K, V> other) {
    other.forEach((K key, V value) {
      this[key] = value;
    });
  }

  @override
  bool containsValue(Object? value) {
    for (K key in keys) {
      if (this[key] == value) return true;
    }
    return false;
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    if (containsKey(key)) {
      return this[key] as V;
    }
    return this[key] = ifAbsent();
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    if (this.containsKey(key)) {
      return this[key] = update(this[key] as V);
    }
    if (ifAbsent != null) {
      return this[key] = ifAbsent();
    }
    throw ArgumentError.value(key, "key", "Key not in map.");
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    for (var key in this.keys) {
      this[key] = update(key, this[key] as V);
    }
  }

  @override
  Iterable<MapEntry<K, V>> get entries {
    return keys.map((K key) => MapEntry<K, V>(key, this[key] as V));
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) transform) {
    var result = <K2, V2>{};
    for (var key in this.keys) {
      var entry = transform(key, this[key] as V);
      result[entry.key] = entry.value;
    }
    return result;
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    for (var entry in newEntries) {
      this[entry.key] = entry.value;
    }
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    var keysToRemove = <K>[];
    for (var key in keys) {
      if (test(key, this[key] as V)) keysToRemove.add(key);
    }
    for (var key in keysToRemove) {
      this.remove(key);
    }
  }

  @override
  bool containsKey(Object? key) => keys.contains(key);
  @override
  int get length => keys.length;
  @override
  bool get isEmpty => keys.isEmpty;
  @override
  bool get isNotEmpty => keys.isNotEmpty;
}
