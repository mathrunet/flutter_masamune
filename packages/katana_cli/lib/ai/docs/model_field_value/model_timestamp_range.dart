// Project imports:
import "package:katana_cli/ai/docs/model_field_value_usage.dart";

/// Contents of model_timestamp_range.md.
///
/// model_timestamp_range.mdの中身。
class ModelFieldValueModelTimestampRangeMdCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_timestamp_range.md.
  ///
  /// model_timestamp_range.mdの中身。
  const ModelFieldValueModelTimestampRangeMdCliAiCode();

  @override
  String get name => "`ModelTimestampRange`の利用方法";

  @override
  String get description =>
      "内部に`DateTimeRange`を保持し日時の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelTimestampRange`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "内部に`DateTimeRange`を保持し日時の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。";

  @override
  String body(String baseName, String className) {
    return """
`ModelTimestampRange`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- `DateTimeRange`から変換

    ```dart
    ModelTimestampRange(dateTimeRange);
    ```

- 2つの`ModelTimestamp`から変換

    ```dart
    ModelTimestampRange.fromModelTimestamp(start: start, end: end);
    ```

- 2つの`DateTime`から変換

    ```dart
    ModelTimestampRange.fromDateTime(start: start, end: end);
    ```

## 開始時の`DateTime`の取得

```dart
final start = modelTimestampRange.value.start;
```

## 終了時の`DateTime`の取得

```dart
final end = modelTimestampRange.value.end;
```

## Jsonへの変換

```dart
final json = modelTimestampRange.toJson();
```

## Jsonからの変換

```dart
final modelTimestampRange = ModelTimestampRange.fromJson(json);
```
""";
  }
}
