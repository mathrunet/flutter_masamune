import 'package:katana_cli/ai/docs/model_field_value_usage.dart';

/// Contents of model_localized_value.mdc.
///
/// model_localized_value.mdcの中身。
class ModelFieldValueModelLocalizedValueMdcCliAiCode
    extends ModelFieldValueCliAiCode {
  /// Contents of model_localized_value.mdc.
  ///
  /// model_localized_value.mdcの中身。
  const ModelFieldValueModelLocalizedValueMdcCliAiCode();

  @override
  String get name => "ModelLocalizedValueの利用方法";

  @override
  String get description => "MasamuneフレームワークにおけるModelLocalizedValueの利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/model_field_value";

  @override
  String get excerpt =>
      "多言語対応のテキストを扱うためのクラス。言語コードごとに異なる値を保持し、現在の言語設定に応じて適切な値を返す。";

  @override
  String body(String baseName, String className) {
    return """
`ModelLocalizedValue`は下記のように利用する。

## 概要

$excerpt

## 作成方法

- `LocalizedValue`を渡して作成

    ```dart
    final localizedValue = LocalizedValue([
      LocalizedLocaleValue(Locale("ja", "JP"), "こんにちは"),
      LocalizedLocaleValue(Locale("en", "US"), "Hello"),
      LocalizedLocaleValue(Locale("fr", "FR"), "Bonjour"),
    ]);
    ModelLocalizedValue(localizedValue);
    ```

- `LocalizedLocaleValue`のリストを渡して作成

    ```dart
    final localizedValue = [
      LocalizedLocaleValue(Locale("ja", "JP"), "こんにちは"),
      LocalizedLocaleValue(Locale("en", "US"), "Hello"),
      LocalizedLocaleValue(Locale("fr", "FR"), "Bonjour"),
    ];
    ModelLocalizedValue.fromList(localizedValue);
    ```

## 値の取得

- `LocalizedValue`の取得

    ```dart
    final localizedValue = modelLocalizedValue.value;
    ```

- 特定の言語の値を取得

    ```dart
    final jaText = modelLocalizedValue.value.value(Locale("ja", "JP"));
    final enText = modelLocalizedValue.value.value(Locale("en", "US"));
    ```

## Jsonへの変換

```dart
final json = modelLocalizedValue.toJson();
```

## Jsonからの変換

```dart
final modelLocalizedValue = ModelLocalizedValue.fromJson(json);
```
""";
  }
}
