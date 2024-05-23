part of '/katana_value.dart';

/// Types that can be treated as Json in macros.
///
/// マクロ内でJsonとして扱うことが可能な型。
enum MacroType {
  /// bool.
  ///
  /// bool。
  bool,

  /// num.
  ///
  /// num。
  num$,

  /// int.
  ///
  /// int。
  int,

  /// double.
  ///
  /// double。
  double,

  /// String.
  ///
  /// String。
  string,

  /// Iterable.
  ///
  /// Iterable。
  iterable,

  /// List.
  ///
  /// List。
  list,

  /// Map.
  ///
  /// Map。
  map,

  /// Set.
  ///
  /// Set。
  set,

  /// enum.
  ///
  /// enum。
  enum$,

  /// ModelCounter.
  ///
  /// ModelCounter。
  modelCounter,

  /// ModelDate.
  ///
  /// ModelDate。
  modelDate,

  /// ModelTimestamp.
  ///
  /// ModelTimestamp。
  modelTimestamp,

  /// ModelLocale.
  ///
  /// ModelLocale。
  modelLocale,

  /// ModelLocalized.
  ///
  /// ModelLocalized。
  modelLocalized,

  /// ModelUri.
  ///
  /// ModelUri。
  modelUri,

  /// ModelImageUri.
  ///
  /// ModelImageUri。
  modelImageUri,

  /// ModelVideoUri.
  ///
  /// ModelVideoUri。
  modelVideoUri,

  /// ModelSearch.
  ///
  /// ModelSearch。
  modelSearch,

  /// ModelToken.
  ///
  /// ModelToken。
  modelToken,

  /// ModelGeoValue.
  ///
  /// ModelGeoValue。
  modelGeoValue,

  /// ModelRef.
  ///
  /// ModelRef。
  modelRef;

  /// Create a [MacroType] from [MacroTypeValue].
  ///
  /// Returns [Null] if not applicable.
  ///
  /// [MacroTypeValue]から[MacroType]を取得します。
  ///
  /// 該当しない場合[Null]を返します。
  static MacroType? fromMacroTypeValue(MacroTypeValue value) {
    final unnullable = value.toNonNullable().toString();
    switch (unnullable) {
      case "bool":
        return MacroType.bool;
      case "num":
        return MacroType.num$;
      case "int":
        return MacroType.int;
      case "double":
        return MacroType.double;
      case "String":
        return MacroType.string;
      case "Iterable":
        return MacroType.iterable;
      case "List":
        return MacroType.list;
      case "Map":
        return MacroType.map;
      case "Set":
        return MacroType.set;
      case "enum":
        return MacroType.enum$;
      case "ModelCounter":
        return MacroType.modelCounter;
      case "ModelDate":
        return MacroType.modelDate;
      case "ModelTimestamp":
        return MacroType.modelTimestamp;
      case "ModelLocale":
        return MacroType.modelLocale;
      case "ModelLocalized":
        return MacroType.modelLocalized;
      case "ModelUri":
        return MacroType.modelUri;
      case "ModelImageUri":
        return MacroType.modelImageUri;
      case "ModelVideoUri":
        return MacroType.modelVideoUri;
      case "ModelSearch":
        return MacroType.modelSearch;
      case "ModelToken":
        return MacroType.modelToken;
      case "ModelGeoValue":
        return MacroType.modelGeoValue;
      case "ModelRef":
        return MacroType.modelRef;
      default:
        if (unnullable.startsWith("Iterable<")) {
          return MacroType.iterable;
        } else if (unnullable.startsWith("List<")) {
          return MacroType.list;
        } else if (unnullable.startsWith("Map<")) {
          return MacroType.map;
        } else if (unnullable.startsWith("Set<")) {
          return MacroType.set;
        }
        return MacroType.enum$;
    }
  }

  /// Converts to and returns a string for the `fromJson` method.
  /// 
  /// `fromJson`メソッド用の文字列に変換して返します。
  String? toFromJsonString(MacroVariableValue param,
      {required String jsonKey}) {
    final key = param.key ?? param.name.toSnakeCase();
    final suffix = param.type.isNullable ? "?" : "";
    switch (this) {
      case MacroType.bool:
        return "$jsonKey[\"$key\"] as bool$suffix";
      case MacroType.num$:
        return "$jsonKey[\"$key\"] as num$suffix";
      case MacroType.int:
        return "$jsonKey[\"$key\"] as int$suffix";
      case MacroType.double:
        return "$jsonKey[\"$key\"] as double$suffix";
      case MacroType.string:
        return "$jsonKey[\"$key\"] as String$suffix";
      case MacroType.iterable:
      case MacroType.list:
      case MacroType.set:
        return "$jsonKey.getAsList(\"$key\").toList()";
      case MacroType.map:
        return "";
      case MacroType.enum$:
        return "";
      case MacroType.modelCounter:
        return "ModelCounter.fromJson($key)";
      case MacroType.modelDate:
        return "ModelDate.fromJson($key)";
      case MacroType.modelTimestamp:
        return "ModelTimestamp.fromJson($key)";
      case MacroType.modelLocale:
        return "ModelLocale.fromJson($key)";
      case MacroType.modelLocalized:
        return "ModelLocalized.fromJson($key)";
      case MacroType.modelUri:
        return "ModelUri.fromJson($key)";
      case MacroType.modelImageUri:
        return "ModelImageUri.fromJson($key)";
      case MacroType.modelVideoUri:
        return "ModelVideoUri.fromJson($key)";
      case MacroType.modelSearch:
        return "ModelSearch.fromJson($key)";
      case MacroType.modelToken:
        return "ModelToken.fromJson($key)";
      case MacroType.modelGeoValue:
        return "ModelGeoValue.fromJson($key)";
      case MacroType.modelRef:
        return "ModelRef.fromJson($key)";
    }
  }

  /// Converts to and returns a string for the `toJson` method.
  /// 
  /// `toJson`メソッド用の文字列に変換して返します。
  String? toToJsonString(MacroVariableValue param) {
    switch (this) {
      case MacroType.bool:
      case MacroType.num$:
      case MacroType.int:
      case MacroType.double:
      case MacroType.string:
        return param.name;
      case MacroType.iterable:
      case MacroType.list:
      case MacroType.set:
        
        return "${param.name}.map((e) => e.toJson()).toList()";
      case MacroType.map:
        return "${param.name}.map((k, v) => MapEntry(k, v.toJson()))";
      case MacroType.modelCounter:
      case MacroType.modelDate:
      case MacroType.modelTimestamp:
      case MacroType.modelLocale:
      case MacroType.modelLocalized:
      case MacroType.modelUri:
      case MacroType.modelImageUri:
      case MacroType.modelVideoUri:
      case MacroType.modelSearch:
      case MacroType.modelToken:
      case MacroType.modelGeoValue:
      case MacroType.modelRef:
        return "${param.name}.toJson()";
      case MacroType.enum$:
        return "${param.name}.toString().split(\".\").last";
    }
  }
}
