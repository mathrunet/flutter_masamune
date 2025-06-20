# `ModelLocale`の利用方法

`ModelLocale`は下記のように利用する。

## 概要

内部に`Locale`を保持し言語設定を扱えるようにしながらJsonにパースしやすくしたオブジェクト。

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
