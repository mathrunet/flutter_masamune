// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_timestamp.mdc.
///
/// model_timestamp.mdcの中身。
class ModelFieldValueModelTimestampMdcCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_timestamp.mdc.
  ///
  /// model_timestamp.mdcの中身。
  const ModelFieldValueModelTimestampMdcCliAiCode();

  @override
  String get name => "`ModelTimestamp`の利用方法";

  @override
  String get description =>
      "内部に`DateTime`を保持し日時を扱えるようにしながらJsonにパースしやすくしたオブジェクトである`ModelTimestamp`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt => "内部に`DateTime`を保持し日時を扱えるようにしながらJsonにパースしやすくしたオブジェクト。";

  @override
  String body(String baseName, String className) {
    return """
`ModelTimestamp`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- 現在日時を定義

    ```dart
    ModelTimestamp.now();
    ```

- `DateTime`から変換

    ```dart
    ModelTimestamp(dateTime);
    ```

- 日時を直接入力

    ```dart
    // 2000年1月1日10時15分30秒 100milliseconds 200microseconds 
    ModelTimestamp.dateTime(2000, 1, 1, 10, 15, 30, 100, 200);
    ```

- 文字列からのパース（パースに失敗した場合Exceptionをスロー）

    ```dart
    ModelTimestamp.parse("2000-01-01 10:15:30");
    ```

- 文字列からのパース（パースに失敗した場合nullを返す）

    ```dart
    ModelTimestamp.tryParse("2000-01-01 10:15:30");
    ```

## `DateTime`の取得

```dart
final dateTime = modelTimestamp.value;
```

## その他メソッド

- `ModelDate`への変換
    
    ```dart
    final modelDate = modelTimestamp.toModelDate();
    ```

- `ModelTime`への変換

    ```dart
    final modelTime = modelTimestamp.toModelTime();
    ```

## Jsonへの変換

```dart
final json = modelTimestamp.toJson();
```

## Jsonからの変換

```dart
final modelTimestamp = ModelTimestamp.fromJson(json);
```
""";
  }
}
