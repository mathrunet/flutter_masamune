part of '/katana_value.dart';

/// {@template macro_json_converter}
/// You can register classes that perform the conversion to Json with `fromJson` and `toJson` in [DataValue].
///
/// 1. Create a converter by inheriting from [DataValueJsonConverter].
///   - Return a value only if it is a class that corresponds to `toJson` or `fromJson`, otherwise return [Null].
/// 2. Call `DataValueJsonConverter.register` in the main method or other methods to register the converter.
/// 3. The converter is automatically called if there is a target class registered in the [DataValue] field.
///
/// [DataValue]の`fromJson`、`toJson`でJsonへの変換を行うクラスを登録することができます。
///
/// 1. [DataValueJsonConverter]を継承しコンバーターを作成します。
///   - `toJson`や`fromJson`で該当するクラスの場合のみ値を返しそれ以外は[Null]を返すようにします。
/// 2. mainメソッドなどで`DataValueJsonConverter.register`を呼び出しコンバーターを登録します。
/// 3. [DataValue]のフィールドに登録した対象のクラスがある場合、自動的にコンバーターが呼び出されます。
///
/// ```dart
/// class PersonBaseConverter extends DataValueJsonConverter {
///   const PersonBaseConverter();
///
///   @override
///   Map<String, dynamic>? toJson(dynamic value) {
///     if (value is PersonBase) {
///       return value.toJson();
///     }
///     return null;
///   }
///
///   @override
///   dynamic fromJson(String key, Map<String, dynamic> json) {
///     final map = json[key];
///     if(map is Map<String, Object?> && map["#type"] == "ModelCounter") {
///       return PersonBase.fromJson(map);
///     }
///     return null;
///   }
/// }
///
/// @DataValue()
/// class Person {
///   const Person({
///     PersonBase? personBase,
///   });
/// }
///
/// class PersonBase {
///   const PersonBase({
///     required this.name,
///   });
///   final String? name;
///
///   factory PersonBase.fromJson(Map<String, Object?> json) {
///     return PersonBase(
///       name: json["name"] as String?,
///     );
///   }
///
///   Map<String, Object?> toJson() {
///     return {
///       "name": name,
///     };
///   }
/// }
///
/// void main() {
///   DataValueJsonConverter.register(const PersonBaseConverter());
///   const person = Person(personBase: PersonBase(name: "aaa"));
///   final json = person.toJson(); // {"person": {"name": "aaa"}}
/// }
/// ```
/// {@endtemplate}
abstract class DataValueJsonConverter {
  /// {@macro macro_json_converter}
  const DataValueJsonConverter();

  static final _converters = <DataValueJsonConverter>{};

  /// Register a new [DataValueJsonConverter].
  ///
  /// [DataValueJsonConverter]を新しく登録します。
  ///
  /// {@macro macro_json_converter}
  static void register(DataValueJsonConverter converter) {
    _converters.add(converter);
  }

  /// Register multiple new [DataValueJsonConverter].
  ///
  /// 複数の[DataValueJsonConverter]を新しく登録します。
  ///
  /// {@macro macro_json_converter}
  static void registerAll(List<DataValueJsonConverter> converters) {
    _converters.addAll(converters);
  }

  /// Unregister a [DataValueJsonConverter].
  ///
  /// [DataValueJsonConverter]を登録解除します。
  ///
  /// {@macro macro_json_converter}
  static void unregister(DataValueJsonConverter converter) {
    _converters.remove(converter);
  }

  /// Converts [value] to Json. This is used internally and is not called directly.
  ///
  /// [value]をJsonに変換します。こちらは内部で利用されるため直接呼び出すことはありません。
  static Map<String, dynamic>? convertTo(dynamic value) {
    for (final converter in _converters) {
      final json = converter.toJson(value);
      if (json != null) {
        return json;
      }
    }
    return null;
  }

  /// Converts the value of [key] in [json]. This is used internally and is not called directly.
  ///
  /// [json]の中にある[key]の値を変換します。これは内部で利用されるため直接呼び出すことはありません。
  static dynamic convertFrom(String key, Map<String, Object?> json) {
    for (final converter in _converters) {
      final val = converter.fromJson(key, json);
      if (val != null) {
        return val;
      }
    }
    return null;
  }

  /// Convert [value] to Json.
  ///
  /// Return [Null] if not of the corresponding type.
  ///
  /// [value]をJsonに変換します。
  ///
  /// 対応する型ではない場合は[Null]を返してください。
  Map<String, dynamic>? toJson(dynamic value);

  /// Convert the value of [key] in [json].
  ///
  /// Return [Null] if not of the corresponding type.
  ///
  /// [json]の中にある[key]の値を変換します。
  ///
  /// 対応する型ではない場合は[Null]を返してください。
  dynamic fromJson(String key, Map<String, Object?> json);
}
