// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_date_range.mdc.
///
/// model_date_range.mdcの中身。
class ModelFieldValueModelDateRangeMdcCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_date_range.mdc.
  ///
  /// model_date_range.mdcの中身。
  const ModelFieldValueModelDateRangeMdcCliAiCode();

  @override
  String get name => "`ModelDateRange`の利用方法";

  @override
  String get description =>
      "内部に`DateTimeRange`を保持し日付の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelDateRange`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "内部に`DateTimeRange`を保持し日付の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。時刻は含まれず、日付のみを扱う。";

  @override
  String body(String baseName, String className) {
    return """
`ModelDateRange`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- `DateTimeRange`から変換

    ```dart
    ModelDateRange(dateTimeRange);
    ```

- 2つの`ModelDate`から変換

    ```dart
    ModelDateRange.fromModelDate(start: start, end: end);
    ```

- 2つの`DateTime`から変換

    ```dart
    ModelDateRange.fromDateTime(start: start, end: end);
    ```

## 開始時の`ModelDate`の取得

```dart
final start = modelDateRange.value.start;
```

## 終了時の`ModelDate`の取得

```dart
final end = modelDateRange.value.end;
```

## Jsonへの変換

```dart
final json = modelDateRange.toJson();
```

## Jsonからの変換

```dart
final modelDateRange = ModelDateRange.fromJson(json);
```
""";
  }
}
