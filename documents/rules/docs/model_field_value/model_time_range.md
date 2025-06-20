# `ModelTimeRange`の利用方法

`ModelTimeRange`は下記のように利用する。

## 概要

内部に`DateTimeRange`を保持し時刻の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。

## 作成方法

- `DateTimeRange`から変換

    ```dart
    ModelTimeRange(dateTimeRange);
    ```

- 2つの`ModelTime`から変換

    ```dart
    ModelTimeRange.fromModelTime(start: start, end: end);
    ```

- 2つの`DateTime`から変換

    ```dart
    ModelTimeRange.fromDateTime(start: start, end: end);
    ```

## 開始時の`DateTime`の取得

```dart
final start = modelTimeRange.value.start;
```

## 終了時の`DateTime`の取得

```dart
final end = modelTimeRange.value.end;
```

## Jsonへの変換

```dart
final json = modelTimeRange.toJson();
```

## Jsonからの変換

```dart
final modelTimeRange = ModelTimeRange.fromJson(json);
```
