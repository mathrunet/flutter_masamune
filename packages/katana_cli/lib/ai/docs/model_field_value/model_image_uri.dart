// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_image_uri.mdc.
///
/// model_image_uri.mdcの中身。
class ModelFieldValueModelImageUriMdcCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_image_uri.mdc.
  ///
  /// model_image_uri.mdcの中身。
  const ModelFieldValueModelImageUriMdcCliAiCode();

  @override
  String get name => "`ModelImageUri`の利用方法";

  @override
  String get description => "画像のURIを扱うためのクラスである`ModelImageUri`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "画像のURIを扱うためのクラス。画像ファイルのパスやURLを保存・管理するために利用可能。`ModelUri`の特殊化バージョンで、画像ファイル専用の機能を提供。";

  @override
  String body(String baseName, String className) {
    return """
`ModelImageUri`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- URIから変換

    ```dart
    ModelImageUri(Uri.parse("https://example.com/image.jpg"));
    ```

- 文字列から変換

    ```dart
    ModelImageUri.parse("https://example.com/image.jpg");
    ```

## URIの取得

```dart
final uri = modelImageUri.value;
```

## Jsonへの変換

```dart
final json = modelImageUri.toJson();
```

## Jsonからの変換

```dart
final modelImageUri = ModelImageUri.fromJson(json);
```
""";
  }
}
