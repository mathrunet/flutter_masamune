import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_token.mdc.
///
/// model_token.mdcの中身。
class ModelFieldValueModelTokenMdcCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_token.mdc.
  ///
  /// model_token.mdcの中身。
  const ModelFieldValueModelTokenMdcCliAiCode();

  @override
  String get name => "ModelTokenの利用方法";

  @override
  String get description => "MasamuneフレームワークにおけるModelTokenの利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt => "複数トークンを保存するためのクラス。PUSH通知のトークン管理等に利用可能。";

  @override
  String body(String baseName, String className) {
    return """
`ModelToken`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- トークンリストを定義

    ```dart
    ModelToken(["token1", "token2", "token3"]);
    ```

## トークンリストの取得

```dart
final tokenList = modelToken.value;
```

## トークンの操作

- トークンの追加

    ```dart
    modelToken.add("token4");
    ```

- トークンの削除

    ```dart
    modelToken.remove("token1");
    ```

- すべてのトークンを削除

    ```dart
    modelToken.clear();
    ```

## Jsonへの変換

```dart
final json = modelToken.toJson();
```

## Jsonからの変換

```dart
final modelToken = ModelToken.fromJson(json);
```
""";
  }
}
