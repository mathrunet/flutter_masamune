part of katana_model;

/// Class for defining special field values.
/// 特殊なフィールド値を定義するためのクラス。
///
/// The [value] of type [T] is the actual value.
/// [T]型の[value]が実際の値となります。
///
/// [ModelFieldValue.fromServer] executes the process of converting the data read from the server and [ModelFieldValue.toServer] executes the process of converting the data to be saved to the server.
/// [ModelFieldValue.fromServer]でサーバーから読み取られたデータを変換する処理を実行し、[ModelFieldValue.toServer]でサーバーへ保存するデータを変換する処理を実行します。
@immutable
abstract class ModelFieldValue<T> {
  /// Class for defining special field values.
  /// 特殊なフィールド値を定義するためのクラス。
  ///
  /// The [value] of type [T] is the actual value.
  /// [T]型の[value]が実際の値となります。
  ///
  /// [ModelFieldValue.fromServer] executes the process of converting the data read from the server and [ModelFieldValue.toServer] executes the process of converting the data to be saved to the server.
  /// [ModelFieldValue.fromServer]でサーバーから読み取られたデータを変換する処理を実行し、[ModelFieldValue.toServer]でサーバーへ保存するデータを変換する処理を実行します。
  const ModelFieldValue();
  static final _regexp = RegExp(r"<[^>]+>");

  /// Actual value.
  /// 実際の値。
  T get value;

  /// Performs the process of converting data read from the server.
  /// サーバーから読み取られたデータを変換する処理を実行します。
  ///
  /// Pass the model adapter currently in use to [adapter] and the data read from the server to [value].
  /// [adapter]に現在使用中のモデルアダプターを[value]にサーバーから読み取られたデータを渡します。
  ///
  /// The converted data is passed to the return value.
  /// 戻り値に変換後のデータが渡されます。
  static DynamicMap fromServer(ModelAdapter adapter, DynamicMap value) {
    final res = <String, dynamic>{};
    final types = value.getAsMap(kTypeFieldKey);
    if (types.isEmpty) {
      return value;
    } else {
      for (final entry in types.entries) {
        final key = entry.key;
        final type = entry.value.toString();
        final val = value[key];
        switch (type) {
          case "ModelCounter":
            final o = adapter.toModelCounter(val);
            if (o != null) {
              res[key] = o;
            }
            break;
          case "ModelTimestamp":
            final o = adapter.toModelTimestamp(val);
            if (o != null) {
              res[key] = o;
            }
            break;
          case "ModelReference":
            final o = adapter.toModelReference(val);
            if (o != null) {
              res[key] = o;
            }
            break;
          default:
            final o = jsonEncodable(val)
                ? adapter.toJsonEncodable(val)
                : adapter.toNotJsonEncodable(val);
            if (o != null) {
              res[key] = o;
            }
            break;
        }
      }
    }
    return res;
  }

  /// Executes the process of converting data to be stored on the server.
  /// サーバーへ保存するデータを変換する処理を実行します。
  ///
  /// Pass the model adapter currently in use to [adapter] and the data to be saved to the server to [value].
  /// [adapter]に現在使用中のモデルアダプターを[value]にサーバーへ保存するデータを渡します。
  ///
  /// The converted data is passed to the return value.
  /// 戻り値に変換後のデータが渡されます。
  static DynamicMap toServer(ModelAdapter adapter, DynamicMap value) {
    final types = value.keys.where((key) => !key.startsWith("@")).toMap(
          (key) => MapEntry(
            key,
            value[key].runtimeType.toString().replaceAll(_regexp, ""),
          ),
        );
    return {
      ...value.map((key, val) {
        if (val is ModelCounter) {
          return MapEntry(key, adapter.fromModelCounter(val));
        } else if (val is ModelTimestamp) {
          return MapEntry(key, adapter.fromModelTimestamp(val));
        } else if (val is ModelReference) {
          return MapEntry(key, adapter.fromModelReference(val));
        } else if (jsonEncodable(val)) {
          return MapEntry(key, adapter.fromJsonEncodable(val));
        } else {
          return MapEntry(key, adapter.fromNotJsonEncodable(val));
        }
      }),
      kTypeFieldKey: types,
    };
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

  ModelReference<T> getAsModelReference<T>(String key, String defaultPath) {
    if (!containsKey(key) || this[key] is! ModelReference<T>) {
      return ModelReference<T>(defaultPath);
    }
    return this[key] as ModelReference<T>;
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
  const ModelCounter._(int value, int increment)
      : _value = value,
        _increment = increment;

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

  @override
  DateTime get value => _value ?? DateTime.now();
  final DateTime? _value;

  @override
  String toString() {
    return value.toString();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => _value.hashCode;
}

@immutable
class ModelReference<T> extends ModelFieldValue<T?> {
  const ModelReference(this.path, [this.value]);

  factory ModelReference.fromReferenceUrl(String url) {
    assert(url.startsWith("ref://"), "The [url] must begin with ref://.");
    return ModelReference(url.replaceFirst("ref://", ""));
  }

  final String path;
  @override
  final T? value;

  ModelReference<T> copyWith(T value) {
    return ModelReference(path, value);
  }

  String get referenceUrl => "ref://${path.trimQuery().trimString("/")}";

  @override
  String toString() {
    return path;
  }
}
