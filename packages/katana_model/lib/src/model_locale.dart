part of katana_model;

/// Define a model [LocalizedValue] that stores locale and text pairs.
///
/// The base value is given as [value]. If not given, an empty [LocalizedValue] is used.
///
/// ロケールとテキストのペアを保存する[LocalizedValue]をモデルとして定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合は何も設定されていない[LocalizedValue]が利用されます。
@immutable
class ModelLocalizedValue extends ModelFieldValue<LocalizedValue> {
  /// Define a model [LocalizedValue] that stores locale and text pairs.
  ///
  /// The base value is given as [value]. If not given, an empty [LocalizedValue] is used.
  ///
  /// ロケールとテキストのペアを保存する[LocalizedValue]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合は何も設定されていない[LocalizedValue]が利用されます。
  const factory ModelLocalizedValue([LocalizedValue? value]) =
      _ModelLocalizedValue;

  /// Define a model [LocalizedValue] that stores locale and text pairs.
  ///
  /// The base value is given as [value]. If not given, an empty [LocalizedValue] is used.
  ///
  /// ロケールとテキストのペアを保存する[LocalizedValue]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合は何も設定されていない[LocalizedValue]が利用されます。
  const factory ModelLocalizedValue.fromMap(Map<Locale, String> map) =
      _ModelLocaleWithMap;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelLocalizedValue.fromServer([LocalizedValue? value]) =
      _ModelLocalizedValue.fromServer;

  /// Convert from [json] map to [ModelLocalizedValue].
  ///
  /// [json]のマップから[ModelLocalizedValue]に変換します。
  factory ModelLocalizedValue.fromJson(DynamicMap json) {
    return ModelLocalizedValue.fromServer(
      LocalizedValue.fromJson(json.getAsMap(kLocalizedKey)),
    );
  }

  const ModelLocalizedValue._([
    LocalizedValue? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Key to save translation data.
  ///
  /// 翻訳データを保存しておくキー。
  static const kLocalizedKey = "@localized";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  LocalizedValue get value => _value ?? const LocalizedValue();
  final LocalizedValue? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: (ModelLocalizedValue).toString(),
        kLocalizedKey: value.toJson(),
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;
}

@immutable
class _ModelLocaleWithMap extends _ModelLocalizedValue {
  const _ModelLocaleWithMap(this._map) : super();

  final Map<Locale, String> _map;

  @override
  LocalizedValue? get _value {
    return LocalizedValue(_map);
  }
}

@immutable
class _ModelLocalizedValue extends ModelLocalizedValue
    with ModelFieldValueAsMapMixin<LocalizedValue> {
  const _ModelLocalizedValue([
    LocalizedValue? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ]) : super._(value, source);
  const _ModelLocalizedValue.fromServer([LocalizedValue? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelLocalizedValue] as [ModelFieldValue].
///
/// [ModelLocalizedValue]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelLocalizedValueConverter
    extends ModelFieldValueConverter<ModelLocalizedValue> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelLocalizedValue] as [ModelFieldValue].
  ///
  /// [ModelLocalizedValue]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelLocalizedValueConverter();

  @override
  ModelLocalizedValue fromJson(Map<String, Object?> map) {
    return ModelLocalizedValue.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelLocalizedValue value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelLocalizedValue] available to [ModelQuery.filters].
///
/// [ModelLocalizedValue]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelLocalizedValueFilter
    extends ModelFieldValueFilter<ModelLocalizedValue> {
  /// Filter class to make [ModelLocalizedValue] available to [ModelQuery.filters].
  ///
  /// [ModelLocalizedValue]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelLocalizedValueFilter();

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(
            source, target, (source, target) => source.equalsTo(target));
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(
            source, target, (source, target) => !source.equalsTo(target));
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(
                  s, target, (source, target) => source.equalsTo(target)) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source.equalsTo(target)) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) => _hasMatch(
              source, t, (source, target) => source.equalsTo(target)));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) => _hasMatch(
              source, t, (source, target) => source.equalsTo(target)));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(DynamicMap source, DynamicMap target) filter,
  ) {
    if (source is ModelLocalizedValue && target is ModelLocalizedValue) {
      return filter(source.value.toJson(), target.value.toJson());
    } else if (source is ModelLocalizedValue && target is LocalizedValue) {
      return filter(source.value.toJson(), target.toJson());
    } else if (source is LocalizedValue && target is ModelLocalizedValue) {
      return filter(source.toJson(), target.value.toJson());
    } else if (source is ModelLocalizedValue && target is Map<Locale, String>) {
      return filter(source.value.toJson(), target.map((key, value) {
        return MapEntry(key.toString().replaceAll("-", "_"), value);
      }));
    } else if (source is ModelLocalizedValue && target is Map<String, String>) {
      return filter(source.value.toJson(), target);
    } else if (source is Map<Locale, String> && target is ModelLocalizedValue) {
      return filter(source.map((key, value) {
        return MapEntry(key.toString().replaceAll("-", "_"), value);
      }), target.value.toJson());
    } else if (source is Map<String, String> && target is ModelLocalizedValue) {
      return filter(source, target.value.toJson());
    } else if (source is ModelLocalizedValue &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == (ModelLocalizedValue).toString()) {
      return filter(source.value.toJson(),
          ModelLocalizedValue.fromJson(target).value.toJson());
    } else if (source is DynamicMap &&
        target is ModelLocalizedValue &&
        source.get(kTypeFieldKey, "") == (ModelLocalizedValue).toString()) {
      return filter(ModelLocalizedValue.fromJson(source).value.toJson(),
          target.value.toJson());
    } else if (source is LocalizedValue &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == (ModelLocalizedValue).toString()) {
      return filter(
          source.toJson(), ModelLocalizedValue.fromJson(target).value.toJson());
    } else if (source is DynamicMap &&
        target is LocalizedValue &&
        source.get(kTypeFieldKey, "") == (ModelLocalizedValue).toString()) {
      return filter(
          ModelLocalizedValue.fromJson(source).value.toJson(), target.toJson());
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == (ModelLocalizedValue).toString() &&
        target.get(kTypeFieldKey, "") == (ModelLocalizedValue).toString()) {
      return filter(
        ModelLocalizedValue.fromJson(source).value.toJson(),
        ModelLocalizedValue.fromJson(target).value.toJson(),
      );
    }
    return null;
  }
}

/// Class for storing translation data.
///
/// It consists of a pair of [Locale] and its corresponding [String] translation.
///
/// [LocalizedValue.fromJson] can be used to convert [String] and [String] pairs from Json.
/// In that case, the key must be a string delimited by `_`, such as `ja_JP`.
///
/// Obtains the translation of [Locale] specified in [value].
///
/// 翻訳データを保存するためのクラス。
///
/// [Locale]とその翻訳に対応する[String]のペアで構成されます。
///
/// [LocalizedValue.fromJson]を利用することで[String]と[String]のペアのJsonからの変換が可能です。
/// その場合、キーは`ja_JP`のように`_`で区切られた文字列である必要があります。
///
/// [value]で指定した[Locale]の翻訳を取得します。
@immutable
class LocalizedValue
    with MapMixin<Locale, String>
    implements Map<Locale, String> {
  /// Class for storing translation data.
  ///
  /// It consists of a pair of [Locale] and its corresponding [String] translation.
  ///
  /// [LocalizedValue.fromJson] can be used to convert [String] and [String] pairs from Json.
  /// In that case, the key must be a string delimited by `_`, such as `ja_JP`.
  ///
  /// Obtains the translation of [Locale] specified in [value].
  ///
  /// 翻訳データを保存するためのクラス。
  ///
  /// [Locale]とその翻訳に対応する[String]のペアで構成されます。
  ///
  /// [LocalizedValue.fromJson]を利用することで[String]と[String]のペアのJsonからの変換が可能です。
  /// その場合、キーは`ja_JP`のように`_`で区切られた文字列である必要があります。
  ///
  /// [value]で指定した[Locale]の翻訳を取得します。
  const LocalizedValue([Map<Locale, String> defaultValue = const {}])
      : _map = defaultValue;
  final Map<Locale, String> _map;

  /// Class for storing translation data.
  ///
  /// It consists of a pair of [Locale] and its corresponding [String] translation.
  ///
  /// [LocalizedValue.fromJson] can be used to convert [String] and [String] pairs from Json.
  /// In that case, the key must be a string delimited by `_`, such as `ja_JP`.
  ///
  /// Obtains the translation of [Locale] specified in [value].
  ///
  /// 翻訳データを保存するためのクラス。
  ///
  /// [Locale]とその翻訳に対応する[String]のペアで構成されます。
  ///
  /// [LocalizedValue.fromJson]を利用することで[String]と[String]のペアのJsonからの変換が可能です。
  /// その場合、キーは`ja_JP`のように`_`で区切られた文字列である必要があります。
  ///
  /// [value]で指定した[Locale]の翻訳を取得します。
  factory LocalizedValue.fromJson(DynamicMap json) {
    return LocalizedValue(
      json.map((key, value) {
        final keys = key.replaceAll("-", "_").split("_");
        return MapEntry(
          Locale(
            keys.first,
            keys.length > 1 ? keys.last : null,
          ),
          value.toString(),
        );
      }),
    );
  }

  /// Obtains the translation of [Locale] specified by [key].
  ///
  /// First, it tries to get the value by [key], then tries to get the value by [defaultLocale], and returns [defaultValue] if it still cannot get the value.
  ///
  /// [key]で指定した[Locale]の翻訳を取得します。
  ///
  /// まず[key]による値の取得を試みたあと、[defaultLocale]での取得を試みて、それでも取得できない場合は[defaultValue]を返します。
  String value(
    Locale key, {
    String defaultValue = "",
    Locale defaultLocale = const Locale("en", "US"),
  }) {
    return _map[key] ?? _map[defaultLocale] ?? defaultValue;
  }

  @override
  String? operator [](Object? key) {
    if (key == null) {
      return null;
    }
    return _map[key];
  }

  @override
  void operator []=(Locale key, String value) {
    _map[key] = value;
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  Iterable<Locale> get keys => _map.keys;

  @override
  String? remove(Object? key) {
    if (key == null) {
      return null;
    }
    return _map.remove(key);
  }

  @override
  String toString() {
    return _map.toString();
  }

  DynamicMap toJson() {
    return _map.map((key, value) {
      return MapEntry(key.toString().replaceAll("-", "_"), value);
    });
  }

  @override
  int get hashCode {
    return _map.entries
        .fold<int>(0, (p, e) => p ^ e.key.hashCode ^ e.value.hashCode);
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Define a model [Locale] that stores the locale.
///
/// The base value is given as [value]. If not given, it is set as `en_US`.
///
/// ロケールを保存する[Locale]をモデルとして定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合`en_US`としてセットされます。
@immutable
class ModelLocale extends ModelFieldValue<Locale> {
  /// Define a model [Locale] that stores the locale.
  ///
  /// The base value is given as [value]. If not given, it is set as `en_US`.
  ///
  /// ロケールを保存する[Locale]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合`en_US`としてセットされます。
  const factory ModelLocale([Locale? value]) = _ModelLocale;

  /// Define a model [Locale] that stores the locale.
  ///
  /// The base value is given as [value]. If not given, it is set as `en_US`.
  ///
  /// ロケールを保存する[Locale]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合`en_US`としてセットされます。
  const factory ModelLocale.fromCode(
    String language, [
    String? country,
  ]) = _ModelLocaleWithCode;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelLocale.fromServer([Locale? value]) =
      _ModelLocale.fromServer;

  /// Convert from [json] map to [ModelLocale].
  ///
  /// [json]のマップから[ModelLocale]に変換します。
  factory ModelLocale.fromJson(DynamicMap json) {
    return ModelLocale.fromServer(
      Locale(
        json.get(kLaunguageKey, "en"),
        json.get<String?>(kCountryKey, null),
      ),
    );
  }

  const ModelLocale._([
    Locale? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Key to save the language code.
  ///
  /// 言語コードを保存しておくキー。
  static const kLaunguageKey = "@language";

  /// Key to save country code.
  ///
  /// 国コードを保存しておくキー。
  static const kCountryKey = "@country";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  Locale get value => _value ?? const Locale("en");
  final Locale? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: (ModelLocale).toString(),
        kLaunguageKey: value.languageCode,
        kCountryKey: value.countryCode,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;
}

@immutable
class _ModelLocaleWithCode extends _ModelLocale {
  const _ModelLocaleWithCode(
    this.language, [
    this.country,
  ]) : super();

  final String language;
  final String? country;

  @override
  Locale? get _value {
    return Locale(
      language,
      country,
    );
  }
}

@immutable
class _ModelLocale extends ModelLocale with ModelFieldValueAsMapMixin<Locale> {
  const _ModelLocale([
    Locale? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ]) : super._(value, source);
  const _ModelLocale.fromServer([Locale? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelLocale] as [ModelFieldValue].
///
/// [ModelLocale]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelLocaleConverter extends ModelFieldValueConverter<ModelLocale> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelLocale] as [ModelFieldValue].
  ///
  /// [ModelLocale]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelLocaleConverter();

  @override
  ModelLocale fromJson(Map<String, Object?> map) {
    return ModelLocale.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelLocale value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelLocale] available to [ModelQuery.filters].
///
/// [ModelLocale]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelLocaleFilter extends ModelFieldValueFilter<ModelLocale> {
  /// Filter class to make [ModelLocale] available to [ModelQuery.filters].
  ///
  /// [ModelLocale]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelLocaleFilter();

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.compareTo(b));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.arrayContains:
        if (source is List) {
          if (source.any((s) =>
              _hasMatch(s, target, (source, target) => source == target) ??
              false)) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.arrayContainsAny:
        if (source is List && target is List && target.isNotEmpty) {
          if (source.any((s) => target.any((t) =>
              _hasMatch(s, t, (source, target) => source == target) ??
              false))) {
            return true;
          }
        }
        break;
      case ModelQueryFilterType.whereIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return matches.any((element) => element);
          }
        }
        break;
      case ModelQueryFilterType.whereNotIn:
        if (target is List && target.isNotEmpty) {
          final matches = target.mapAndRemoveEmpty((t) =>
              _hasMatch(source, t, (source, target) => source == target));
          if (matches.isNotEmpty) {
            return !matches.any((element) => element);
          }
        }
        break;
      default:
        return null;
    }
    return null;
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(String source, String target) filter,
  ) {
    if (source is ModelLocale && target is ModelLocale) {
      return filter(source.value.toString(), target.value.toString());
    } else if (source is ModelLocale && target is Locale) {
      return filter(source.value.toString(), target.toString());
    } else if (source is Locale && target is ModelLocale) {
      return filter(source.toString(), target.value.toString());
    } else if (source is ModelLocale && target is String) {
      return filter(source.value.toString(), target.replaceAll("-", "_"));
    } else if (source is String && target is ModelLocale) {
      return filter(source.replaceAll("-", "_"), target.value.toString());
    } else if (source is ModelLocale &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == (ModelLocale).toString()) {
      return filter(source.value.toString(),
          ModelLocale.fromJson(target).value.toString());
    } else if (source is DynamicMap &&
        target is ModelLocale &&
        source.get(kTypeFieldKey, "") == (ModelLocale).toString()) {
      return filter(ModelLocale.fromJson(source).value.toString(),
          target.value.toString());
    } else if (source is Locale &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == (ModelLocale).toString()) {
      return filter(
          source.toString(), ModelLocale.fromJson(target).value.toString());
    } else if (source is DynamicMap &&
        target is Locale &&
        source.get(kTypeFieldKey, "") == (ModelLocale).toString()) {
      return filter(
          ModelLocale.fromJson(source).value.toString(), target.toString());
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == (ModelLocale).toString() &&
        target.get(kTypeFieldKey, "") == (ModelLocale).toString()) {
      return filter(
        ModelLocale.fromJson(source).value.toString(),
        ModelLocale.fromJson(target).value.toString(),
      );
    }
    return null;
  }
}
