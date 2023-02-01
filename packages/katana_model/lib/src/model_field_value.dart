part of katana_model;

/// Use this when registering special classes in [ModelFieldValue].
///
/// Create a new class that inherits from this abstract class and register it with [ModelFieldValue.registerConverter] when the application starts.
///
/// [ModelFieldValue]に特殊なクラスを登録する場合に利用します。
///
/// この抽象クラスを継承して新しいクラスを作り、アプリ起動時に[ModelFieldValue.registerConverter]に登録を行ってください。
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
  Type get type => T;

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
    const ModelCounterConverter(),
    const ModelTimestampConverter(),
    const ModelRefConverter(),
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
        final conveter =
            _converters.firstWhereOrNull((e) => e.type.toString() == type);
        if (conveter != null) {
          res[key] = conveter.fromJson(val);
        } else {
          res[key] = val;
        }
      } else {
        res[key] = val;
      }
    }
    return Map.unmodifiable(
      Map<String, dynamic>.fromEntries(
        res.entries.where((entry) => !entry.key.startsWith("@")),
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
      final conveter = _converters.firstWhereOrNull((e) => e.check(val));
      if (conveter != null) {
        res[key] = conveter.toJson(val);
      } else {
        res[key] = val;
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
abstract class ModelFieldValueAsMapMixin<T>
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
      return ModelTimestamp(defaultValue ?? DateTime.now());
    }
    return this[key] as ModelTimestamp;
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
class ModelCounter extends ModelFieldValue<int> {
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

  /// Convert from [json] map to [ModelCounter].
  ///
  /// [json]のマップから[ModelCounter]に変換します。
  factory ModelCounter.fromJson(DynamicMap json) {
    return ModelCounter(
      json.getAsInt(_kValueKey),
    );
  }

  const ModelCounter._(int value, int increment)
      : _value = value,
        _increment = increment;

  static const _kValueKey = "@value";
  static const _kIncrementKey = "@increment";

  final int _value;

  final int _increment;

  /// Obtains the increase/decrease value.
  ///
  /// 増減値を取得します。
  int get incrementValue => _increment;

  /// Increase or decrease the value with [val].
  ///
  /// 値を[val]で増減します。
  ModelCounter increment(int val) {
    return ModelCounter._(_value, val);
  }

  @override
  int get value => _value + _increment;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: (ModelCounter).toString(),
        _kValueKey: value,
        _kIncrementKey: incrementValue,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode ^ _increment.hashCode;
}

@immutable
class _ModelCounter extends ModelCounter with ModelFieldValueAsMapMixin<int> {
  const _ModelCounter(int value) : super._(value, 0);
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
  ModelCounter fromJson(Map<String, Object?> map) {
    return ModelCounter.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelCounter value) {
    return value.toJson();
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
class ModelTimestamp extends ModelFieldValue<DateTime> {
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

  /// Convert from [json] map to [ModelTimestamp].
  ///
  /// [json]のマップから[ModelTimestamp]に変換します。
  factory ModelTimestamp.fromJson(DynamicMap json) {
    final timestamp = json.get(
      _kTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    return ModelTimestamp(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  const ModelTimestamp._([DateTime? value]) : _value = value;

  static const _kTimeKey = "@time";

  @override
  DateTime get value => _value ?? DateTime.now();
  final DateTime? _value;

  @override
  String toString() {
    return value.toString();
  }

  @override
  DynamicMap toJson() => {
        kTypeFieldKey: (ModelTimestamp).toString(),
        _kTimeKey: value.millisecondsSinceEpoch,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;
}

@immutable
class _ModelTimestamp extends ModelTimestamp
    with ModelFieldValueAsMapMixin<DateTime> {
  const _ModelTimestamp([DateTime? value]) : super._(value);
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
  ModelTimestamp fromJson(Map<String, Object?> map) {
    return ModelTimestamp.fromJson(map);
  }

  @override
  Map<String, Object?> toJson(ModelTimestamp value) {
    return value.toJson();
  }
}
