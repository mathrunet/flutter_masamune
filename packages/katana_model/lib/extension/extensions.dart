part of "/katana_model.dart";

/// Extension methods for [DynamicMap].
///
/// [DynamicMap]の拡張メソッド。
extension DynamicMapModelExtensions on DynamicMap {
  /// Converts [DynamicMap] to Json considering [ModelFieldValue].
  ///
  /// [DynamicMap]を[ModelFieldValue]を考慮してJsonに変換します。
  DynamicMap toEntireJson() {
    return ModelFieldValue.toMap(this);
  }
}

/// Extension methods for [DynamicList].
///
/// [DynamicList]の拡張メソッド。
extension DynamicListModelExtensions on DynamicList {
  /// Converts [DynamicList] to Json considering [ModelFieldValue].
  ///
  /// [DynamicList]を[ModelFieldValue]を考慮してJsonに変換します。
  DynamicList toEntireJson() {
    final res = [];
    for (final value in this) {
      if (value is DynamicMap) {
        res.add(value.toEntireJson());
      } else if (value is DynamicList) {
        res.add(value.toEntireJson());
      } else {
        res.add(ModelFieldValue.toMap(value));
      }
    }
    return res;
  }
}

/// Extension methods for [String].
///
/// [String]の拡張メソッド。
extension ModelStringExtensions on String {
  /// Converts [String] to a searchable map.
  ///
  /// [String]を検索可能なマップに変換します。
  Map<String, dynamic> toSearchableMap() {
    return replaceAll("　", " ")
        .split(" ")
        .expand(
          (e) => e
              .toLowerCase()
              .replaceAll(".", "")
              .toHankakuNumericAndAlphabet()
              .toZenkakuKatakana()
              .toKatakana()
              .removeOnlyEmoji()
              .splitByCharacterAndBigram(),
        )
        .distinct()
        .toMap((e) => MapEntry(e, true));
  }
}
