# `ModelVideoUri`の利用方法

`ModelVideoUri`は下記のように利用する。

## 概要

動画のURIを扱うためのクラス。動画ファイルのパスやURLを保存・管理するために利用可能。`ModelUri`の特殊化バージョンで、動画ファイル専用の機能を提供。

## 作成方法

- URIから変換

    ```dart
    ModelVideoUri(Uri.parse("https://example.com/video.mp4"));
    ```

- 文字列から変換

    ```dart
    ModelVideoUri.parse("https://example.com/video.mp4");
    ```

## URIの取得

```dart
final uri = modelVideoUri.value;
```

## Jsonへの変換

```dart
final json = modelVideoUri.toJson();
```

## Jsonからの変換

```dart
final modelVideoUri = ModelVideoUri.fromJson(json);
```
