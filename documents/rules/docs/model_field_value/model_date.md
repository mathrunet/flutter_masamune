# `ModelDate`の利用方法

`ModelDate`は下記のように利用する。

## 概要

内部に`DateTime`を保持し日付を扱えるようにしながらJsonにパースしやすくしたオブジェクト。時刻は含まれず、日付のみを扱う。

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
