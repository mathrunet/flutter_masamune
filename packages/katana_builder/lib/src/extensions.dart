part of "/katana_builder.dart";

/// Extension method of [DartObject].
///
/// [DartObject]の拡張メソッド。
extension DartObjectExtensions on DartObject {
  /// Generate an object based on the type.
  ///
  /// タイプを元にオブジェクトを生成します。
  Object? toValue() {
    if (type == null || isNull) {
      return null;
    } else if (type!.isDartCoreString) {
      return toStringValue();
    } else if (type!.isDartCoreBool) {
      return toBoolValue();
    } else if (type!.isDartCoreInt) {
      return toIntValue();
    } else if (type!.isDartCoreDouble) {
      return toDoubleValue();
    } else if (type!.isDartCoreList) {
      return toListValue();
    } else if (type!.isDartCoreMap) {
      return toMapValue();
    } else if (type!.isDartCoreSet) {
      return toSetValue();
    }
    return null;
  }
}

/// Extension method of [DartTypeExtensions].
///
/// [DartTypeExtensions]の拡張メソッド。
extension DartTypeExtensions on DartType {
  /// Returns `true`` if this type is a null-allowed type.
  ///
  /// この型がNull許容型の場合`true``を返します。
  bool get isNullable {
    return toString().endsWith("?");
  }

  /// Obtains an alias name.
  ///
  /// エイリアス名を取得します。
  String get aliasName {
    final aliasElement = alias?.element;
    if (aliasElement != null) {
      return aliasElement.name;
    }
    return toString();
  }
}

/// Extension method of [InterfaceType].
///
/// [InterfaceType]の拡張メソッド。
extension InterfaceTypeExtensions on InterfaceType {
  /// Get this type and all its supertypes.
  ///
  /// この型とそのスーパータイプをすべて取得します。
  List<InterfaceType> get allThisOrSubTypes {
    return [this, ...allSupertypes];
  }

  /// Returns `true` for `ModelRef` type.
  ///
  /// `ModelRef`型の場合`true`を返します。
  bool get isModelRef {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelRef.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelCounter` type.
  ///
  /// `ModelCounter`型の場合`true`を返します。
  bool get isModelCounter {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelCounter.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelTimestamp` type.
  ///
  /// `ModelTimestamp`型の場合`true`を返します。
  bool get isModelTimestamp {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelTimestamp.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelDate` type.
  ///
  /// `ModelDate`型の場合`true`を返します。
  bool get isModelDate {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelDate.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelTime` type.
  ///
  /// `ModelTime`型の場合`true`を返します。
  bool get isModelTime {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelTime.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelTimestampRange` type.
  ///
  /// `ModelTimestampRange`型の場合`true`を返します。
  bool get isModelTimestampRange {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelTimestampRange.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelDateRange` type.
  ///
  /// `ModelDateRange`型の場合`true`を返します。
  bool get isModelDateRange {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelDateRange.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelTime` type.
  ///
  /// `ModelTime`型の場合`true`を返します。
  bool get isModelTimeRange {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelTimeRange.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelSearch` type.
  ///
  /// `ModelSearch`型の場合`true`を返します。
  bool get isModelSearch {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelSearch.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelToken` type.
  ///
  /// `ModelToken`型の場合`true`を返します。
  bool get isModelToken {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelToken.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelUri` type.
  ///
  /// `ModelUri`型の場合`true`を返します。
  bool get isModelUri {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelUri.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelImageUri` type.
  ///
  /// `ModelImageUri`型の場合`true`を返します。
  bool get isModelImageUri {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelImageUri.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelVideoUri` type.
  ///
  /// `ModelVideoUri`型の場合`true`を返します。
  bool get isModelVideoUri {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelVideoUri.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelGeoValue` type.
  ///
  /// `ModelGeoValue`型の場合`true`を返します。
  bool get isModelGeoValue {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelGeoValue.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelLocale` type.
  ///
  /// `ModelLocale`型の場合`true`を返します。
  bool get isModelLocale {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelLocale.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelLocalizedValue` type.
  ///
  /// `ModelLocalizedValue`型の場合`true`を返します。
  bool get isModelLocalizedValue {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelLocalizedValue.regExp.hasMatch(e.toString()),
    );
  }

  /// Returns `true` for `ModelCommand` type.
  ///
  /// `ModelCommand`型の場合`true`を返します。
  bool get isModelCommand {
    return allThisOrSubTypes.any(
      (e) => MasamuneType.modelCommandBase.regExp.hasMatch(e.toString()),
    );
  }
}
