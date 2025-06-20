// Project imports:
import "package:katana_cli/ai/docs/model_field_value_usage.dart";

/// Contents of model_date.md.
///
/// model_date.mdの中身。
class ModelFieldValueModelDateMdCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_date.md.
  ///
  /// model_date.mdの中身。
  const ModelFieldValueModelDateMdCliAiCode();

  @override
  String get name => "`ModelDate`の利用方法";

  @override
  String get description =>
      "内部に`DateTime`を保持し日付を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelDate`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "内部に`DateTime`を保持し日付を扱えるようにしながらJsonにパースしやすくしたオブジェクト。時刻は含まれず、日付のみを扱う。";

  @override
  String body(String baseName, String className) {
    return """
`ModelDate`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- 現在日付を定義

    ```dart
    ModelDate.now();
    ```

- `DateTime`から変換

    ```dart
    ModelDate(dateTime);
    ```

- 日付を直接入力

    ```dart
    // 2000年1月1日
    ModelDate.date(2000, 1, 1);
    ```

## `DateTime`の取得

```dart
final dateTime = modelDate.value;
```

## Jsonへの変換

```dart
final json = modelDate.toJson();
```

## Jsonからの変換

```dart
final modelDate = ModelDate.fromJson(json);
```
""";
  }
}
