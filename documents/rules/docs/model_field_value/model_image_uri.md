# `ModelImageUri`の利用方法

`ModelImageUri`は下記のように利用する。

## 概要

画像のURIを扱うためのクラス。画像ファイルのパスやURLを保存・管理するために利用可能。`ModelUri`の特殊化バージョンで、画像ファイル専用の機能を提供。

## 作成方法

- URIから変換

    ```dart
    ModelImageUri(Uri.parse("https://example.com/image.jpg"));
    ```

- 文字列から変換

    ```dart
    ModelImageUri.parse("https://example.com/image.jpg");
    ```

## URIの取得

```dart
final uri = modelImageUri.value;
```

## Jsonへの変換

```dart
final json = modelImageUri.toJson();
```

## Jsonからの変換

```dart
final modelImageUri = ModelImageUri.fromJson(json);
```
