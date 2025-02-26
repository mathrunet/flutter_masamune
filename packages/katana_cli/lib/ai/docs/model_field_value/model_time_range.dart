// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_time_range.mdc.
///
/// model_time_range.mdcの中身。
class ModelFieldValueModelTimeRangeMdcCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_time_range.mdc.
  ///
  /// model_time_range.mdcの中身。
  const ModelFieldValueModelTimeRangeMdcCliAiCode();

  @override
  String get name => "`ModelTimeRange`の利用方法";

  @override
  String get description =>
      "内部に`DateTimeRange`を保持し時刻の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelTimeRange`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "内部に`DateTimeRange`を保持し時刻の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。";

  @override
  String body(String baseName, String className) {
    return """
`ModelTimeRange`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- `DateTimeRange`から変換

    ```dart
    ModelTimeRange(dateTimeRange);
    ```

- 2つの`ModelTime`から変換

    ```dart
    ModelTimeRange.fromModelTime(start: start, end: end);
    ```

- 2つの`DateTime`から変換

    ```dart
    ModelTimeRange.fromDateTime(start: start, end: end);
    ```

## 開始時の`DateTime`の取得

```dart
final start = modelTimeRange.value.start;
```

## 終了時の`DateTime`の取得

```dart
final end = modelTimeRange.value.end;
```

## Jsonへの変換

```dart
final json = modelTimeRange.toJson();
```

## Jsonからの変換

```dart
final modelTimeRange = ModelTimeRange.fromJson(json);
```
""";
  }
}
