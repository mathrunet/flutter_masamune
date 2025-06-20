# `ModelCounter`の利用方法

`ModelCounter`は下記のように利用する。

## 概要

内部にintを保持し数字を扱えるようにしながら数字のインクリメントやデクリメントをサーバー側で行えるようにしたオブジェクト。

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
