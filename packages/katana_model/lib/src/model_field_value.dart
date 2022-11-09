part of katana_model;

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

  /// Actual value.
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
      if (val is DynamicMap && val.containsKey(kTypeFieldKey)) {
        final type = val.get(kTypeFieldKey, "");
        if (type == ModelCounter.typeString) {
          res[key] = ModelCounter.fromJson(val);
        } else if (type == ModelTimestamp.typeString) {
          res[key] = ModelTimestamp.fromJson(val);
        } else if (type.startsWith(ModelRef.typeString)) {
          res[key] = ModelRef.fromJson(val);
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
      switch (val.runtimeType) {
        case ModelCounter:
          res[key] = val.toJson();
          break;
        case ModelTimestamp:
          res[key] = val.toJson();
          break;
        case ModelRef:
          res[key] = val.toJson();
          break;
        default:
          res[key] = val;
          break;
      }
    }
    return Map.unmodifiable(res);
  }
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

  /// Retrieves the element of [key] of type [ModelRef] from [Map].
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelRef], [ModelTimestamp] whose value is [defaultPath] is returned.
  ///
  /// [Map]から[ModelRef]型の[key]の要素を取得します。
  ///
  /// [Map]に[key]の要素がない場合や[ModelRef]と型が合わない場合、[defaultPath]が値となる[ModelRef]が返されます。
  ModelRef<T> getAsModelRef<T>(String key, String defaultPath) {
    if (!containsKey(key) || this[key] is! ModelRef<T>) {
      return ModelRef<T>.fromPath(defaultPath);
    }
    return this[key] as ModelRef<T>;
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
  const ModelCounter(int value)
      : _value = value,
        _increment = 0;

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

  /// A string of type [ModelCounter].
  ///
  /// [ModelCounter]のタイプの文字列。
  static const typeString = "ModelCounter";

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
        kTypeFieldKey: runtimeType.toString(),
        _kValueKey: value,
        _kIncrementKey: incrementValue,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => value.hashCode;
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
  const ModelTimestamp([DateTime? value]) : _value = value;

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

  /// A string of type [ModelTimestamp].
  ///
  /// [ModelTimestamp]のタイプの文字列。
  static const typeString = "ModelTimestamp";

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
        kTypeFieldKey: runtimeType.toString(),
        _kTimeKey: value.millisecondsSinceEpoch,
      };

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;
}
