// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_time.mdc.
///
/// model_time.mdcの中身。
class ModelFieldValueModelTimeMdcCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_time.mdc.
  ///
  /// model_time.mdcの中身。
  const ModelFieldValueModelTimeMdcCliAiCode();

  @override
  String get name => "`ModelTime`の利用方法";

  @override
  String get description =>
      "内部に`DateTime`を保持し時刻を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelTime`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt => "内部に`DateTime`を保持し時刻を扱えるようにしながらJsonにパースしやすくしたオブジェクト。";

  @override
  String body(String baseName, String className) {
    return """
`ModelTime`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- 現在時刻を定義

    ```dart
    ModelTime.now();
    ```

- `DateTime`から変換

    ```dart
    ModelTime(dateTime);
    ```

- 時刻を直接入力

    ```dart
    // 10時15分30秒 100milliseconds 200microseconds 
    ModelTime.time(10, 15, 30, 100, 200);
    ```

## `DateTime`の取得（日付は1970年1月1日）

```dart
final dateTime = modelTime.value;
```

## Jsonへの変換

```dart
final json = modelTime.toJson();
```

## Jsonからの変換

```dart
final modelTime = ModelTime.fromJson(json);
```
""";
  }
}
