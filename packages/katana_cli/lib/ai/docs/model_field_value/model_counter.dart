// Project imports:
import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_counter.mdc.
///
/// model_counter.mdcの中身。
class ModelFieldValueModelCounterMdcCliAiCode extends ModelFieldValueCliAiCode {
  /// Contents of model_counter.mdc.
  ///
  /// model_counter.mdcの中身。
  const ModelFieldValueModelCounterMdcCliAiCode();

  @override
  String get name => "`ModelCounter`の利用方法";

  @override
  String get description =>
      "内部にintを保持し数字を扱えるようにしながら数字のインクリメントやデクリメントをサーバー側で行えるようにしたオブジェクトである`ModelCounter`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "内部にintを保持し数字を扱えるようにしながら数字のインクリメントやデクリメントをサーバー側で行えるようにしたオブジェクト。";

  @override
  String body(String baseName, String className) {
    return """
`ModelCounter`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- 初期値を定義して定義

    ```dart
    ModelCounter(100);
    ```

## intの取得

```dart
final number = modelCounter.value;
```

## その他メソッド

- 数値の増減
    
    ```dart
    modelCounter.increment(5);
    modelCounter.increment(-4);
    ```

- 増減する数値を取得
    
    ```dart
    final incrementValue = modelCounter.incrementValue;
    ```

## Jsonへの変換

```dart
final json = modelCounter.toJson();
```

## Jsonからの変換

```dart
final modelCounter = ModelCounter.fromJson(json);
```
""";
  }
}
