# `ModelLocalizedValue`の利用方法

`ModelLocalizedValue`は下記のように利用する。

## 概要

多言語対応のテキストを扱うためのクラス。言語コードごとに異なる値を保持し、現在の言語設定に応じて適切な値を返す。

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
