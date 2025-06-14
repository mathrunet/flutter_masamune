part of "/katana_model.dart";

/// Use this when registering special classes in [ModelFieldValue].
///
/// Create a new class that inherits from this abstract class and register it with [ModelFieldValue.registerConverter] when the application starts.
///
/// [ModelFieldValue]に特殊なクラスを登録する場合に利用します。
///
/// この抽象クラスを継承して新しいクラスを作り、アプリ起動時に[ModelFieldValue.registerConverter]に登録を行ってください。
@immutable
abstract class ModelFieldValueConverter<T extends ModelFieldValue> {
  /// Use this when registering special classes in [ModelFieldValue].
  ///
  /// Create a new class that inherits from this abstract class and register it with [ModelFieldValue.registerConverter] when the application starts.
  ///
  /// [ModelFieldValue]に特殊なクラスを登録する場合に利用します。
  ///
  /// この抽象クラスを継承して新しいクラスを作り、アプリ起動時に[ModelFieldValue.registerConverter]に登録を行ってください。
  const ModelFieldValueConverter();

  /// Type of class being handled.
  ///
  /// 扱うクラスのタイプ。
  String get type;

  /// Returns `true` if the given [value] type matches [type].
  ///
  /// 与えられた[value]のタイプが[type]と一致する場合は`true`を返します。
  bool check(Object? value) => value is T;

  /// Converts [map] decoded from Json to [T].
  ///
  /// Jsonからデコードされた[map]を[T]に変換します。
  T fromJson(Map<String, Object?> map);

  /// Convert [T] values to [Map] that can be encoded in Json.
  ///
  /// [T]の値をJsonでエンコードできる[Map]に変換します。
  Map<String, Object?> toJson(T value);
}

/// Adapter class for determining the behavior of [ModelFieldValue] in [ModelQuery.filters].
///
/// Create a new class that inherits from this abstract class and register it with [ModelFieldValue.registerFilter] when the application starts.
///
/// [ModelQuery.filters]での[ModelFieldValue]の振る舞いを決めるためのアダプタークラス。
///
/// この抽象クラスを継承して新しいクラスを作り、アプリ起動時に[ModelFieldValue.registerFilter]に登録を行ってください。
@immutable
abstract class ModelFieldValueFilter<T extends ModelFieldValue> {
  /// Adapter class for determining the behavior of [ModelFieldValue] in [ModelQuery.filters].
  ///
  /// Create a new class that inherits from this abstract class and register it with [ModelFieldValue.registerFilter] when the application starts.
  ///
  /// [ModelQuery.filters]での[ModelFieldValue]の振る舞いを決めるためのアダプタークラス。
  ///
  /// この抽象クラスを継承して新しいクラスを作り、アプリ起動時に[ModelFieldValue.registerFilter]に登録を行ってください。
  const ModelFieldValueFilter();

  /// Type of class being handled.
  ///
  /// 扱うクラスのタイプ。
  String get type;

  /// Comparison operator for sorting.
  ///
  /// Compares [a] and [b] and returns a positive value if [a] is greater, 0 if [a] and [b] are equal, or negative if [a] is less.
  ///
  /// Returns [Null] if comparison is not possible due to type difference, etc.
  ///
  /// ソートを行うための比較演算子。
  ///
  /// [a]と[b]を比較し、[a]が大きい場合は正の値、[a]と[b]が等しい場合は0、[a]が小さい場合は負の値を返します。
  ///
  /// 型が違う等で比較不可能の場合は[Null]を返します。
  int? compare(dynamic a, dynamic b);

  /// Returns whether or not [source] matches according to the contents of [filter].
  ///
  /// Returns `true` if it matches, `false` if it does not.
  ///
  /// Returns [Null] if comparison is not possible due to type difference, etc.
  ///
  /// [filter]の内容に応じて、[source]がマッチするかどうかを返します。
  ///
  /// マッチする場合は`true`、しない場合は`false`を返します。
  ///
  /// 型が違う等で比較不可能の場合は[Null]を返します。
  bool? hasMatch(ModelQueryFilter filter, dynamic source);
}

/// Class for defining special field values.
///
/// The [value] of type [T] is the actual value.
///
/// 特殊なフィールド値を定義するためのクラス。
///
/// [T]型の[value]が実際の値となります。
abstract class ModelFieldValue<T> {
  /// Class for defining special field values.
  ///
  /// The [value] of type [T] is the actual value.
  ///
  /// [ModelFieldValue.fromMap] executes the process of converting the data read from the server and [ModelFieldValue.toMap] executes the process of converting the data to be saved to the server.
  ///
  /// 特殊なフィールド値を定義するためのクラス。
  ///
  /// [T]型の[value]が実際の値となります。
  ///
  /// [ModelFieldValue.fromMap]でサーバーから読み取られたデータを変換する処理を実行し、[ModelFieldValue.toMap]でサーバーへ保存するデータを変換する処理を実行します。
  const ModelFieldValue();

  /// A special class can be registered as a [ModelFieldValue] by passing [ModelFieldValueConverter] to [converter].
  ///
  /// [ModelFieldValueConverter]を[converter]に渡すことで特殊なクラスを[ModelFieldValue]として登録することができます。
  static void registerConverter(ModelFieldValueConverter converter) {
    _converters.add(converter);
  }

  /// By passing [ModelFieldValueConverter] to [converter], you can release an already registered [ModelFieldValueConverter].
  ///
  /// [converter]に[ModelFieldValueConverter]を渡すことですでに登録されている[ModelFieldValueConverter]を解除することができます。
  static void unregisterConverter(ModelFieldValueConverter converter) {
    _converters.remove(converter);
  }

  static final Set<ModelFieldValueConverter> _converters = {
    const ModelServerCommandBaseConverter(),
    const ModelCounterConverter(),
    const ModelTimestampRangeConverter(),
    const ModelDateRangeConverter(),
    const ModelTimeRangeConverter(),
    const ModelTimestampConverter(),
    const ModelDateConverter(),
    const ModelTimeConverter(),
    const ModelLocaleConverter(),
    const ModelLocalizedValueConverter(),
    const ModelGeoValueConverter(),
    const ModelUriConverter(),
    const ModelImageUriConverter(),
    const ModelVideoUriConverter(),
    const ModelSearchConverter(),
    const ModelTokenConverter(),
    const ModelRefConverter(),
  };

  /// A special class can be registered as a [ModelFieldValue] by passing [ModelFieldValueFilter] to [filter].
  ///
  /// [ModelFieldValueFilter]を[filter]に渡すことで特殊なクラスを[ModelFieldValue]として登録することができます。
  static void registerFilter(ModelFieldValueFilter filter) {
    _filters.add(filter);
  }

  /// By passing [ModelFieldValueFilter] to [filter], you can release an already registered [ModelFieldValueFilter].
  ///
  /// [filter]に[ModelFieldValueFilter]を渡すことですでに登録されている[ModelFieldValueFilter]を解除することができます。
  static void unregisterFilter(ModelFieldValueFilter filter) {
    _filters.remove(filter);
  }

  static final Set<ModelFieldValueFilter> _filters = {
    const ModelServerCommandBaseFilter(),
    const ModelCounterFilter(),
    const ModelTimestampRangeFilter(),
    const ModelDateRangeFilter(),
    const ModelTimeRangeFilter(),
    const ModelTimestampFilter(),
    const ModelDateFilter(),
    const ModelTimeFilter(),
    const ModelLocaleFilter(),
    const ModelLocalizedValueFilter(),
    const ModelGeoValueFilter(),
    const ModelUriFilter(),
    const ModelImageUriFilter(),
    const ModelVideoUriFilter(),
    const ModelSearchFilter(),
    const ModelTokenFilter(),
    const ModelRefFilter(),
  };

  /// Actual value.
  ///
  /// 実際の値。
  T get value;

  /// Methods for Json serialization.
  ///
  /// Used to convert [ModelFieldValue] values to Json in the `json_serializable` package.
  ///
  /// Jsonシリアライズを行うためのメソッド。
  ///
  /// `json_serializable`のパッケージで[ModelFieldValue]の値をJsonに変換する際に利用します。
  DynamicMap toJson();

  /// Performs the process of converting data read from the server.
  ///
  /// Pass the data read from the server to [value].
  ///
  /// The converted data is passed to the return value.
  ///
  /// サーバーから読み取られたデータを変換する処理を実行します。
  ///
  /// [value]にサーバーから読み取られたデータを渡します。
  ///
  /// 戻り値に変換後のデータが渡されます。
  static DynamicMap fromMap(DynamicMap value) {
    final res = <String, dynamic>{};
    for (final tmp in value.entries) {
      final key = tmp.key;
      final val = tmp.value;
      if (_converters.any((e) => e.check(val))) {
        res[key] = val;
      } else if (val is DynamicMap && val.containsKey(kTypeFieldKey)) {
        final type = val.get(kTypeFieldKey, "");
        final conveter = _converters.firstWhereOrNull((e) => e.type == type);
        if (conveter != null) {
          res[key] = conveter.fromJson(val);
        } else {
          res[key] = val;
        }
      } else if (val is List) {
        final vRes = <dynamic>[];
        for (final v in val) {
          final conveter = _converters.firstWhereOrNull((e) => e.check(v));
          if (conveter != null) {
            vRes.add(conveter.fromJson(v));
          } else if (v is DynamicMap && v.containsKey(kTypeFieldKey)) {
            final type = v.get(kTypeFieldKey, "");
            final conveter =
                _converters.firstWhereOrNull((e) => e.type == type);
            if (conveter != null) {
              vRes.add(conveter.fromJson(v));
            } else {
              vRes.add(v);
            }
          } else {
            vRes.add(v);
          }
        }
        res[key] = vRes;
      } else if (val is Set) {
        final vRes = <dynamic>[];
        for (final v in val) {
          final conveter = _converters.firstWhereOrNull((e) => e.check(v));
          if (conveter != null) {
            vRes.add(conveter.fromJson(v));
          } else if (v is DynamicMap && v.containsKey(kTypeFieldKey)) {
            final type = v.get(kTypeFieldKey, "");
            final conveter =
                _converters.firstWhereOrNull((e) => e.type == type);
            if (conveter != null) {
              vRes.add(conveter.fromJson(v));
            } else {
              vRes.add(v);
            }
          } else {
            vRes.add(v);
          }
        }
        res[key] = vRes;
      } else if (val is Map) {
        final vRes = <String, dynamic>{};
        for (final v in val.entries) {
          final vVal = v.value;
          final conveter = _converters.firstWhereOrNull((e) => e.check(vVal));
          if (conveter != null) {
            vRes[v.key] = conveter.fromJson(vVal);
          } else if (vVal is DynamicMap && vVal.containsKey(kTypeFieldKey)) {
            final type = vVal.get(kTypeFieldKey, "");
            final conveter =
                _converters.firstWhereOrNull((e) => e.type == type);
            if (conveter != null) {
              vRes[v.key] = conveter.fromJson(vVal);
            } else {
              vRes[v.key] = vVal;
            }
          } else {
            vRes[v.key] = vVal;
          }
        }
        res[key] = vRes;
      } else {
        res[key] = val;
      }
    }
    return Map.unmodifiable(
      Map<String, dynamic>.fromEntries(
        res.entries.where(
          (entry) => !entry.key.startsWith("@") && !entry.key.startsWith("#"),
        ),
      ),
    );
  }

  /// Executes the process of converting data to be stored on the server.
  ///
  /// The data to be saved to the server is passed to [value].
  ///
  /// The converted data is passed to the return value.
  ///
  /// サーバーへ保存するデータを変換する処理を実行します。
  ///
  /// [value]にサーバーへ保存するデータを渡します。
  ///
  /// 戻り値に変換後のデータが渡されます。
  static DynamicMap toMap(DynamicMap value) {
    final res = <String, dynamic>{};
    for (final tmp in value.entries) {
      final key = tmp.key;
      final val = tmp.value;
      if (val is List) {
        final vRes = <dynamic>[];
        for (final v in val) {
          final conveter = _converters.firstWhereOrNull((e) => e.check(v));
          if (conveter != null) {
            vRes.add(conveter.toJson(v));
          } else {
            vRes.add(v);
          }
        }
        res[key] = vRes;
      } else if (val is Set) {
        final vRes = <dynamic>{};
        for (final v in val) {
          final conveter = _converters.firstWhereOrNull((e) => e.check(v));
          if (conveter != null) {
            vRes.add(conveter.toJson(v));
          } else {
            vRes.add(v);
          }
        }
        res[key] = vRes;
      } else if (val is Map) {
        final vRes = <String, dynamic>{};
        for (final v in val.entries) {
          final conveter =
              _converters.firstWhereOrNull((e) => e.check(v.value));
          if (conveter != null) {
            vRes[v.key] = conveter.toJson(v.value);
          } else {
            vRes[v.key] = v.value;
          }
        }
        res[key] = vRes;
      } else {
        final conveter = _converters.firstWhereOrNull((e) => e.check(val));
        if (conveter != null) {
          res[key] = conveter.toJson(val);
        } else {
          res[key] = val;
        }
      }
    }
    return Map.unmodifiable(res);
  }
}

/// Mix-in to allow Json serialization and deserialization of ModelFieldValue.
///
/// It is treated as [Map], but updating the value is not supported.
/// UnsupportedError] is printed when attempting to update the value.
///
/// ModelFieldValueをJsonシリアライズ・デシリアライズできるようにするためのミックスイン。
///
/// [Map]として扱われますが、値の更新はサポートされていません。
/// 値を更新しようとすると[UnsupportedError]が出力されます。
mixin ModelFieldValueAsMapMixin<T>
    implements Map<String, Object?>, ModelFieldValue<T> {
  @override
  Iterable<String> get keys {
    final map = toJson();
    return map.keys;
  }

  @override
  Iterable<Object?> get values {
    final map = toJson();
    return map.values;
  }

  @override
  Object? operator [](Object? key) {
    final map = toJson();
    return map[key];
  }

  @override
  void operator []=(String key, Object? value) {
    throw UnsupportedError("Writing to the map is not supported.");
  }

  @override
  Object? remove(Object? key) {
    throw UnsupportedError("Writing to the map is not supported.");
  }

  @override
  void clear() {
    throw UnsupportedError("Writing to the map is not supported.");
  }

  @override
  Map<RK, RV> cast<RK, RV>() => Map.castFrom<String, Object?, RK, RV>(this);
  @override
  void forEach(void Function(String key, Object? value) action) {
    for (final key in keys) {
      action(key, this[key]);
    }
  }

  @override
  void addAll(Map<String, Object?> other) {
    other.forEach((String key, Object? value) {
      this[key] = value;
    });
  }

  @override
  bool containsValue(Object? value) {
    for (final key in keys) {
      if (this[key] == value) {
        return true;
      }
    }
    return false;
  }

  @override
  Object? putIfAbsent(String key, Object? Function() ifAbsent) {
    if (containsKey(key)) {
      return this[key];
    }
    return this[key] = ifAbsent();
  }

  @override
  Object? update(
    String key,
    Object? Function(Object? value) update, {
    Object? Function()? ifAbsent,
  }) {
    if (containsKey(key)) {
      return this[key] = update(this[key]);
    }
    if (ifAbsent != null) {
      return this[key] = ifAbsent();
    }
    throw ArgumentError.value(key, "key", "Key not in map.");
  }

  @override
  void updateAll(Object? Function(String key, Object? value) update) {
    for (final key in keys) {
      this[key] = update(key, this[key]);
    }
  }

  @override
  Iterable<MapEntry<String, Object?>> get entries {
    return keys.map((String key) => MapEntry<String, Object?>(key, this[key]));
  }

  @override
  Map<K2, V2> map<K2, V2>(
    MapEntry<K2, V2> Function(String key, Object? value) transform,
  ) {
    final result = <K2, V2>{};
    for (final key in keys) {
      final entry = transform(key, this[key]);
      result[entry.key] = entry.value;
    }
    return result;
  }

  @override
  void addEntries(Iterable<MapEntry<String, Object?>> newEntries) {
    for (final entry in newEntries) {
      this[entry.key] = entry.value;
    }
  }

  @override
  void removeWhere(bool Function(String key, Object? value) test) {
    final keysToRemove = <String>[];
    for (final key in keys) {
      if (test(key, this[key])) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      remove(key);
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
  @override
  String toString() => MapBase.mapToString(this);
}

/// Provides extension methods for [DynamicMap] for ModelFieldValue.
///
/// ModelFieldValue用の[DynamicMap]の拡張メソッドを提供します。
extension DynamicMapModelFieldValueExtensions on DynamicMap {
  /// Retrieves the element of [key] of type [ModelCounter] from [Map].
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelCounter], [ModelCounter] whose value is [defaultValue] is returned.
  ///
  /// [Map]から[ModelCounter]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[ModelCounter]と型が合わない場合、[defaultValue]が値となる[ModelCounter]が返されます。
  ModelCounter getAsModelCounter(String key, [int defaultValue = 0]) {
    if (!containsKey(key) || this[key] is! ModelCounter) {
      return ModelCounter(defaultValue);
    }
    return this[key] as ModelCounter;
  }

  /// Retrieves the element of [key] of type [ModelTimestamp] from [Map].
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelTimestamp], [ModelTimestamp] whose value is [defaultValue] is returned.
  ///
  /// [Map]から[ModelTimestamp]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[ModelTimestamp]と型が合わない場合、[defaultValue]が値となる[ModelTimestamp]が返されます。
  ModelTimestamp getAsModelTimestamp(String key, [DateTime? defaultValue]) {
    if (!containsKey(key) || this[key] is! ModelTimestamp) {
      return ModelTimestamp(defaultValue ?? Clock.now());
    }
    return this[key] as ModelTimestamp;
  }

  /// Retrieves the element of [key] of type [ModelDate] from [Map].
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelDate], [ModelDate] whose value is [defaultValue] is returned.
  ///
  /// [Map]から[ModelDate]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[ModelDate]と型が合わない場合、[defaultValue]が値となる[ModelDate]が返されます。
  ModelDate getAsModelDate(String key, [DateTime? defaultValue]) {
    if (!containsKey(key) || this[key] is! ModelDate) {
      return ModelDate(defaultValue ?? Clock.now());
    }
    return this[key] as ModelDate;
  }

  /// Retrieves the element of [key] of type [ModelRefBase] from [Map].
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelRefBase], [ModelTimestamp] whose value is [defaultPath] is returned.
  ///
  /// [Map]から[ModelRefBase]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[ModelRefBase]と型が合わない場合、[defaultPath]が値となる[ModelRefBase]が返されます。
  ModelRefBase<T> getAsModelRef<T>(String key, String defaultPath) {
    if (!containsKey(key) || this[key] is! ModelRefBase<T>) {
      return ModelRefBase<T>.fromPath(defaultPath);
    }
    return this[key] as ModelRefBase<T>;
  }
}

/// Defines where the source of the ModelFieldValue is located.
///
/// ModelFieldValueのソースがどこにあるかを定義します。
enum ModelFieldValueSource {
  /// User-defined.
  ///
  /// ユーザー定義。
  user,

  /// Server Definition.
  ///
  /// サーバー定義。
  server,
}

/// Define the field as a counter.
///
/// The base value is given as [value], and the value is increased or decreased by [increment].
///
/// By passing this to the server, it is possible to stably increase or decrease the value.
///
/// フィールドをカウンターとして定義します。
///
/// ベースの値を[value]として与え、[increment]で値を増減していきます。
///
/// これをサーバーに渡すことで安定して値の増減を行うことができます。
@immutable
class ModelCounter extends ModelFieldValue<int>
    implements Comparable<ModelCounter> {
  /// Define the field as a counter.
  ///
  /// The base value is given as [value], and the value is increased or decreased by [increment].
  ///
  /// By passing this to the server, it is possible to stably increase or decrease the value.
  ///
  /// フィールドをカウンターとして定義します。
  ///
  /// ベースの値を[value]として与え、[increment]で値を増減していきます。
  ///
  /// これをサーバーに渡すことで安定して値の増減を行うことができます。
  const factory ModelCounter(int value) = _ModelCounter;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelCounter.fromServer(int value) = _ModelCounter.fromServer;

  /// Convert from [json] map to [ModelCounter].
  ///
  /// [json]のマップから[ModelCounter]に変換します。
  factory ModelCounter.fromJson(DynamicMap json) {
    return ModelCounter.fromServer(
      json.getAsInt(kValueKey),
    );
  }

  const ModelCounter._(
    int value,
    int increment, [
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _increment = increment,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelCounter";

  /// Key to store the value.
  ///
  /// 値を保存しておくキー。
  static const kValueKey = "@value";

  /// Key to store the increase/decrease value.
  ///
  /// 増減値を保存しておくキー。
  static const kIncrementKey = "@increment";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  final int _value;

  final int _increment;

  final ModelFieldValueSource _source;

  /// Obtains the increase/decrease value.
  ///
  /// 増減値を取得します。
  int get incrementValue => _increment;

  /// Increase or decrease the value with [val].
  ///
  /// 値を[val]で増減します。
  ModelCounter increment(int val) {
    return ModelCounter._(_value, _increment + val, _source);
  }

  @override
  int get value => _value + _increment;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelCounter.typeString,
        kValueKey: value,
        kIncrementKey: incrementValue,
        kSourceKey: _source.name,
      };

  /// Compare with other [ModelCounter].
  ///
  /// 他の[ModelCounter]と比較します。
  bool operator <(ModelCounter other) => value < other.value;

  /// Compare with other [ModelCounter].
  ///
  /// 他の[ModelCounter]と比較します。
  bool operator >(ModelCounter other) => value > other.value;

  /// Compare with other [ModelCounter].
  ///
  /// 他の[ModelCounter]と比較します。
  bool operator <=(ModelCounter other) => value <= other.value;

  /// Compare with other [ModelCounter].
  ///
  /// 他の[ModelCounter]と比較します。
  bool operator >=(ModelCounter other) => value >= other.value;

  /// Add other [ModelCounter] as [increment] value.
  ///
  /// 他の[ModelCounter]を[increment]の値として加算します。
  ModelCounter operator +(ModelCounter other) => increment(other.value);

  /// Subtracts other [ModelCounter] as the value of [increment].
  ///
  /// 他の[ModelCounter]を[increment]の値として減算します。
  ModelCounter operator -(ModelCounter other) => increment(-other.value);

  /// Inverts the plus/minus of the [increment] and [value] values.
  ///
  /// [increment]の値と[value]の値のプラスマイナスを反転します。
  ModelCounter operator -() {
    return ModelCounter._(-_value, -_increment, _source);
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode ^ _increment.hashCode;

  @override
  int compareTo(ModelCounter other) {
    return value.compareTo(other.value);
  }
}

@immutable
class _ModelCounter extends ModelCounter with ModelFieldValueAsMapMixin<int> {
  const _ModelCounter(
    int value, [
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ]) : super._(value, 0, source);
  const _ModelCounter.fromServer(int value)
      : super._(value, 0, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelCounter] as [ModelFieldValue].
///
/// [ModelCounter]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelCounterConverter extends ModelFieldValueConverter<ModelCounter> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelCounter] as [ModelFieldValue].
  ///
  /// [ModelCounter]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelCounterConverter();

  @override
  String get type => ModelCounter.typeString;

  @override
  ModelCounter fromJson(Map<String, Object?> map) {
    return ModelCounter.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelCounter value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelCounter] available to [ModelQuery.filters].
///
/// [ModelCounter]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelCounterFilter extends ModelFieldValueFilter<ModelCounter> {
  /// Filter class to make [ModelCounter] available to [ModelQuery.filters].
  ///
  /// [ModelCounter]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelCounterFilter();

  @override
  String get type => ModelCounter.typeString;

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
      case ModelQueryFilterType.lessThan:
        return _hasMatch(source, target, (source, target) => source < target);
      case ModelQueryFilterType.greaterThan:
        return _hasMatch(source, target, (source, target) => source > target);
      case ModelQueryFilterType.lessThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source <= target);
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source >= target);
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
    T Function(num source, num target) filter,
  ) {
    if (source is ModelCounter && target is ModelCounter) {
      return filter(source.value, target.value);
    } else if (source is ModelCounter && target is num) {
      return filter(source.value, target);
    } else if (source is num && target is ModelCounter) {
      return filter(source, target.value);
    } else if (source is ModelCounter &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelCounter.typeString) {
      return filter(source.value, ModelCounter.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelCounter &&
        source.get(kTypeFieldKey, "") == ModelCounter.typeString) {
      return filter(ModelCounter.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelCounter.typeString &&
        target.get(kTypeFieldKey, "") == ModelCounter.typeString) {
      return filter(ModelCounter.fromJson(source).value,
          ModelCounter.fromJson(target).value);
    }
    return null;
  }
}

/// Define the field as a timestamp.
///
/// The base value is given as [value]. If not given, the current time is set.
///
/// By passing this to the server, the timestamp on the server side is stored as data.
///
/// フィールドをタイムスタンプとして定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合現在時刻がセットされます。
///
/// これをサーバーに渡すことでサーバー側のタイムスタンプがデータとして保存されます。
@immutable
class ModelTimestamp extends ModelFieldValue<DateTime>
    implements Comparable<ModelTimestamp> {
  /// Define the field as a timestamp.
  ///
  /// The base value is given as [value]. If not given, the current time is set.
  ///
  /// By passing this to the server, the timestamp on the server side is stored as data.
  ///
  /// フィールドをタイムスタンプとして定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合現在時刻がセットされます。
  ///
  /// これをサーバーに渡すことでサーバー側のタイムスタンプがデータとして保存されます。
  const factory ModelTimestamp([DateTime? value]) = _ModelTimestamp;

  /// Define the field as a timestamp.
  ///
  /// The current time is returned in the same way as [DateTime.now].
  ///
  /// By passing this to the server, the timestamp on the server side is stored as data.
  ///
  /// フィールドをタイムスタンプとして定義します。
  ///
  /// [DateTime.now]と同じ様に現在時刻が返されます。
  ///
  /// これをサーバーに渡すことでサーバー側のタイムスタンプがデータとして保存されます。
  const factory ModelTimestamp.now() = _ModelTimestampWithNow;

  /// Define the field as a timestamp.
  ///
  /// Returns the date and time specified in [year], [month], [day], [hour], [minute], [second], [millisecond], or [microsecond].
  ///
  /// By passing this to the server, the timestamp on the server side is stored as data.
  ///
  /// フィールドをタイムスタンプとして定義します。
  ///
  /// [year]、[month]、[day]、[hour]、[minute]、[second]、[millisecond]、[microsecond]で指定した日時が返されます。
  ///
  /// これをサーバーに渡すことでサーバー側のタイムスタンプがデータとして保存されます。
  const factory ModelTimestamp.dateTime(
    int year, [
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) = _ModelTimestampWithDateTime;

  /// Parse from [formattedString] and convert to [ModelTimestamp].
  ///
  /// If the conversion fails, a [FormatException] is raised.
  ///
  /// [formattedString]からパースして[ModelTimestamp]に変換します。
  ///
  /// 変換に失敗した場合は[FormatException]が発生します。
  factory ModelTimestamp.parse(String formattedString) {
    final dateTime = DateTime.parse(formattedString);
    return ModelTimestamp(dateTime);
  }

  /// Parse from [formattedString] and convert to [ModelTimestamp].
  ///
  /// Returns [Null] if the conversion fails.
  ///
  /// [formattedString]からパースして[ModelTimestamp]に変換します。
  ///
  /// 変換に失敗した場合は[Null]を返します。
  static ModelTimestamp? tryParse(String formattedString) {
    final dateTime = DateTime.tryParse(formattedString);
    if (dateTime == null) {
      return null;
    }
    return ModelTimestamp(dateTime);
  }

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelTimestamp.fromServer([DateTime? value]) =
      _ModelTimestamp.fromServer;

  /// Convert from [json] map to [ModelTimestamp].
  ///
  /// [json]のマップから[ModelTimestamp]に変換します。
  factory ModelTimestamp.fromJson(DynamicMap json) {
    final timestamp = json.get(
      kTimeKey,
      Clock.now().microsecondsSinceEpoch,
    );
    return ModelTimestamp.fromServer(
      DateTime.fromMicrosecondsSinceEpoch(timestamp),
    );
  }

  const ModelTimestamp._([
    DateTime? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelTimestamp";

  /// Key to save time.
  ///
  /// 時間を保存しておくキー。
  static const kTimeKey = "@time";

  /// A value key that should be set to `true` if the current time is used.
  ///
  /// 現在時間を利用する場合`true`にしておく値のキー。
  static const kNowKey = "@now";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  DateTime get value => _value ?? Clock.now();
  final DateTime? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelDate].
  ///
  /// [ModelDate]に変換します。
  ModelDate toModelDate() {
    return ModelDate(value);
  }

  /// Convert to [ModelTime].
  ///
  /// [ModelTime]に変換します。
  ModelTime toModelTime() {
    return ModelTime(value);
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelTimestamp.typeString,
        kTimeKey: value.microsecondsSinceEpoch,
        kNowKey: _value == null,
        kSourceKey: _source.name,
      };

  /// Compare with other [ModelTimestamp].
  ///
  /// 他の[ModelTimestamp]と比較します。
  bool operator <(ModelTimestamp other) =>
      value.microsecondsSinceEpoch < other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelTimestamp].
  ///
  /// 他の[ModelTimestamp]と比較します。
  bool operator >(ModelTimestamp other) =>
      value.microsecondsSinceEpoch > other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelTimestamp].
  ///
  /// 他の[ModelTimestamp]と比較します。
  bool operator <=(ModelTimestamp other) =>
      value.microsecondsSinceEpoch <= other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelTimestamp].
  ///
  /// 他の[ModelTimestamp]と比較します。
  bool operator >=(ModelTimestamp other) =>
      value.microsecondsSinceEpoch >= other.value.microsecondsSinceEpoch;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(ModelTimestamp other) {
    return value.microsecondsSinceEpoch.compareTo(
      other.value.microsecondsSinceEpoch,
    );
  }
}

@immutable
class _ModelTimestampWithNow extends _ModelTimestamp {
  const _ModelTimestampWithNow() : super();

  @override
  DateTime? get _value {
    return Clock.now();
  }
}

@immutable
class _ModelTimestampWithDateTime extends _ModelTimestamp {
  const _ModelTimestampWithDateTime(
    this.year, [
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.millisecond,
    this.microsecond,
  ]) : super();

  final int year;
  final int? month;
  final int? day;
  final int? hour;
  final int? minute;
  final int? second;
  final int? millisecond;
  final int? microsecond;

  @override
  DateTime? get _value {
    return Clock(
      year,
      month ?? 1,
      day ?? 1,
      hour ?? 0,
      minute ?? 0,
      second ?? 0,
      millisecond ?? 0,
      microsecond ?? 0,
    );
  }
}

@immutable
class _ModelTimestamp extends ModelTimestamp
    with ModelFieldValueAsMapMixin<DateTime> {
  const _ModelTimestamp([
    super.value,
  ]) : super._();
  const _ModelTimestamp.fromServer([DateTime? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelTimestamp] as [ModelFieldValue].
///
/// [ModelTimestamp]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelTimestampConverter extends ModelFieldValueConverter<ModelTimestamp> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelTimestamp] as [ModelFieldValue].
  ///
  /// [ModelTimestamp]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelTimestampConverter();

  @override
  String get type => ModelTimestamp.typeString;

  @override
  ModelTimestamp fromJson(Map<String, Object?> map) {
    return ModelTimestamp.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelTimestamp value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelTimestamp] available to [ModelQuery.filters].
///
/// [ModelTimestamp]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelTimestampFilter extends ModelFieldValueFilter<ModelTimestamp> {
  /// Filter class to make [ModelTimestamp] available to [ModelQuery.filters].
  ///
  /// [ModelTimestamp]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelTimestampFilter();

  @override
  String get type => ModelTimestamp.typeString;

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
      case ModelQueryFilterType.lessThan:
        return _hasMatch(source, target, (source, target) => source < target);
      case ModelQueryFilterType.greaterThan:
        return _hasMatch(source, target, (source, target) => source > target);
      case ModelQueryFilterType.lessThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source <= target);
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source >= target);
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
    T Function(num source, num target) filter,
  ) {
    if (source is ModelTimestamp && target is ModelTimestamp) {
      return filter(source.value.microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is ModelTimestamp && target is DateTime) {
      return filter(
          source.value.microsecondsSinceEpoch, target.microsecondsSinceEpoch);
    } else if (source is DateTime && target is ModelTimestamp) {
      return filter(
          source.microsecondsSinceEpoch, target.value.microsecondsSinceEpoch);
    } else if (source is ModelTimestamp && target is num) {
      return filter(source.value.microsecondsSinceEpoch, target);
    } else if (source is num && target is ModelTimestamp) {
      return filter(source, target.value.microsecondsSinceEpoch);
    } else if (source is ModelTimestamp &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelTimestamp.typeString) {
      return filter(source.value.microsecondsSinceEpoch,
          ModelTimestamp.fromJson(target).value.microsecondsSinceEpoch);
    } else if (source is DynamicMap &&
        target is ModelTimestamp &&
        source.get(kTypeFieldKey, "") == ModelTimestamp.typeString) {
      return filter(
          ModelTimestamp.fromJson(source).value.microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelTimestamp.typeString &&
        target.get(kTypeFieldKey, "") == ModelTimestamp.typeString) {
      return filter(
          ModelTimestamp.fromJson(source).value.microsecondsSinceEpoch,
          ModelTimestamp.fromJson(target).value.microsecondsSinceEpoch);
    }
    return null;
  }
}

/// Define the field as a date.
///
/// The base value is given as [value]. If not given, the current date is set.
///
/// フィールドを日付として定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合現在の日付がセットされます。
@immutable
class ModelDate extends ModelFieldValue<DateTime>
    implements Comparable<ModelDate> {
  /// Define the field as a date.
  ///
  /// The base value is given as [value]. If not given, the current date is set.
  ///
  /// フィールドを日付として定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合現在の日付がセットされます。
  const factory ModelDate([DateTime? value]) = _ModelDate;

  /// Define the field as a date.
  ///
  /// Returns the time at midnight of the current date, similar to [DateTime.now].
  ///
  /// フィールドを日付として定義します。
  ///
  /// [DateTime.now]と同じ様に現在の日付の0時時点での時刻が返されます。
  const factory ModelDate.now() = _ModelDateWithNow;

  /// Define the field as a date.
  ///
  /// The date specified by [year], [month], or [day] is returned.
  ///
  /// フィールドを日付として定義します。
  ///
  /// [year]、[month]、[day]で指定した日付が返されます。
  const factory ModelDate.date(
    int year, [
    int? month,
    int? day,
  ]) = _ModelDateWithDateTime;

  /// Parse from [formattedString] and convert to [ModelDate].
  ///
  /// If the conversion fails, a [FormatException] is raised.
  ///
  /// [formattedString]からパースして[ModelDate]に変換します。
  ///
  /// 変換に失敗した場合は[FormatException]が発生します。
  factory ModelDate.parse(String formattedString) {
    final dateTime = DateTime.parse(formattedString);
    return ModelDate(dateTime);
  }

  /// Parse from [formattedString] and convert to [ModelDate].
  ///
  /// Returns [Null] if the conversion fails.
  ///
  /// [formattedString]からパースして[ModelDate]に変換します。
  ///
  /// 変換に失敗した場合は[Null]を返します。
  static ModelDate? tryParse(String formattedString) {
    final dateTime = DateTime.tryParse(formattedString);
    if (dateTime == null) {
      return null;
    }
    return ModelDate(dateTime);
  }

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelDate.fromServer([DateTime? value]) = _ModelDate.fromServer;

  /// Convert from [json] map to [ModelDate].
  ///
  /// [json]のマップから[ModelDate]に変換します。
  factory ModelDate.fromJson(DynamicMap json) {
    final timestamp = json.get(
      kTimeKey,
      Clock.now().microsecondsSinceEpoch,
    );
    return ModelDate.fromServer(
      DateTime.fromMicrosecondsSinceEpoch(timestamp),
    );
  }

  const ModelDate._([
    DateTime? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelDate";

  /// Key to save time.
  ///
  /// 時間を保存しておくキー。
  static const kTimeKey = "@time";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  DateTime get value {
    final now = _value ?? Clock.now();
    return Clock(
      now.year,
      now.month,
      now.day,
    );
  }

  final DateTime? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelTimestamp]. All times are set to 0.
  ///
  /// [ModelTimestamp]に変換します。時間はすべて0になります。
  ModelTimestamp toModelTimestamp() {
    return ModelTimestamp(value);
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelDate.typeString,
        kTimeKey: value.microsecondsSinceEpoch,
        kSourceKey: _source.name,
      };

  /// Compare with other [ModelDate].
  ///
  /// 他の[ModelDate]と比較します。
  bool operator <(ModelDate other) =>
      value.microsecondsSinceEpoch < other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelDate].
  ///
  /// 他の[ModelDate]と比較します。
  bool operator >(ModelDate other) =>
      value.microsecondsSinceEpoch > other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelDate].
  ///
  /// 他の[ModelDate]と比較します。
  bool operator <=(ModelDate other) =>
      value.microsecondsSinceEpoch <= other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelDate].
  ///
  /// 他の[ModelDate]と比較します。
  bool operator >=(ModelDate other) =>
      value.microsecondsSinceEpoch >= other.value.microsecondsSinceEpoch;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(ModelDate other) {
    return value.microsecondsSinceEpoch.compareTo(
      other.value.microsecondsSinceEpoch,
    );
  }

  /// Create a new [ModelDate] with the specified [year], [month], and [day].
  ///
  /// 指定した[year]、[month]、[day]で新しい[ModelDate]を作成します。
  ModelDate copyWith({int? year, int? month, int? day}) {
    return ModelDate.date(
      year ?? value.year,
      month ?? value.month,
      day ?? value.day,
    );
  }
}

@immutable
class _ModelDateWithNow extends _ModelDate {
  const _ModelDateWithNow() : super();

  @override
  DateTime? get _value {
    return Clock.now();
  }
}

@immutable
class _ModelDateWithDateTime extends _ModelDate {
  const _ModelDateWithDateTime(
    this.year, [
    this.month,
    this.day,
  ]) : super();

  final int year;
  final int? month;
  final int? day;

  @override
  DateTime? get _value {
    return Clock(
      year,
      month ?? 1,
      day ?? 1,
    );
  }
}

@immutable
class _ModelDate extends ModelDate with ModelFieldValueAsMapMixin<DateTime> {
  const _ModelDate([
    super.value,
  ]) : super._();
  const _ModelDate.fromServer([DateTime? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelDate] as [ModelFieldValue].
///
/// [ModelDate]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelDateConverter extends ModelFieldValueConverter<ModelDate> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelDate] as [ModelFieldValue].
  ///
  /// [ModelDate]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelDateConverter();

  @override
  String get type => ModelDate.typeString;

  @override
  ModelDate fromJson(Map<String, Object?> map) {
    return ModelDate.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelDate value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelDate] available to [ModelQuery.filters].
///
/// [ModelDate]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelDateFilter extends ModelFieldValueFilter<ModelDate> {
  /// Filter class to make [ModelDate] available to [ModelQuery.filters].
  ///
  /// [ModelDate]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelDateFilter();

  @override
  String get type => ModelDate.typeString;

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
      case ModelQueryFilterType.lessThan:
        return _hasMatch(source, target, (source, target) => source < target);
      case ModelQueryFilterType.greaterThan:
        return _hasMatch(source, target, (source, target) => source > target);
      case ModelQueryFilterType.lessThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source <= target);
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source >= target);
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
    T Function(num source, num target) filter,
  ) {
    if (source is ModelDate && target is ModelDate) {
      return filter(source.value.microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is ModelDate && target is DateTime) {
      return filter(source.value.microsecondsSinceEpoch,
          Clock(target.year, target.month, target.day).microsecondsSinceEpoch);
    } else if (source is DateTime && target is ModelDate) {
      return filter(
          Clock(source.year, source.month, source.day).microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is ModelDate && target is num) {
      return filter(source.value.microsecondsSinceEpoch, target);
    } else if (source is num && target is ModelDate) {
      return filter(source, target.value.microsecondsSinceEpoch);
    } else if (source is ModelDate &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelDate.typeString) {
      return filter(source.value.microsecondsSinceEpoch,
          ModelDate.fromJson(target).value.microsecondsSinceEpoch);
    } else if (source is DynamicMap &&
        target is ModelDate &&
        source.get(kTypeFieldKey, "") == ModelDate.typeString) {
      return filter(ModelDate.fromJson(source).value.microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelDate.typeString &&
        target.get(kTypeFieldKey, "") == ModelDate.typeString) {
      return filter(ModelDate.fromJson(source).value.microsecondsSinceEpoch,
          ModelDate.fromJson(target).value.microsecondsSinceEpoch);
    }
    return null;
  }
}

/// Define the field as a time.
///
/// The base value is given as [value]. If not given, the current time is set.
///
/// フィールドを時刻として定義します。
///
/// ベースの値を[value]として与えます。与えられなかった場合現在の時刻がセットされます。
@immutable
class ModelTime extends ModelFieldValue<DateTime>
    implements Comparable<ModelTime> {
  /// Define the field as a time.
  ///
  /// The base value is given as [value]. If not given, the current time is set.
  ///
  /// フィールドを時刻として定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合現在の時刻がセットされます。
  const factory ModelTime([DateTime? value]) = _ModelTime;

  /// Define the field as a date.
  ///
  /// The current time is returned in the same way as [DateTime.now].
  ///
  /// フィールドを時刻として定義します。
  ///
  /// [DateTime.now]と同じ様に現在の時刻が返されます。
  const factory ModelTime.now() = _ModelTimeWithNow;

  /// Define the field as a date.
  ///
  /// The time specified by [hour], [minute], [second], [millisecond], or [microsecond] is returned.
  ///
  /// フィールドを時刻として定義します。
  ///
  /// [hour]、[minute]、[second]、[millisecond]、[microsecond]で指定した時刻が返されます。
  const factory ModelTime.time(
    int hour, [
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) = _ModelTimeWithDateTime;

  /// Parse from [formattedString] and convert to [ModelTime].
  ///
  /// If the conversion fails, a [FormatException] is raised.
  ///
  /// [formattedString]からパースして[ModelTime]に変換します。
  ///
  /// 変換に失敗した場合は[FormatException]が発生します。
  factory ModelTime.parse(String formattedString) {
    if (_dateRegExp.hasMatch(formattedString)) {
      final dateTime = DateTime.parse(formattedString);
      return ModelTime(dateTime);
    } else {
      final dateTime = DateTime.parse(
          "${_defaultYear.toString().padLeft(4, '0')}-${_defaultMonth.toString().padLeft(2, '0')}-${_defaultDay.toString().padLeft(2, '0')} $formattedString");
      return ModelTime(dateTime);
    }
  }

  /// Parse from [formattedString] and convert to [ModelTime].
  ///
  /// Returns [Null] if the conversion fails.
  ///
  /// [formattedString]からパースして[ModelTime]に変換します。
  ///
  /// 変換に失敗した場合は[Null]を返します。
  static ModelTime? tryParse(String formattedString) {
    if (_dateRegExp.hasMatch(formattedString)) {
      final dateTime = DateTime.tryParse(formattedString);
      if (dateTime == null) {
        return null;
      }
      return ModelTime(dateTime);
    } else {
      final dateTime = DateTime.tryParse(
          "${_defaultYear.toString().padLeft(4, '0')}-${_defaultMonth.toString().padLeft(2, '0')}-${_defaultDay.toString().padLeft(2, '0')} $formattedString");
      if (dateTime == null) {
        return null;
      }
      return ModelTime(dateTime);
    }
  }

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelTime.fromServer([DateTime? value]) = _ModelTime.fromServer;

  /// Convert from [json] map to [ModelTime].
  ///
  /// [json]のマップから[ModelTime]に変換します。
  factory ModelTime.fromJson(DynamicMap json) {
    final timestamp = json.get(
      kTimeKey,
      Clock.now().microsecondsSinceEpoch,
    );
    return ModelTime.fromServer(
      DateTime.fromMicrosecondsSinceEpoch(timestamp),
    );
  }

  const ModelTime._([
    DateTime? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  static final _dateRegExp = RegExp(r"^\d{4}-\d{2}-\d{2}");
  static const _defaultYear = 2000;
  static const _defaultMonth = 1;
  static const _defaultDay = 1;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelTime";

  /// Key to save time.
  ///
  /// 時間を保存しておくキー。
  static const kTimeKey = "@time";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  DateTime get value {
    final now = _value ?? Clock.now();
    return Clock(
      _defaultYear,
      _defaultMonth,
      _defaultDay,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  final DateTime? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelTimestamp]. The date will be [date], or January 1, 1970.
  ///
  /// [ModelTimestamp]に変換します。日付は[date]、もしくは1970年1月1日になります。
  ModelTimestamp toModelTimestamp([ModelDate? date]) {
    return ModelTimestamp(
      Clock(
        date?.value.year ?? _defaultYear,
        date?.value.month ?? _defaultMonth,
        date?.value.day ?? _defaultDay,
        value.hour,
        value.minute,
        value.second,
        value.millisecond,
        value.microsecond,
      ),
    );
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelTime.typeString,
        kTimeKey: value.microsecondsSinceEpoch,
        kSourceKey: _source.name,
      };

  /// Compare with other [ModelTime].
  ///
  /// 他の[ModelTime]と比較します。
  bool operator <(ModelTime other) =>
      value.microsecondsSinceEpoch < other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelTime].
  ///
  /// 他の[ModelTime]と比較します。
  bool operator >(ModelTime other) =>
      value.microsecondsSinceEpoch > other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelTime].
  ///
  /// 他の[ModelTime]と比較します。
  bool operator <=(ModelTime other) =>
      value.microsecondsSinceEpoch <= other.value.microsecondsSinceEpoch;

  /// Compare with other [ModelTime].
  ///
  /// 他の[ModelTime]と比較します。
  bool operator >=(ModelTime other) =>
      value.microsecondsSinceEpoch >= other.value.microsecondsSinceEpoch;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(ModelTime other) {
    return value.microsecondsSinceEpoch.compareTo(
      other.value.microsecondsSinceEpoch,
    );
  }

  /// Create a new [ModelTime] with the specified [hour], [minute], [second], [millisecond], or [microsecond].
  ///
  /// 指定した[hour]、[minute]、[second]、[millisecond]、[microsecond]で新しい[ModelTime]を作成します。
  ModelTime copyWith({
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return ModelTime(DateTime(
      value.year,
      value.month,
      value.day,
      hour ?? value.hour,
      minute ?? value.minute,
      second ?? value.second,
      millisecond ?? value.millisecond,
      microsecond ?? value.microsecond,
    ));
  }
}

@immutable
class _ModelTimeWithNow extends _ModelTime {
  const _ModelTimeWithNow() : super();

  @override
  DateTime? get _value {
    return Clock.now();
  }
}

@immutable
class _ModelTimeWithDateTime extends _ModelTime {
  const _ModelTimeWithDateTime(
    this.hour, [
    this.minute,
    this.second,
    this.millisecond,
    this.microsecond,
  ]) : super();

  final int hour;
  final int? minute;
  final int? second;
  final int? millisecond;
  final int? microsecond;

  @override
  DateTime? get _value {
    return Clock(
      ModelTime._defaultYear,
      ModelTime._defaultMonth,
      ModelTime._defaultDay,
      hour,
      minute ?? 0,
      second ?? 0,
      millisecond ?? 0,
      microsecond ?? 0,
    );
  }
}

@immutable
class _ModelTime extends ModelTime with ModelFieldValueAsMapMixin<DateTime> {
  const _ModelTime([
    super.value,
  ]) : super._();
  const _ModelTime.fromServer([DateTime? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelTime] as [ModelFieldValue].
///
/// [ModelTime]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelTimeConverter extends ModelFieldValueConverter<ModelTime> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelTime] as [ModelFieldValue].
  ///
  /// [ModelTime]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelTimeConverter();

  @override
  String get type => ModelTime.typeString;

  @override
  ModelTime fromJson(Map<String, Object?> map) {
    return ModelTime.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelTime value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelTime] available to [ModelQuery.filters].
///
/// [ModelTime]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelTimeFilter extends ModelFieldValueFilter<ModelTime> {
  /// Filter class to make [ModelTime] available to [ModelQuery.filters].
  ///
  /// [ModelTime]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelTimeFilter();

  @override
  String get type => ModelTime.typeString;

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
      case ModelQueryFilterType.lessThan:
        return _hasMatch(source, target, (source, target) => source < target);
      case ModelQueryFilterType.greaterThan:
        return _hasMatch(source, target, (source, target) => source > target);
      case ModelQueryFilterType.lessThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source <= target);
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return _hasMatch(source, target, (source, target) => source >= target);
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
    T Function(num source, num target) filter,
  ) {
    if (source is ModelTime && target is ModelTime) {
      return filter(source.value.microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is ModelTime && target is DateTime) {
      return filter(
          source.value.microsecondsSinceEpoch,
          Clock(
                  ModelTime._defaultYear,
                  ModelTime._defaultMonth,
                  ModelTime._defaultDay,
                  source.value.hour,
                  source.value.minute,
                  source.value.second,
                  source.value.millisecond,
                  source.value.microsecond)
              .microsecondsSinceEpoch);
    } else if (source is DateTime && target is ModelTime) {
      return filter(
          Clock(
                  ModelTime._defaultYear,
                  ModelTime._defaultMonth,
                  ModelTime._defaultDay,
                  source.hour,
                  source.minute,
                  source.second,
                  source.millisecond,
                  source.microsecond)
              .microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is ModelTime && target is num) {
      return filter(source.value.microsecondsSinceEpoch, target);
    } else if (source is num && target is ModelTime) {
      return filter(source, target.value.microsecondsSinceEpoch);
    } else if (source is ModelTime &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelTime.typeString) {
      return filter(source.value.microsecondsSinceEpoch,
          ModelTime.fromJson(target).value.microsecondsSinceEpoch);
    } else if (source is DynamicMap &&
        target is ModelTime &&
        source.get(kTypeFieldKey, "") == ModelTime.typeString) {
      return filter(ModelTime.fromJson(source).value.microsecondsSinceEpoch,
          target.value.microsecondsSinceEpoch);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelTime.typeString &&
        target.get(kTypeFieldKey, "") == ModelTime.typeString) {
      return filter(ModelTime.fromJson(source).value.microsecondsSinceEpoch,
          ModelTime.fromJson(target).value.microsecondsSinceEpoch);
    }
    return null;
  }
}

/// Define the field as a range of timestamps.
///
/// The base value is given as [value].
///
/// フィールドをタイムスタンプの範囲として定義します。
///
/// ベースの値を[value]として与えます。
@immutable
class ModelTimestampRange extends ModelFieldValue<DateTimeRange>
    implements Comparable<ModelTimestampRange> {
  /// Define the field as a range of timestamps.
  ///
  /// The base value is given as [value].
  ///
  /// フィールドをタイムスタンプの範囲として定義します。
  ///
  /// ベースの値を[value]として与えます。
  const factory ModelTimestampRange(DateTimeRange value) = _ModelTimestampRange;

  /// Define the field as a range of timestamps.
  ///
  /// The [ModelTimestamp] at the start is given as [start] and the [ModelTimestamp] at the end as [end].
  ///
  /// フィールドをタイムスタンプの範囲として定義します。
  ///
  /// 開始時の[ModelTimestamp]を[start]、終了時の[ModelTimestamp]を[end]として与えます。
  const factory ModelTimestampRange.fromModelTimestamp({
    required ModelTimestamp start,
    required ModelTimestamp end,
  }) = _ModelTimestampRangeWithModelTimestamp;

  /// Define the field as a range of timestamps.
  ///
  /// The [DateTime] at the start is given as [start] and the [DateTime] at the end as [end].
  ///
  /// フィールドをタイムスタンプの範囲として定義します。
  ///
  /// 開始時の[DateTime]を[start]、終了時の[DateTime]を[end]として与えます。
  const factory ModelTimestampRange.fromDateTime({
    required DateTime start,
    required DateTime end,
  }) = _ModelTimestampRangeWithDateTime;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelTimestampRange.fromServer(DateTimeRange value) =
      _ModelTimestampRange.fromServer;

  /// Convert from [json] map to [ModelTimestamp].
  ///
  /// [json]のマップから[ModelTimestamp]に変換します。
  factory ModelTimestampRange.fromJson(DynamicMap json) {
    final start = json.get(
      kStartTimeKey,
      Clock.now().microsecondsSinceEpoch,
    );
    final end = json.get(
      kEndTimeKey,
      Clock.now().microsecondsSinceEpoch + 1,
    );
    return ModelTimestampRange.fromServer(
      DateTimeRange(
        start: DateTime.fromMicrosecondsSinceEpoch(start),
        end: DateTime.fromMicrosecondsSinceEpoch(end),
      ),
    );
  }

  const ModelTimestampRange._([
    DateTimeRange? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelTimestampRange";

  /// Key to save start time.
  ///
  /// 開始時間を保存しておくキー。
  static const kStartTimeKey = "@start";

  /// Key to save end time.
  ///
  /// 終了時間を保存しておくキー。
  static const kEndTimeKey = "@end";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  DateTimeRange get value =>
      _value ??
      DateTimeRange(
        start: Clock.now(),
        end: Clock.now().add(const Duration(days: 1)),
      );
  final DateTimeRange? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelDateRange].
  ///
  /// [ModelDateRange]に変換します。
  ModelDateRange toModelDateRange() {
    return ModelDateRange(value);
  }

  /// Convert to [ModelTimeRange].
  ///
  /// [ModelTimeRange]に変換します。
  ModelTimeRange toModelTimeRange() {
    return ModelTimeRange(value);
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelTimestampRange.typeString,
        kStartTimeKey: value.start.microsecondsSinceEpoch,
        kEndTimeKey: value.end.microsecondsSinceEpoch,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(ModelTimestampRange other) {
    return value.toString().compareTo(
          other.value.toString(),
        );
  }
}

@immutable
class _ModelTimestampRangeWithModelTimestamp extends _ModelTimestampRange {
  const _ModelTimestampRangeWithModelTimestamp({
    required this.start,
    required this.end,
  }) : super();

  final ModelTimestamp start;
  final ModelTimestamp end;

  @override
  DateTimeRange? get _value {
    return DateTimeRange(
      start: start.value,
      end: end.value,
    );
  }
}

@immutable
class _ModelTimestampRangeWithDateTime extends _ModelTimestampRange {
  const _ModelTimestampRangeWithDateTime({
    required this.start,
    required this.end,
  }) : super();

  final DateTime start;
  final DateTime end;

  @override
  DateTimeRange? get _value {
    return DateTimeRange(
      start: start,
      end: end,
    );
  }
}

@immutable
class _ModelTimestampRange extends ModelTimestampRange
    with ModelFieldValueAsMapMixin<DateTimeRange> {
  const _ModelTimestampRange([
    super.value,
  ]) : super._();
  const _ModelTimestampRange.fromServer([DateTimeRange? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelTimestampRange] as [ModelFieldValue].
///
/// [ModelTimestampRange]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelTimestampRangeConverter
    extends ModelFieldValueConverter<ModelTimestampRange> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelTimestampRange] as [ModelFieldValue].
  ///
  /// [ModelTimestampRange]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelTimestampRangeConverter();

  @override
  String get type => ModelTimestampRange.typeString;

  @override
  ModelTimestampRange fromJson(Map<String, Object?> map) {
    return ModelTimestampRange.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelTimestampRange value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelTimestampRange] available to [ModelQuery.filters].
///
/// [ModelTimestampRange]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelTimestampRangeFilter
    extends ModelFieldValueFilter<ModelTimestampRange> {
  /// Filter class to make [ModelTimestampRange] available to [ModelQuery.filters].
  ///
  /// [ModelTimestampRange]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelTimestampRangeFilter();

  @override
  String get type => ModelTimestampRange.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
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
    T Function(DateTimeRange source, DateTimeRange target) filter,
  ) {
    if (source is ModelTimestampRange && target is ModelTimestampRange) {
      return filter(source.value, target.value);
    } else if (source is ModelTimestampRange && target is DateTimeRange) {
      return filter(source.value, target);
    } else if (source is DateTimeRange && target is ModelTimestampRange) {
      return filter(source, target.value);
    } else if (source is ModelTimestampRange &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelTimestampRange.typeString) {
      return filter(source.value, ModelTimestampRange.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelTimestampRange &&
        source.get(kTypeFieldKey, "") == ModelTimestampRange.typeString) {
      return filter(ModelTimestampRange.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelTimestampRange.typeString &&
        target.get(kTypeFieldKey, "") == ModelTimestampRange.typeString) {
      return filter(ModelTimestampRange.fromJson(source).value,
          ModelTimestampRange.fromJson(target).value);
    }
    return null;
  }
}

/// Define the field as a range of dates.
///
/// The base value is given as [value].
///
/// フィールドを日付の範囲として定義します。
///
/// ベースの値を[value]として与えます
@immutable
class ModelDateRange extends ModelFieldValue<DateTimeRange>
    implements Comparable<ModelDateRange> {
  /// Define the field as a date.
  ///
  /// The base value is given as [value].
  ///
  /// フィールドを日付として定義します。
  ///
  /// ベースの値を[value]として与えます。
  const factory ModelDateRange(DateTimeRange value) = _ModelDateRange;

  /// Define the field as a range of timestamps.
  ///
  /// The [ModelDate] at the start is given as [start] and the [ModelDate] at the end as [end].
  ///
  /// フィールドを日付の範囲として定義します。
  ///
  /// 開始時の[ModelDate]を[start]、終了時の[ModelDate]を[end]として与えます。
  const factory ModelDateRange.fromModelDate({
    required ModelDate start,
    required ModelDate end,
  }) = _ModelDateRangeWithModelDate;

  /// Define the field as a range of timestamps.
  ///
  /// The [DateTime] at the start is given as [start] and the [DateTime] at the end as [end].
  ///
  /// フィールドを日付の範囲として定義します。
  ///
  /// 開始時の[DateTime]を[start]、終了時の[DateTime]を[end]として与えます。
  const factory ModelDateRange.fromDateTime({
    required DateTime start,
    required DateTime end,
  }) = _ModelDateRangeWithDateTime;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelDateRange.fromServer(DateTimeRange value) =
      _ModelDateRange.fromServer;

  /// Convert from [json] map to [ModelDateRange].
  ///
  /// [json]のマップから[ModelDateRange]に変換します。
  factory ModelDateRange.fromJson(DynamicMap json) {
    final start = json.get(
      kStartTimeKey,
      Clock.now().microsecondsSinceEpoch,
    );
    final end = json.get(
      kEndTimeKey,
      Clock.now().microsecondsSinceEpoch + 1,
    );
    return ModelDateRange.fromServer(
      DateTimeRange(
        start: DateTime.fromMicrosecondsSinceEpoch(start),
        end: DateTime.fromMicrosecondsSinceEpoch(end),
      ),
    );
  }

  const ModelDateRange._([
    DateTimeRange? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelDateRange";

  /// Key to save the start time.
  ///
  /// 開始時間を保存しておくキー。
  static const kStartTimeKey = "@start";

  /// Key to save the end time.
  ///
  /// 終了時間を保存しておくキー。
  static const kEndTimeKey = "@end";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  DateTimeRange get value {
    final now = _value ??
        DateTimeRange(
          start: Clock.now(),
          end: Clock.now().add(const Duration(days: 1)),
        );
    return DateTimeRange(
      start: Clock(
        now.start.year,
        now.start.month,
        now.start.day,
      ),
      end: Clock(
        now.end.year,
        now.end.month,
        now.end.day,
      ),
    );
  }

  final DateTimeRange? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelTimestampRange].
  ///
  /// [ModelTimestampRange]に変換します。
  ModelTimestampRange toModelTimestampRange() {
    return ModelTimestampRange(value);
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelDateRange.typeString,
        kStartTimeKey: value.start.microsecondsSinceEpoch,
        kEndTimeKey: value.end.microsecondsSinceEpoch,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(ModelDateRange other) {
    return value.toString().compareTo(other.value.toString());
  }
}

@immutable
class _ModelDateRangeWithModelDate extends _ModelDateRange {
  const _ModelDateRangeWithModelDate({
    required this.start,
    required this.end,
  }) : super();

  final ModelDate start;
  final ModelDate end;

  @override
  DateTimeRange? get _value {
    return DateTimeRange(
      start: start.value,
      end: end.value,
    );
  }
}

@immutable
class _ModelDateRangeWithDateTime extends _ModelDateRange {
  const _ModelDateRangeWithDateTime({
    required this.start,
    required this.end,
  }) : super();

  final DateTime start;
  final DateTime end;

  @override
  DateTimeRange? get _value {
    return DateTimeRange(
      start: start,
      end: end,
    );
  }
}

@immutable
class _ModelDateRange extends ModelDateRange
    with ModelFieldValueAsMapMixin<DateTimeRange> {
  const _ModelDateRange([
    super.value,
  ]) : super._();
  const _ModelDateRange.fromServer([DateTimeRange? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelDateRange] as [ModelFieldValue].
///
/// [ModelDateRange]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelDateRangeConverter extends ModelFieldValueConverter<ModelDateRange> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelDateRange] as [ModelFieldValue].
  ///
  /// [ModelDateRange]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelDateRangeConverter();

  @override
  String get type => ModelDateRange.typeString;

  @override
  ModelDateRange fromJson(Map<String, Object?> map) {
    return ModelDateRange.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelDateRange value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelDateRange] available to [ModelQuery.filters].
///
/// [ModelDateRange]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelDateRangeFilter extends ModelFieldValueFilter<ModelDateRange> {
  /// Filter class to make [ModelDateRange] available to [ModelQuery.filters].
  ///
  /// [ModelDateRange]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelDateRangeFilter();

  @override
  String get type => ModelDateRange.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
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
    T Function(DateTimeRange source, DateTimeRange target) filter,
  ) {
    if (source is ModelDateRange && target is ModelDateRange) {
      return filter(source.value, target.value);
    } else if (source is ModelDateRange && target is DateTimeRange) {
      return filter(source.value, target);
    } else if (source is DateTimeRange && target is ModelDateRange) {
      return filter(source, target.value);
    } else if (source is DateTimeRange && target is DateTimeRange) {
      return filter(source, target);
    } else if (source is ModelDateRange &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelDateRange.typeString) {
      return filter(source.value, ModelDateRange.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelDateRange &&
        source.get(kTypeFieldKey, "") == ModelDateRange.typeString) {
      return filter(ModelDateRange.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelDateRange.typeString &&
        target.get(kTypeFieldKey, "") == ModelDateRange.typeString) {
      return filter(ModelDateRange.fromJson(source).value,
          ModelDateRange.fromJson(target).value);
    }
    return null;
  }
}

/// Define the field as a time range.
///
/// The base value is given as [value].
///
/// フィールドを時刻の範囲として定義します。
///
/// ベースの値を[value]として与えます。
@immutable
class ModelTimeRange extends ModelFieldValue<DateTimeRange>
    implements Comparable<ModelTimeRange> {
  /// Define the field as a time range.
  ///
  /// The base value is given as [value]. If not given, the current time is set.
  ///
  /// フィールドを時刻の範囲として定義します。
  ///
  /// ベースの値を[value]として与えます。与えられなかった場合現在の時刻がセットされます。
  const factory ModelTimeRange(DateTimeRange value) = _ModelTimeRange;

  /// Define the field as a range of timestamps.
  ///
  /// The [ModelTime] at the start is given as [start] and the [ModelTime] at the end as [end].
  ///
  /// フィールドを時刻の範囲として定義します。
  ///
  /// 開始時の[ModelTime]を[start]、終了時の[ModelTime]を[end]として与えます。
  const factory ModelTimeRange.fromModelTime({
    required ModelTime start,
    required ModelTime end,
  }) = _ModelTimeRangeWithModelTime;

  /// Define the field as a range of timestamps.
  ///
  /// The [DateTime] at the start is given as [start] and the [DateTime] at the end as [end].
  ///
  /// フィールドを時刻の範囲として定義します。
  ///
  /// 開始時の[DateTime]を[start]、終了時の[DateTime]を[end]として与えます。
  const factory ModelTimeRange.fromDateTime({
    required DateTime start,
    required DateTime end,
  }) = _ModelTimeRangeWithDateTime;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelTimeRange.fromServer(DateTimeRange value) =
      _ModelTimeRange.fromServer;

  /// Convert from [json] map to [ModelTimeRange].
  ///
  /// [json]のマップから[ModelTimeRange]に変換します。
  factory ModelTimeRange.fromJson(DynamicMap json) {
    final start = json.get(
      kStartTimeKey,
      Clock.now().microsecondsSinceEpoch,
    );
    final end = json.get(
      kEndTimeKey,
      Clock.now().microsecondsSinceEpoch + 1,
    );
    return ModelTimeRange.fromServer(
      DateTimeRange(
        start: DateTime.fromMicrosecondsSinceEpoch(start),
        end: DateTime.fromMicrosecondsSinceEpoch(end),
      ),
    );
  }

  const ModelTimeRange._([
    DateTimeRange? value,
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelTimeRange";

  /// Key to save start time.
  ///
  /// 開始時間を保存しておくキー。
  static const kStartTimeKey = "@start";

  /// Key to save end time.
  ///
  /// 終了時間を保存しておくキー。
  static const kEndTimeKey = "@end";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  DateTimeRange get value {
    return _value ??
        DateTimeRange(
          start: Clock.now(),
          end: Clock.now().add(const Duration(hours: 1)),
        );
  }

  final DateTimeRange? _value;

  final ModelFieldValueSource _source;

  /// Convert to [ModelTimestamp]. The date will be [date], or January 1, 1970.
  ///
  /// [ModelTimestamp]に変換します。日付は[date]、もしくは1970年1月1日になります。
  ModelTimestampRange toModelTimestampRange([ModelDate? date]) {
    return ModelTimestampRange(
      DateTimeRange(
        start: Clock(
          date?.value.year ?? ModelTime._defaultYear,
          date?.value.month ?? ModelTime._defaultMonth,
          date?.value.day ?? ModelTime._defaultDay,
          value.start.hour,
          value.start.minute,
          value.start.second,
          value.start.millisecond,
          value.start.microsecond,
        ),
        end: Clock(
          date?.value.year ?? ModelTime._defaultYear,
          date?.value.month ?? ModelTime._defaultMonth,
          date?.value.day ?? ModelTime._defaultDay,
          value.end.hour,
          value.end.minute,
          value.end.second,
          value.end.millisecond,
          value.end.microsecond,
        ),
      ),
    );
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelTimeRange.typeString,
        kStartTimeKey: value.start.microsecondsSinceEpoch,
        kEndTimeKey: value.end.microsecondsSinceEpoch,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(ModelTimeRange other) {
    return value.toString().compareTo(other.value.toString());
  }
}

@immutable
class _ModelTimeRangeWithModelTime extends _ModelTimeRange {
  const _ModelTimeRangeWithModelTime({
    required this.start,
    required this.end,
  }) : super();

  final ModelTime start;
  final ModelTime end;

  @override
  DateTimeRange? get _value {
    return DateTimeRange(
      start: start.value,
      end: end.value,
    );
  }
}

@immutable
class _ModelTimeRangeWithDateTime extends _ModelTimeRange {
  const _ModelTimeRangeWithDateTime({
    required this.start,
    required this.end,
  }) : super();

  final DateTime start;
  final DateTime end;

  @override
  DateTimeRange? get _value {
    return DateTimeRange(
      start: start,
      end: end,
    );
  }
}

@immutable
class _ModelTimeRange extends ModelTimeRange
    with ModelFieldValueAsMapMixin<DateTimeRange> {
  const _ModelTimeRange([
    super.value,
  ]) : super._();
  const _ModelTimeRange.fromServer([DateTimeRange? value])
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelTimeRange] as [ModelFieldValue].
///
/// [ModelTimeRange]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelTimeRangeConverter extends ModelFieldValueConverter<ModelTimeRange> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelTimeRange] as [ModelFieldValue].
  ///
  /// [ModelTimeRange]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelTimeRangeConverter();

  @override
  String get type => ModelTimeRange.typeString;

  @override
  ModelTimeRange fromJson(Map<String, Object?> map) {
    return ModelTimeRange.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelTimeRange value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelTime] available to [ModelQuery.filters].
///
/// [ModelTime]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelTimeRangeFilter extends ModelFieldValueFilter<ModelTimeRange> {
  /// Filter class to make [ModelTimeRange] available to [ModelQuery.filters].
  ///
  /// [ModelTimeRange]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelTimeRangeFilter();

  @override
  String get type => ModelTimeRange.typeString;

  @override
  int? compare(dynamic a, dynamic b) {
    return _hasMatch(a, b, (a, b) => a.toString().compareTo(b.toString()));
  }

  @override
  bool? hasMatch(ModelQueryFilter filter, dynamic source) {
    final target = filter.value;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return _hasMatch(source, target, (source, target) => source == target);
      case ModelQueryFilterType.notEqualTo:
        return _hasMatch(source, target, (source, target) => source != target);
      case ModelQueryFilterType.lessThan:
      case ModelQueryFilterType.greaterThan:
      case ModelQueryFilterType.lessThanOrEqualTo:
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return null;
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
    T Function(DateTimeRange source, DateTimeRange target) filter,
  ) {
    if (source is ModelTimeRange && target is ModelTimeRange) {
      return filter(source.value, target.value);
    } else if (source is ModelTimeRange && target is DateTimeRange) {
      return filter(source.value, target);
    } else if (source is DateTimeRange && target is ModelTimeRange) {
      return filter(source, target.value);
    } else if (source is ModelTimeRange &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelTimeRange.typeString) {
      return filter(source.value, ModelTimeRange.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelTimeRange &&
        source.get(kTypeFieldKey, "") == ModelTimeRange.typeString) {
      return filter(ModelTimeRange.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelTimeRange.typeString &&
        target.get(kTypeFieldKey, "") == ModelTimeRange.typeString) {
      return filter(ModelTimeRange.fromJson(source).value,
          ModelTimeRange.fromJson(target).value);
    }
    return null;
  }
}

/// Define searchable fields.
///
/// You can store values as searchable values and search for elements that contain all of those defined in [ModelQueryFilter.equal].
///
/// Available for category search, etc.
///
/// 検索可能なフィールドを定義します。
///
/// 値を検索可能な値として保存し、[ModelQueryFilter.equal]で定義されたものがすべて含まれる要素を検索することができます。
///
/// カテゴリー検索等に利用可能です。
@immutable
class ModelSearch extends ModelFieldValue<List<String>>
    implements Comparable<ModelSearch> {
  /// Define searchable fields.
  ///
  /// You can store values as searchable values and search for elements that contain all of those defined in [ModelQueryFilter.equal].
  ///
  /// Available for category search, etc.
  ///
  /// 検索可能なフィールドを定義します。
  ///
  /// 値を検索可能な値として保存し、[ModelQueryFilter.equal]で定義されたものがすべて含まれる要素を検索することができます。
  ///
  /// カテゴリー検索等に利用可能です。
  const factory ModelSearch(List<String> searchList) = _ModelSearch;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelSearch.fromServer(List<String> searchList) =
      _ModelSearch.fromServer;

  /// Convert from [json] map to [ModelSearch].
  ///
  /// [json]のマップから[ModelSearch]に変換します。
  factory ModelSearch.fromJson(DynamicMap json) {
    final list = json.getAsList<String>(kListKey);
    return ModelSearch.fromServer(list);
  }

  const ModelSearch._(
    List<String> value, [
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelSearch";

  /// Key to save the list.
  ///
  /// リストを保存しておくキー。
  static const kListKey = "@list";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  List<String> get value => _value ?? [];
  final List<String>? _value;

  final ModelFieldValueSource _source;

  @override
  String toString() {
    return jsonEncode(value);
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelSearch.typeString,
        kListKey: value,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    if (_value == null) {
      return null.hashCode;
    }
    return Object.hashAll(_value!);
  }

  @override
  int compareTo(ModelSearch other) {
    return value.join().compareTo(other.value.join());
  }
}

@immutable
class _ModelSearch extends ModelSearch
    with ModelFieldValueAsMapMixin<List<String>> {
  const _ModelSearch(super.value) : super._();
  const _ModelSearch.fromServer(List<String> value)
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelSearch] as [ModelFieldValue].
///
/// [ModelSearch]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelSearchConverter extends ModelFieldValueConverter<ModelSearch> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelSearch] as [ModelFieldValue].
  ///
  /// [ModelSearch]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelSearchConverter();

  @override
  String get type => ModelSearch.typeString;

  @override
  ModelSearch fromJson(Map<String, Object?> map) {
    return ModelSearch.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelSearch value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelSearch] available to [ModelQuery.filters].
///
/// [ModelSearch]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelSearchFilter extends ModelFieldValueFilter<ModelSearch> {
  /// Filter class to make [ModelSearch] available to [ModelQuery.filters].
  ///
  /// [ModelSearch]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelSearchFilter();

  @override
  String get type => ModelSearch.typeString;

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
    if (source is ModelSearch && target is ModelSearch) {
      return filter(source.value, target.value);
    } else if (source is ModelSearch && target is List) {
      return filter(source.value, target.map((e) => e.toString()).toList());
    } else if (source is List && target is ModelSearch) {
      return filter(source.map((e) => e.toString()).toList(), target.value);
    } else if (source is ModelSearch && target is String) {
      return filter(source.value, [target]);
    } else if (source is String && target is ModelSearch) {
      return filter([source], target.value);
    } else if (source is ModelSearch &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelSearch.typeString) {
      return filter(source.value, ModelSearch.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelSearch &&
        source.get(kTypeFieldKey, "") == ModelSearch.typeString) {
      return filter(ModelSearch.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelSearch.typeString &&
        target.get(kTypeFieldKey, "") == ModelSearch.typeString) {
      return filter(ModelSearch.fromJson(source).value,
          ModelSearch.fromJson(target).value);
    }
    return null;
  }
}

/// Class for storing multiple tokens.
///
/// Can be used for token management of PUSH notifications, etc.
///
/// 複数トークンを保存するためのクラス。
///
/// PUSH通知のトークン管理等に利用可能です。
@immutable
class ModelToken extends ModelFieldValue<List<String>>
    implements Comparable<ModelToken> {
  /// Class for storing multiple tokens.
  ///
  /// Can be used for token management of PUSH notifications, etc.
  ///
  /// 複数トークンを保存するためのクラス。
  ///
  /// PUSH通知のトークン管理等に利用可能です。
  const factory ModelToken(List<String> tokenList) = _ModelToken;

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const factory ModelToken.fromServer(List<String> tokenList) =
      _ModelToken.fromServer;

  /// Convert from [json] map to [ModelToken].
  ///
  /// [json]のマップから[ModelToken]に変換します。
  factory ModelToken.fromJson(DynamicMap json) {
    final list = json.getAsList<String>(kListKey);
    return ModelToken.fromServer(list);
  }

  const ModelToken._(
    List<String> value, [
    ModelFieldValueSource source = ModelFieldValueSource.user,
  ])  : _value = value,
        _source = source;

  /// Type key.
  ///
  /// タイプのキー。
  static const typeString = "ModelToken";

  /// Key to save the list.
  ///
  /// リストを保存しておくキー。
  static const kListKey = "@list";

  /// Key to store the data source.
  ///
  /// データソースを保存しておくキー。
  static const kSourceKey = "@source";

  @override
  List<String> get value => _value ?? [];
  final List<String>? _value;

  final ModelFieldValueSource _source;

  /// Register a new [token].
  ///
  /// 新しい[token]を登録します。
  void add(String token) {
    if (_value == null) {
      return;
    }
    if (!_value!.contains(token)) {
      _value!.add(token);
    }
  }

  /// Delete [token].
  ///
  /// [token]を削除します。
  void remove(String token) {
    if (_value == null) {
      return;
    }
    _value!.remove(token);
  }

  /// Delete all tokens.
  ///
  /// トークンをすべて削除します。
  void clear() {
    if (_value == null) {
      return;
    }
    _value!.clear();
  }

  @override
  String toString() {
    return jsonEncode(value);
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: ModelToken.typeString,
        kListKey: value,
        kSourceKey: _source.name,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    if (_value == null) {
      return null.hashCode;
    }
    return Object.hashAll(_value!);
  }

  @override
  int compareTo(ModelToken other) {
    return value.join().compareTo(other.value.join());
  }
}

@immutable
class _ModelToken extends ModelToken
    with ModelFieldValueAsMapMixin<List<String>> {
  const _ModelToken(super.value) : super._();
  const _ModelToken.fromServer(List<String> value)
      : super._(value, ModelFieldValueSource.server);
}

/// [ModelFieldValueConverter] to enable automatic conversion of [ModelToken] as [ModelFieldValue].
///
/// [ModelToken]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
@immutable
class ModelTokenConverter extends ModelFieldValueConverter<ModelToken> {
  /// [ModelFieldValueConverter] to enable automatic conversion of [ModelToken] as [ModelFieldValue].
  ///
  /// [ModelToken]を[ModelFieldValue]として自動変換できるようにするための[ModelFieldValueConverter]。
  const ModelTokenConverter();

  @override
  String get type => ModelToken.typeString;

  @override
  ModelToken fromJson(Map<String, Object?> map) {
    return ModelToken.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelToken value) {
    return value.toJson();
  }
}

/// Filter class to make [ModelToken] available to [ModelQuery.filters].
///
/// [ModelToken]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
@immutable
class ModelTokenFilter extends ModelFieldValueFilter<ModelToken> {
  /// Filter class to make [ModelToken] available to [ModelQuery.filters].
  ///
  /// [ModelToken]を[ModelQuery.filters]で利用できるようにするためのフィルタークラス。
  const ModelTokenFilter();

  @override
  String get type => ModelToken.typeString;

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
    if (source is ModelToken && target is ModelToken) {
      return filter(source.value, target.value);
    } else if (source is ModelToken && target is List) {
      return filter(source.value, target.map((e) => e.toString()).toList());
    } else if (source is List && target is ModelToken) {
      return filter(source.map((e) => e.toString()).toList(), target.value);
    } else if (source is ModelToken && target is String) {
      return filter(source.value, [target]);
    } else if (source is String && target is ModelToken) {
      return filter([source], target.value);
    } else if (source is ModelToken &&
        target is DynamicMap &&
        target.get(kTypeFieldKey, "") == ModelToken.typeString) {
      return filter(source.value, ModelToken.fromJson(target).value);
    } else if (source is DynamicMap &&
        target is ModelToken &&
        source.get(kTypeFieldKey, "") == ModelToken.typeString) {
      return filter(ModelToken.fromJson(source).value, target.value);
    } else if (source is DynamicMap &&
        target is DynamicMap &&
        source.get(kTypeFieldKey, "") == ModelToken.typeString &&
        target.get(kTypeFieldKey, "") == ModelToken.typeString) {
      return filter(
          ModelToken.fromJson(source).value, ModelToken.fromJson(target).value);
    }
    return null;
  }
}
