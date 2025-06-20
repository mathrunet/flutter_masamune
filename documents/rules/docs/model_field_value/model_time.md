# `ModelTime`の利用方法

`ModelTime`は下記のように利用する。

## 概要

内部に`DateTime`を保持し時刻を扱えるようにしながらJsonにパースしやすくしたオブジェクト。

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
