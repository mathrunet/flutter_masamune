// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_locale.md.
///
/// model_locale.mdの中身。
class ModelFieldValueModelLocaleMdCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_locale.md.
  ///
  /// model_locale.mdの中身。
  const ModelFieldValueModelLocaleMdCliAiCode();

  @override
  String get name => "`ModelLocale`の利用方法";

  @override
  String get description =>
      "内部に`Locale`を保持し言語設定を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelLocale`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt => "内部に`Locale`を保持し言語設定を扱えるようにしながらJsonにパースしやすくしたオブジェクト。";

  @override
  String body(String baseName, String className) {
    return """
`ModelLocale`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- `Locale`から変換

    ```dart
    final locale = Locale("ja", "JP");
    ModelLocale(locale);
    ```

- 言語コードと国コードを直接指定

    ```dart
    ModelLocale.fromCode("ja", "JP");
    ```

## `Locale`の取得

```dart
final locale = modelLocale.value;
```

## Jsonへの変換

```dart
final json = modelLocale.toJson();
```

## Jsonからの変換

```dart
final modelLocale = ModelLocale.fromJson(json);
```
""";
  }
}
