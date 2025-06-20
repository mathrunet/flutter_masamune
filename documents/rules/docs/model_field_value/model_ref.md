# `ModelRef`の利用方法

`ModelRef`は下記のように利用する。

## 概要

別`Model`への参照を扱うためのクラス。データベースの外部キーのような役割を果たし、モデル間の関連を管理する。`Document`の実装を含んでおり、データがある場合は`Document`のように利用可能。

## 作成方法

- モデルへの参照パスから定義

    ```dart
    ModelRef<UserModel>.fromPath("user/$userId");
    ```

## 値の取得

- データの取得

    ```dart
    final data = modelRef.value;
    ```

- ドキュメントIDを取得

    ```dart
    final uid = modelRef.uid;
    ```

- パスを取得。

    ```dart
    final path = modelRef.modelQuery.path;
    ```

- データを保存

    ```dart
    await modelRef.save(modelRef.value.copyWith());
    ```

- データの削除

    ```dart
    await modelRef.delete();
    ```

## Jsonへの変換

```dart
final json = modelRef.toJson();
```

## Jsonからの変換

```dart
final modelRef = ModelRef.fromJson(json);
```
