# `ModelTimestampRange`の利用方法

`ModelTimestampRange`は下記のように利用する。

## 概要

内部に`DateTimeRange`を保持し日時の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。

## 作成方法

- `DateTimeRange`から変換

    ```dart
    ModelTimestampRange(dateTimeRange);
    ```

- 2つの`ModelTimestamp`から変換

    ```dart
    ModelTimestampRange.fromModelTimestamp(start: start, end: end);
    ```

- 2つの`DateTime`から変換

    ```dart
    ModelTimestampRange.fromDateTime(start: start, end: end);
    ```

## 開始時の`DateTime`の取得

```dart
final start = modelTimestampRange.value.start;
```

## 終了時の`DateTime`の取得

```dart
final end = modelTimestampRange.value.end;
```

## Jsonへの変換

```dart
final json = modelTimestampRange.toJson();
```

## Jsonからの変換

```dart
final modelTimestampRange = ModelTimestampRange.fromJson(json);
```
