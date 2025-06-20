# `ModelToken`の利用方法

`ModelToken`は下記のように利用する。

## 概要

複数トークンを保存するためのクラス。PUSH通知のトークン管理等に利用可能。

## 作成方法

- トークンリストを定義

    ```dart
    ModelToken(["token1", "token2", "token3"]);
    ```

## トークンリストの取得

```dart
final tokenList = modelToken.value;
```

## トークンの操作

- トークンの追加

    ```dart
    modelToken.add("token4");
    ```

- トークンの削除

    ```dart
    modelToken.remove("token1");
    ```

- すべてのトークンを削除

    ```dart
    modelToken.clear();
    ```

## Jsonへの変換

```dart
final json = modelToken.toJson();
```

## Jsonからの変換

```dart
final modelToken = ModelToken.fromJson(json);
```
