part of katana_model;

/// Class for defining special field values.
/// 特殊なフィールド値を定義するためのクラス。
///
/// The [value] of type [T] is the actual value.
/// [T]型の[value]が実際の値となります。
abstract class ModelFieldValue<T> {
  /// Class for defining special field values.
  /// 特殊なフィールド値を定義するためのクラス。
  ///
  /// The [value] of type [T] is the actual value.
  /// [T]型の[value]が実際の値となります。
  ///
  /// [ModelFieldValue.fromMap] executes the process of converting the data read from the server and [ModelFieldValue.toMap] executes the process of converting the data to be saved to the server.
  /// [ModelFieldValue.fromMap]でサーバーから読み取られたデータを変換する処理を実行し、[ModelFieldValue.toMap]でサーバーへ保存するデータを変換する処理を実行します。
  const ModelFieldValue();

  /// Actual value.
  /// 実際の値。
  T get value;

  /// Methods for Json serialization.
  /// Jsonシリアライズを行うためのメソッド。
  ///
  /// Used to convert [ModelFieldValue] values to Json in the `json_serializable` package.
  /// `json_serializable`のパッケージで[ModelFieldValue]の値をJsonに変換する際に利用します。
  DynamicMap toJson();

  /// Performs the process of converting data read from the server.
  /// サーバーから読み取られたデータを変換する処理を実行します。
  ///
  /// Pass the data read from the server to [value].
  /// [value]にサーバーから読み取られたデータを渡します。
  ///
  /// The converted data is passed to the return value.
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
  /// サーバーへ保存するデータを変換する処理を実行します。
  ///
  /// The data to be saved to the server is passed to [value].
  /// [value]にサーバーへ保存するデータを渡します。
  ///
  /// The converted data is passed to the return value.
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
/// ModelFieldValue用の[DynamicMap]の拡張メソッドを提供します。
extension DynamicMapModelFieldValueExtensions on DynamicMap {
  /// Retrieves the element of [key] of type [ModelCounter] from [Map].
  /// [Map]から[ModelCounter]型の[key]の要素を取得します。
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelCounter], [ModelCounter] whose value is [defaultValue] is returned.
  /// [Map]に[key]の要素がない場合や[ModelCounter]と型が合わない場合、[defaultValue]が値となる[ModelCounter]が返されます。
  ModelCounter getAsModelCounter(String key, [int defaultValue = 0]) {
    if (!containsKey(key) || this[key] is! ModelCounter) {
      return ModelCounter(defaultValue);
    }
    return this[key] as ModelCounter;
  }

  /// Retrieves the element of [key] of type [ModelTimestamp] from [Map].
  /// [Map]から[ModelTimestamp]型の[key]の要素を取得します。
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelTimestamp], [ModelTimestamp] whose value is [defaultValue] is returned.
  /// [Map]に[key]の要素がない場合や[ModelTimestamp]と型が合わない場合、[defaultValue]が値となる[ModelTimestamp]が返されます。
  ModelTimestamp getAsModelTimestamp(String key, [DateTime? defaultValue]) {
    if (!containsKey(key) || this[key] is! ModelTimestamp) {
      return ModelTimestamp(defaultValue ?? DateTime.now());
    }
    return this[key] as ModelTimestamp;
  }

  /// Retrieves the element of [key] of type [ModelRef] from [Map].
  /// [Map]から[ModelRef]型の[key]の要素を取得します。
  ///
  /// If there is no element of [key] in [Map] or the type does not match [ModelRef], [ModelTimestamp] whose value is [defaultPath] is returned.
  /// [Map]に[key]の要素がない場合や[ModelRef]と型が合わない場合、[defaultPath]が値となる[ModelRef]が返されます。
  ModelRef<T> getAsModelRef<T>(String key, String defaultPath) {
    if (!containsKey(key) || this[key] is! ModelRef<T>) {
      return ModelRef<T>.fromPath(defaultPath);
    }
    return this[key] as ModelRef<T>;
  }
}

/// Define the field as a counter.
/// フィールドをカウンターとして定義します。
///
/// The base value is given as [value], and the value is increased or decreased by [increment].
/// ベースの値を[value]として与え、[increment]で値を増減していきます。
///
/// By passing this to the server, it is possible to stably increase or decrease the value.
/// これをサーバーに渡すことで安定して値の増減を行うことができます。
@immutable
class ModelCounter extends ModelFieldValue<int> {
  /// Define the field as a counter.
  /// フィールドをカウンターとして定義します。
  ///
  /// The base value is given as [value], and the value is increased or decreased by [increment].
  /// ベースの値を[value]として与え、[increment]で値を増減していきます。
  ///
  /// By passing this to the server, it is possible to stably increase or decrease the value.
  /// これをサーバーに渡すことで安定して値の増減を行うことができます。
  const ModelCounter(int value)
      : _value = value,
        _increment = 0;

  /// Convert from [json] map to [ModelCounter].
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
  /// [ModelCounter]のタイプの文字列。
  static const typeString = "ModelCounter";

  static const _kValueKey = "@value";
  static const _kIncrementKey = "@increment";

  final int _value;

  final int _increment;

  /// Obtains the increase/decrease value.
  /// 増減値を取得します。
  int get incrementValue => _increment;

  /// Increase or decrease the value with [val].
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
/// フィールドをタイムスタンプとして定義します。
///
/// The base value is given as [value]. If not given, the current time is set.
/// ベースの値を[value]として与えます。与えられなかった場合現在時刻がセットされます。
///
/// By passing this to the server, the timestamp on the server side is stored as data.
/// これをサーバーに渡すことでサーバー側のタイムスタンプをデータとして保存されます。
@immutable
class ModelTimestamp extends ModelFieldValue<DateTime> {
  /// Define the field as a timestamp.
  /// フィールドをタイムスタンプとして定義します。
  ///
  /// The base value is given as [value]. If not given, the current time is set.
  /// ベースの値を[value]として与えます。与えられなかった場合現在時刻がセットされます。
  ///
  /// By passing this to the server, the timestamp on the server side is stored as data.
  /// これをサーバーに渡すことでサーバー側のタイムスタンプをデータとして保存されます。
  const ModelTimestamp([DateTime? value]) : _value = value;

  /// Convert from [json] map to [ModelTimestamp].
  /// [json]のマップから[ModelTimestamp]に変換します。
  factory ModelTimestamp.fromJson(DynamicMap json) {
    final timestamp = json.get(
      _kTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    return ModelTimestamp(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  /// A string of type [ModelTimestamp].
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

/// Class for defining relationships between models.
/// モデル間のリレーションを定義するためのクラス。
///
/// You can have that relationship as data by passing a query for the related document to [query].
/// [query]に関連するドキュメントのクエリーを渡すことでそのリレーションをデータとして持つことができます。
///
/// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRef] and mixing in [ModelRefMixin].
/// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRef]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
class ModelRef<T> extends ModelFieldValue<T?> {
  /// Class for defining relationships between models.
  /// モデル間のリレーションを定義するためのクラス。
  ///
  /// You can have that relationship as data by passing a query for the related document to [query].
  /// [query]に関連するドキュメントのクエリーを渡すことでそのリレーションをデータとして持つことができます。
  ///
  /// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRef] and mixing in [ModelRefMixin].
  /// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRef]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
  ModelRef(this.query);

  /// Class for defining relationships between models.
  /// モデル間のリレーションを定義するためのクラス。
  ///
  /// By passing the path of the related document in [path], you can have that relationship as data.
  /// [path]に関連するドキュメントのパスを渡すことでそのリレーションをデータとして持つことができます。
  ///
  /// It is also possible to set a model adapter by specifying [adapter].
  /// また[adapter]を指定してモデルアダプターを設定することが可能です。
  ///
  /// Since it is a mutable class and has an interface to [DocumentBase], it can be replaced by [DocumentBase] by implementing [ModelRef] and mixing in [ModelRefMixin].
  /// ミュータブルクラスでかつ[DocumentBase]のインターフェースを備えているため[ModelRef]を実装し、[ModelRefMixin]をミックスインすることで[DocumentBase]で置き換えることが可能です。
  factory ModelRef.fromPath(String path, [ModelAdapter? adapter]) {
    return ModelRef(
      DocumentModelQuery(
        path.trimQuery().trimString("/"),
        adapter: adapter,
      ),
    );
  }

  /// Convert from [json] map to [ModelRef].
  /// [json]のマップから[ModelRef]に変換します。
  factory ModelRef.fromJson(Map<String, dynamic> json) {
    return ModelRef.fromPath(json.get(_kRefKey, ""));
  }

  /// A string of type [ModelRef].
  /// [ModelRef]のタイプの文字列。
  static const typeString = "ModelRef";

  /// [DocumentModelQuery] of the associated document.
  /// 関連するドキュメントの[DocumentModelQuery].
  final DocumentModelQuery query;

  static const _kRefKey = "@ref";

  @override
  Map<String, dynamic> toJson() => {
        kTypeFieldKey: runtimeType.toString(),
        _kRefKey: query.path.trimQuery().trimString("/"),
      };

  /// Actual value.
  /// 実際の値。
  ///
  /// [Null] is returned.
  /// [Null]が返されます。
  @override
  T? get value {
    return null;
  }

  /// Actual value.
  /// 実際の値。
  ///
  /// Set is not supported.
  /// セットすることはサポートされていません。
  set value(T? value) {
    throw UnsupportedError("Value cannot be set.");
  }

  @override
  String toString() {
    return query.path;
  }
}

/// A mix-in to define that it is a relationship between models in [DocumentBase], etc.
/// [DocumentBase]などにモデル間のリレーションであるということを定義するためのミックスイン。
abstract class ModelRefMixin<T> implements ModelRef<T> {
  @override
  Map<String, dynamic> toJson() => {
        kTypeFieldKey: runtimeType.toString(),
        ModelRef._kRefKey: query.path.trimQuery().trimString("/"),
      };
}
