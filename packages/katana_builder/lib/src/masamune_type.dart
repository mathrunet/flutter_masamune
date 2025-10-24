part of "/katana_builder.dart";

/// Special type used in Masamune framework.
///
/// Masamuneフレームワークで利用する特殊なタイプ。
enum MasamuneType {
  /// Type of `ModelRef`.
  ///
  /// `ModelRef`の型。
  modelRef,

  /// Type of `ModelCounter`.
  ///
  /// `ModelCounter`の型。
  modelCounter,

  /// Type of `ModelTimestamp`.
  ///
  /// `ModelTimestamp`の型。
  modelTimestamp,

  /// Type of `ModelTime`.
  ///
  /// `ModelTime`の型。
  modelTime,

  /// Type of `ModelDate`.
  ///
  /// `ModelDate`の型。
  modelDate,

  /// Type of `ModelTimestampRange`.
  ///
  /// `ModelTimestampRange`の型。
  modelTimestampRange,

  /// Type of `ModelTimeRange`.
  ///
  /// `ModelTimeRange`の型。
  modelTimeRange,

  /// Type of `ModelDateRange`.
  ///
  /// `ModelDateRange`の型。
  modelDateRange,

  /// Type of `ModelSearch`.
  ///
  /// `ModelSearch`の型。
  modelSearch,

  /// Type of `ModelToken`.
  ///
  /// `ModelToken`の型。
  modelToken,

  /// Type of `ModelUri`.
  ///
  /// `ModelUri`の型。
  modelUri,

  /// Type of `ModelImage`.
  ///
  /// `ModelImage`の型。
  modelImageUri,

  /// Type of `ModelVideo`.
  ///
  /// `ModelVideo`の型。
  modelVideoUri,

  /// Type of `ModelAudio`.
  ///
  /// `ModelAudio`の型。
  modelGeoValue,

  /// Type of `ModelVectorValue`.
  ///
  /// `ModelVectorValue`の型。
  modelVectorValue,

  /// Type of `ModelGeo`.
  ///
  /// `ModelGeo`の型。
  modelLocale,

  /// Type of `ModelLocalizedValue`.
  ///
  /// `ModelLocalizedValue`の型。
  modelLocalizedValue,

  /// Type of `ModelCommand`.
  ///
  /// `ModelCommand`の型。
  modelCommandBase;

  /// Obtains the class name.
  ///
  /// クラス名を取得します。
  String get className {
    switch (this) {
      case MasamuneType.modelRef:
        return "ModelRefBase";
      case MasamuneType.modelCounter:
        return "ModelCounter";
      case MasamuneType.modelTimestamp:
        return "ModelTimestamp";
      case MasamuneType.modelTime:
        return "ModelTime";
      case MasamuneType.modelDate:
        return "ModelDate";
      case MasamuneType.modelTimestampRange:
        return "ModelTimestampRange";
      case MasamuneType.modelTimeRange:
        return "ModelTimeRange";
      case MasamuneType.modelDateRange:
        return "ModelDateRange";
      case MasamuneType.modelSearch:
        return "ModelSearch";
      case MasamuneType.modelToken:
        return "ModelToken";
      case MasamuneType.modelUri:
        return "ModelUri";
      case MasamuneType.modelImageUri:
        return "ModelImageUri";
      case MasamuneType.modelVideoUri:
        return "ModelVideoUri";
      case MasamuneType.modelGeoValue:
        return "ModelGeoValue";
      case MasamuneType.modelVectorValue:
        return "ModelVectorValue";
      case MasamuneType.modelLocale:
        return "ModelLocale";
      case MasamuneType.modelLocalizedValue:
        return "ModelLocalizedValue";
      case MasamuneType.modelCommandBase:
        return "ModelCommandBase";
    }
  }

  /// Obtains the regular expression.
  ///
  /// 正規表現を取得します。
  RegExp get regExp {
    switch (this) {
      case MasamuneType.modelRef:
        return RegExp(r"^ModelRefBase\<[^>]+\>$");
      case MasamuneType.modelCounter:
        return RegExp(r"^ModelCounter[^a-zA-Z0-9]?$");
      case MasamuneType.modelTimestamp:
        return RegExp(r"^ModelTimestamp[^a-zA-Z0-9]?$");
      case MasamuneType.modelTime:
        return RegExp(r"^ModelTime[^a-zA-Z0-9]?$");
      case MasamuneType.modelDate:
        return RegExp(r"^ModelDate[^a-zA-Z0-9]?$");
      case MasamuneType.modelTimestampRange:
        return RegExp(r"^ModelTimestampRange[^a-zA-Z0-9]?$");
      case MasamuneType.modelTimeRange:
        return RegExp(r"^ModelTimeRange[^a-zA-Z0-9]?$");
      case MasamuneType.modelDateRange:
        return RegExp(r"^ModelDateRange[^a-zA-Z0-9]?$");
      case MasamuneType.modelSearch:
        return RegExp(r"^ModelSearch[^a-zA-Z0-9]?$");
      case MasamuneType.modelToken:
        return RegExp(r"^ModelToken[^a-zA-Z0-9]?$");
      case MasamuneType.modelUri:
        return RegExp(r"^ModelUri[^a-zA-Z0-9]?$");
      case MasamuneType.modelImageUri:
        return RegExp(r"^ModelImageUri[^a-zA-Z0-9]?$");
      case MasamuneType.modelVideoUri:
        return RegExp(r"^ModelVideoUri[^a-zA-Z0-9]?$");
      case MasamuneType.modelGeoValue:
        return RegExp(r"^ModelGeoValue[^a-zA-Z0-9]?$");
      case MasamuneType.modelVectorValue:
        return RegExp(r"^ModelVectorValue[^a-zA-Z0-9]?$");
      case MasamuneType.modelLocale:
        return RegExp(r"^ModelLocale[^a-zA-Z0-9]?$");
      case MasamuneType.modelLocalizedValue:
        return RegExp(r"^ModelLocalizedValue[^a-zA-Z0-9]?$");
      case MasamuneType.modelCommandBase:
        return RegExp(r"^ModelCommandBase[^a-zA-Z0-9]?$");
    }
  }

  /// Obtains the instansiate string.
  ///
  /// インスタンス化文字列を取得します。
  String get instansiateString {
    switch (this) {
      case MasamuneType.modelSearch:
      case MasamuneType.modelToken:
        return "const $className([])";
      default:
        return "const $className()";
    }
  }
}
