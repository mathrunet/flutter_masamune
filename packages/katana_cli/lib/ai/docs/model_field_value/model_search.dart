// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_search.md.
///
/// model_search.mdの中身。
class ModelFieldValueModelSearchMdCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_search.md.
  ///
  /// model_search.mdの中身。
  const ModelFieldValueModelSearchMdCliAiCode();

  @override
  String get name => "`ModelSearch`の利用方法";

  @override
  String get description =>
      "検索可能なフィールドを定義します。値を検索可能な値として保存し、[ModelQueryFilter.equal]で定義されたものがすべて含まれる要素を検索することが可能。カテゴリー検索等に利用可能。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "検索可能なフィールドを定義します。値を検索可能な値として保存し、[ModelQueryFilter.equal]で定義されたものがすべて含まれる要素を検索することが可能。カテゴリー検索等に利用可能。";

  @override
  String body(String baseName, String className) {
    return """
`ModelSearch`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- 検索リストを定義

    ```dart
    ModelSearch(["tag1", "tag2", "tag3"]);
    ```

## 検索リストの取得

```dart
final searchList = modelSearch.value;
```

## Jsonへの変換

```dart
final json = modelSearch.toJson();
```

## Jsonからの変換

```dart
final modelSearch = ModelSearch.fromJson(json);
```
""";
  }
}
