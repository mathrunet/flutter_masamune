# `ModelDateRange`の利用方法

`ModelDateRange`は下記のように利用する。

## 概要

内部に`DateTimeRange`を保持し日付の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。時刻は含まれず、日付のみを扱う。

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
