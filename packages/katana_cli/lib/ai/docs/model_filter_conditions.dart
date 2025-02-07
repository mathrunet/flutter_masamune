import 'package:katana_cli/katana_cli.dart';

/// Contents of model_filter_conditions.mdc.
///
/// model_filter_conditions.mdcの中身。
class ModelFilterConditionsMdcCliAiCode extends CliAiCode {
  /// Contents of model_filter_conditions.mdc.
  ///
  /// model_filter_conditions.mdcの中身。
  const ModelFilterConditionsMdcCliAiCode();

  @override
  String get name => "`Collection`の`Model`フィルター条件";

  @override
  String get description => "Masamuneフレームワークによる`Collection`の`Model`フィルター条件";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Collection`の`Model`フィルター条件は下記の通り。

| Conditions | Summary |
| --- | --- |
| `.[DataFieldName].equal(value)` | [DataFieldName]が[value]と等しい |
| `.[DataFieldName].notEqual(value)` | [DataFieldName]が[value]と等しくない |
| `.[DataFieldName].greaterThan(value)` | [DataFieldName]が[value]より大きい |
| `.[DataFieldName].greaterThanOrEqual(value)` | [DataFieldName]が[value]より大きいか等しい |
| `.[DataFieldName].lessThan(value)` | [DataFieldName]が[value]より小さい |
| `.[DataFieldName].lessThanOrEqual(value)` | [DataFieldName]が[value]より小さいか等しい |
| `.[DataFieldName(List)].contains(value)` | [DataFieldName(List)]が[value]を含む |
| `.[DataFieldName(List)].containsAny([value1, value2, ...])` | [DataFieldName(List)]が[value1], [value2], ...のいずれかを含む |
| `.[DataFieldName].where([value1, value2, ...])` | [DataFieldName]が[value1], [value2], ...のいずれかと等しい |
| `.[DataFieldName].notWhere([value1, value2, ...])` | [DataFieldName]が[value1], [value2], ...のいずれとも等しくない |
| `.[DataFieldName].isNull()` | [DataFieldName]がnullである |
| `.[DataFieldName].isNotNull()` | [DataFieldName]がnullでない |
| `.[DataFieldName].orderByAsc()` | `Collection`を[DataFieldName]をキーとして昇順でソート |
| `.[DataFieldName].orderByDesc()` | `Collection`を[DataFieldName]をキーとして降順でソート |
| `.[DataFieldName].limitTo(value)` | `Collection`を[value]件に制限 |
""";
  }
}
