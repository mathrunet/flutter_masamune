// Project imports:
import "package:katana_cli/ai/docs/model_field_value_usage.dart";

/// Contents of model_uri.md.
///
/// model_uri.mdの中身。
class ModelFieldValueModelUriMdCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_uri.md.
  ///
  /// model_uri.mdの中身。
  const ModelFieldValueModelUriMdCliAiCode();

  @override
  String get name => "`ModelUri`の利用方法";

  @override
  String get description => "URIを扱うためのクラスである`ModelUri`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt => "URIを扱うためのクラス。ファイルパスやURLなどのURIを保存・管理するために利用可能。";

  @override
  String body(String baseName, String className) {
    return """
`ModelUri`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- URIから変換

    ```dart
    ModelUri(Uri.parse("https://example.com"));
    ```

- 文字列から変換

    ```dart
    ModelUri.parse("https://example.com");
    ```

## URIの取得

```dart
final uri = modelUri.value;
```

## Jsonへの変換

```dart
final json = modelUri.toJson();
```

## Jsonからの変換

```dart
final modelUri = ModelUri.fromJson(json);
```
""";
  }
}
