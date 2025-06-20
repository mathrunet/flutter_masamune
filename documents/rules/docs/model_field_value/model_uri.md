# `ModelUri`の利用方法

`ModelUri`は下記のように利用する。

## 概要

URIを扱うためのクラス。ファイルパスやURLなどのURIを保存・管理するために利用可能。

## 作成方法

- URIから変換

    ```dart
    ModelUri(Uri.parse("https://example.com"));
    ```

- 文字列から変換

    ```dart
    ModelUri.parse("https://example.com");
    ```

## URIの取得

```dart
final uri = modelUri.value;
```

## Jsonへの変換

```dart
final json = modelUri.toJson();
```

## Jsonからの変換

```dart
final modelUri = ModelUri.fromJson(json);
```
