part of '/katana_model.dart';

/// Define a model [LocalizedValue] that stores locale and text pairs.
///
/// The base value is given as [value]. If not given, an empty [LocalizedValue] is used.
///
/// ロケールとテキストのペアを保存する[LocalizedValue]をモデルとして定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合は何も設定されていない[LocalizedValue]が利用されます。
@immutable
class ModelLocalizedValue extends ModelFieldValue<LocalizedValue<String>>
    implements Comparable<ModelLocalizedValue> {
  /// Define a model [LocalizedValue] that stores locale and text pairs.
  ///
  /// The base value is given as [value]. If not given, an empty [LocalizedValue] is used.
  ///
  /// ロケールとテキストのペアを保存する[LocalizedValue]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合は何も設定されていない[LocalizedValue]が利用されます。
  const factory ModelLocalizedValue([LocalizedValue<String>? value]) =
      _ModelLocalizedValue;

  /// Define a model [LocalizedValue] that stores locale and text pairs.
  ///
  /// The base value is given as [value]. If not given, an empty [LocalizedValue] is used.
  ///
  /// ロケールとテキストのペアを保存する[LocalizedValue]をモデルとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合は何も設定されていない[LocalizedValue]が利用されます。
  const factory ModelLocalizedValue.fromList(
      List<LocalizedLocaleValue<String>> list) = _ModelLocalizedValueWithList;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelLocalizedValue.fromServer(
      [LocalizedValue<String>? value]) = _ModelLocalizedValue.fromServer;

  /// Convert from [json] map to [ModelLocalizedValue].
  ///
  /// [json]のマップから[ModelLocalizedValue]に変換します。
  factory ModelLocalizedValue.fromJson(DynamicMap json) {
    return ModelLocalizedValue.fromServer(
      LocalizedValue.fromJson(json.getAsMap(kLocalizedKey)),
    );
  }

  const ModelLocalizedValue._([
    LocalizedValue<String>? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelLocalizedValue";

  /// Key to save translation data.
  ///
  /// 翻訳データを保存しておくキー。
  static const kLocalizedKey = "@localized";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  LocalizedValue<String> get value => _value ?? const LocalizedValue<String>();
  final LocalizedValue<String>? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelLocalizedValue.typeString,
        kLocalizedKey: value.toJson(),
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelLocalizedValue other) {
    return value.compareTo(other.value);
  }
}

@immutable
class _ModelLocalizedValueWithList extends _ModelLocalizedValue {
  const _ModelLocalizedValueWithList(this._list) : super();

  final List<LocalizedLocaleValue<String>> _list;

  @override
  LocalizedValue<String>? get _value {
    return LocalizedValue<String>(_list);
  }
}

@immutable
class _ModelLocalizedValue extends ModelLocalizedValue
    with ModelFieldValueAsMapMixin<LocalizedValue<String>> {
  const _ModelLocalizedValue([
    super.value,
  ]) : super._();
  const _ModelLocalizedValue.fromServer([LocalizedValue<String>? value])
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
  String get type => ModelLocalizedValue.typeString;

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
  String get type => ModelLocalizedValue.typeString;

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
          source,
          target,
          (source, target) => target.every((e) => source.contains(e)),
        );
      case ModelQueryFilterType.notEqualTo:
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
      case ModelQueryFilterType.arrayContains:
        return _hasMatch(
          source,
          target,
          (source, target) => target.any((e) => source.contains(e)),
        );
      case ModelQueryFilterType.arrayContainsAny:
        if (target is List && target.isNotEmpty) {
          if (target.any((t) =>
              _hasMatch(
                source,
                t,
                (source, target) => target.any((e) => source.contains(e)),
              ) ??
              false)) {
            return true;
          }
        }
        return null;
      case ModelQueryFilterType.whereIn:
      case ModelQueryFilterType.whereNotIn:
        return null;
      default:
        return null;
    }
  }

  T? _hasMatch<T>(
    dynamic source,
    dynamic target,
    T Function(List<String> source, List<String> target) filter,
  ) {
    if (source is ModelLocalizedValue && target is ModelLocalizedValue) {
      return filter(source.value.map((e) => "${e.locale}:${e.value}").toList(),
          target.value.map((e) => "${e.locale}:${e.value}").toList());
    } else if (source is ModelLocalizedValue &&
        target is LocalizedValue<String>) {
      return filter(source.value.map((e) => "${e.locale}:${e.value}").toList(),
          target.map((e) => "${e.locale}:${e.value}").toList());
    } else if (source is LocalizedValue<String> &&
        target is ModelLocalizedValue) {
      return filter(source.map((e) => "${e.locale}:${e.value}").toList(),
          target.value.map((e) => "${e.locale}:${e.value}").toList());
    } else if (source is ModelLocalizedValue &&
        target is List<LocalizedLocaleValue<String>>) {
      return filter(
        source.value.map((e) => "${e.locale}:${e.value}").toList(),
        target.map((e) => "${e.locale}:${e.value}").toList(),
      );
    } else if (source is ModelLocalizedValue && target is Map<String, String>) {
      return filter(
        source.value.map((e) => "${e.locale}:${e.value}").toList(),
        target.toList((k, v) => "$k:$v").toList(),
      );
    } else if (source is List<LocalizedLocaleValue<String>> &&
        target is ModelLocalizedValue) {
      return filter(
        source.map((e) => "${e.locale}:${e.value}").toList(),
        target.value.map((e) => "${e.locale}:${e.value}").toList(),
      );
    } else if (source is Map<String, String> && target is ModelLocalizedValue) {
      return filter(
        source.toList((k, v) => "$k:$v").toList(),
        target.value.map((e) => "${e.locale}:${e.value}").toList(),
      );
    } else if (source is ModelLocalizedValue &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelLocalizedValue.typeString) {
      return filter(
          source.value.map((e) => "${e.locale}:${e.value}").toList(),
          ModelLocalizedValue.fromJson(target)
              .value
              .map((e) => "${e.locale}:${e.value}")
              .toList());
    } else if (source is DynamicMap &&
        target is ModelLocalizedValue &&
        source.get(kTypeFieldKey, "") == ModelLocalizedValue.typeString) {
      return filter(
        ModelLocalizedValue.fromJson(source)
            .value
            .map((e) => "${e.locale}:${e.value}")
            .toList(),
        target.value.map((e) => "${e.locale}:${e.value}").toList(),
      );
    } else if (source is LocalizedValue<String> &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelLocalizedValue.typeString) {
      return filter(
        source.map((e) => "${e.locale}:${e.value}").toList(),
        ModelLocalizedValue.fromJson(target)
            .value
            .map((e) => "${e.locale}:${e.value}")
            .toList(),
      );
    } else if (source is DynamicMap &&
        target is LocalizedValue<String> &&
        source.get(kTypeFieldKey, "") == ModelLocalizedValue.typeString) {
      return filter(
        ModelLocalizedValue.fromJson(source)
            .value
            .map((e) => "${e.locale}:${e.value}")
            .toList(),
        target.map((e) => "${e.locale}:${e.value}").toList(),
      );
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelLocalizedValue.typeString &&
        target.get(kTypeFieldKey, "") == ModelLocalizedValue.typeString) {
      return filter(
        ModelLocalizedValue.fromJson(source)
            .value
            .map((e) => "${e.locale}:${e.value}")
            .toList(),
        ModelLocalizedValue.fromJson(target)
            .value
            .map((e) => "${e.locale}:${e.value}")
            .toList(),
      );
    }
    return null;
  }
}

/// Class for storing translation data.
///
/// It consists of a pair of [Locale] and the corresponding [T] for the translation.
///
/// [LocalizedValue.fromJson] can be used to convert [String] and [T] pairs from Json.
/// In that case, the key must be a string delimited by `_`, such as `ja_JP`.
///
/// Obtains the translation of [Locale] specified in [value].
///
/// 翻訳データを保存するためのクラス。
///
/// [Locale]とその翻訳に対応する[T]のペアで構成されます。
///
/// [LocalizedValue.fromJson]を利用することで[String]と[T]のペアのJsonからの変換が可能です。
/// その場合、キーは`ja_JP`のように`_`で区切られた文字列である必要があります。
///
/// [value]で指定した[Locale]の翻訳を取得します。
@immutable
class LocalizedValue<T>
    with IterableMixin<LocalizedLocaleValue<T>>
    implements Iterable<LocalizedLocaleValue<T>>, Comparable<LocalizedValue> {
  /// Class for storing translation data.
  ///
  /// It consists of a pair of [Locale] and the corresponding [T] for the translation.
  ///
  /// [LocalizedValue.fromJson] can be used to convert [String] and [T] pairs from Json.
  /// In that case, the key must be a string delimited by `_`, such as `ja_JP`.
  ///
  /// Obtains the translation of [Locale] specified in [value].
  ///
  /// 翻訳データを保存するためのクラス。
  ///
  /// [Locale]とその翻訳に対応する[T]のペアで構成されます。
  ///
  /// [LocalizedValue.fromJson]を利用することで[String]と[T]のペアのJsonからの変換が可能です。
  /// その場合、キーは`ja_JP`のように`_`で区切られた文字列である必要があります。
  ///
  /// [value]で指定した[Locale]の翻訳を取得します。
  const LocalizedValue(
      [Iterable<LocalizedLocaleValue<T>> defaultValue = const []])
      : _list = defaultValue;
  final Iterable<LocalizedLocaleValue<T>> _list;

  /// Class for storing translation data.
  ///
  /// It consists of a pair of [Locale] and the corresponding [T] for the translation.
  ///
  /// [LocalizedValue.fromJson] can be used to convert [String] and [T] pairs from Json.
  /// In that case, the key must be a string delimited by `_`, such as `ja_JP`.
  ///
  /// Obtains the translation of [Locale] specified in [value].
  ///
  /// 翻訳データを保存するためのクラス。
  ///
  /// [Locale]とその翻訳に対応する[T]のペアで構成されます。
  ///
  /// [LocalizedValue.fromJson]を利用することで[String]と[T]のペアのJsonからの変換が可能です。
  /// その場合、キーは`ja_JP`のように`_`で区切られた文字列である必要があります。
  ///
  /// [value]で指定した[Locale]の翻訳を取得します。
  factory LocalizedValue.fromJson(DynamicMap json) {
    return LocalizedValue(
      json.toList((key, value) {
        final keys = key.replaceAll("-", "_").split("_");
        return LocalizedLocaleValue(
          Locale(
            keys.first,
            keys.length > 1 ? keys.last : null,
          ),
          value as T,
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
  T? value(
    Locale key, {
    T? defaultValue,
    Locale defaultLocale = const Locale("en", "US"),
  }) {
    return _list.firstWhereOrNull((e) => e.locale == key)?.value ??
        _list.firstWhereOrNull((e) => e.locale == defaultLocale)?.value ??
        _list
            .firstWhereOrNull((e) => e.locale.languageCode == key.languageCode)
            ?.value ??
        _list
            .firstWhereOrNull(
                (e) => e.locale.languageCode == defaultLocale.languageCode)
            ?.value ??
        defaultValue;
  }

  /// Convert [LocalizedValue] to [DynamicMap].
  ///
  /// [Locale] are all converted to strings such as "en_US".
  ///
  /// [LocalizedValue]を[DynamicMap]に変換します。
  ///
  /// [Locale]はすべて"en_US"のような文字列に変換されます。
  DynamicMap toJson() {
    return _list.toMap((entry) {
      return MapEntry(
        entry.locale.toString().replaceAll("-", "_"),
        entry.value,
      );
    });
  }

  @override
  Iterator<LocalizedLocaleValue<T>> get iterator => _list.iterator;

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  @override
  int get hashCode {
    return _list.fold<int>(
        0, (p, e) => p ^ e.locale.hashCode ^ e.value.hashCode);
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int compareTo(LocalizedValue other) {
    return toString().compareTo(other.toString());
  }
}

/// Class for restricting the types of values that can be stored in [LocalizedValue].
///
/// The language information is stored in [locale] and the actual value in [value].
///
/// [LocalizedValue]に格納できる値の型を制限するためのクラス。
///
/// [locale]に言語情報、[value]に実際の値を格納します。
@immutable
class LocalizedLocaleValue<T> {
  const LocalizedLocaleValue(this.locale, this.value);

  /// Language Information.
  ///
  /// 言語情報。
  final Locale locale;

  /// Actual value.
  ///
  /// 実際の値。
  final T value;

  /// Copy [value] and generate a new one.
  ///
  /// [value]をコピーして新しく生成します。
  LocalizedLocaleValue<T> copyWith({
    T? value,
  }) {
    return LocalizedLocaleValue<T>(
      locale,
      value ?? this.value,
    );
  }

  @override
  String toString() {
    return "$locale:$value";
  }

  @override
  int get hashCode => locale.hashCode ^ value.hashCode;

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
class ModelLocale extends ModelFieldValue<Locale>
    implements Comparable<ModelLocale> {
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

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelLocale";

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
        kTypeFieldKey: ModelLocale.typeString,
        kLaunguageKey: value.languageCode,
        kCountryKey: value.countryCode,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(ModelLocale other) {
    return value.toString().compareTo(other.value.toString());
  }
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
    super.value,
  ]) : super._();
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
  String get type => ModelLocale.typeString;

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
  String get type => ModelLocale.typeString;

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
        target.get(kTypeFieldKey, "") == ModelLocale.typeString) {
      return filter(source.value.toString(),
          ModelLocale.fromJson(target).value.toString());
    } else if (source is DynamicMap &&
        target is ModelLocale &&
        source.get(kTypeFieldKey, "") == ModelLocale.typeString) {
      return filter(ModelLocale.fromJson(source).value.toString(),
          target.value.toString());
    } else if (source is Locale &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelLocale.typeString) {
      return filter(
          source.toString(), ModelLocale.fromJson(target).value.toString());
    } else if (source is DynamicMap &&
        target is Locale &&
        source.get(kTypeFieldKey, "") == ModelLocale.typeString) {
      return filter(
          ModelLocale.fromJson(source).value.toString(), target.toString());
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelLocale.typeString &&
        target.get(kTypeFieldKey, "") == ModelLocale.typeString) {
      return filter(
        ModelLocale.fromJson(source).value.toString(),
        ModelLocale.fromJson(target).value.toString(),
      );
    }
    return null;
  }
}
