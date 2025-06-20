# `ModelSearch`の利用方法

`ModelSearch`は下記のように利用する。

## 概要

検索可能なフィールドを定義します。値を検索可能な値として保存し、[ModelQueryFilter.equal]で定義されたものがすべて含まれる要素を検索することが可能。カテゴリー検索等に利用可能。

## 作成方法

- 検索リストを定義

    ```dart
    ModelSearch(["tag1", "tag2", "tag3"]);
    ```

## 検索リストの取得

```dart
final searchList = modelSearch.value;
```

## Jsonへの変換

```dart
final json = modelSearch.toJson();
```

## Jsonからの変換

```dart
final modelSearch = ModelSearch.fromJson(json);
```
