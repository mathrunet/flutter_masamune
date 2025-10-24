# `ModelVectorValue`の利用方法

`ModelVectorValue`は下記のように利用する。

## 概要

ベクトルデータ(埋め込みベクトル)を扱うためのクラス。RAG(Retrieval-Augmented Generation)やベクトル類似度検索、セマンティック検索に利用可能。

ベクトル類似度の計算方法として、コサイン類似度、ユークリッド距離、ドット積の3種類をサポート。

## 作成方法

- `VectorValue`を渡して作成

    ```dart
    final vectorValue = VectorValue([0.1, 0.2, 0.3, 0.4]);
    ModelVectorValue(vectorValue);
    ```

- ベクトルのリストを直接指定して作成

    ```dart
    ModelVectorValue.fromList([0.1, 0.2, 0.3, 0.4]);
    ```

## 値の取得

- `VectorValue`の取得

    ```dart
    final vectorValue = modelVectorValue.value;
    ```

- ベクトルのリストの取得

    ```dart
    final vector = modelVectorValue.value.vector;
    ```

- 次元数の取得

    ```dart
    final dimension = modelVectorValue.value.dimension;
    ```

## ベクトル類似度の計算

- コサイン類似度の計算(デフォルト)

    ```dart
    final similarity = vectorValue1.similarity(vectorValue2);
    // または
    final similarity = vectorValue1.cosineSimilarity(vectorValue2);
    ```

- ユークリッド距離の計算

    ```dart
    final distance = vectorValue1.similarity(
      vectorValue2,
      measure: VectorDistanceMeasure.euclidean,
    );
    // または
    final distance = vectorValue1.euclideanDistance(vectorValue2);
    ```

- ドット積の計算

    ```dart
    final dotProduct = vectorValue1.similarity(
      vectorValue2,
      measure: VectorDistanceMeasure.dotProduct,
    );
    // または
    final dotProduct = vectorValue1.dotProduct(vectorValue2);
    ```

## ベクトル類似度検索

`nearest`メソッドを使用して、クエリベクトルに最も類似したドキュメントを検索できる。

```dart
final query = ModelVectorValueModel.collection().nearest(
  ModelVectorValueModel.vectorKey,
  queryVector: [0.1, 0.2, 0.3, 0.4],
  measure: VectorDistanceMeasure.cosine, // デフォルトはcosine
);
```

**注意**: Firestoreアダプターを使用する場合、ベクトル類似度検索は現在クライアントサイドで実行される。将来的にFirestoreのネイティブベクトル検索APIが利用可能になった際には、サーバーサイドでの実行に移行される予定。

## Jsonへの変換

```dart
final json = modelVectorValue.toJson();
```

## Jsonからの変換

```dart
final modelVectorValue = ModelVectorValue.fromJson(json);
```

## 使用例

### RAG(Retrieval-Augmented Generation)での利用

```dart
// 1. ドキュメントの埋め込みベクトルを生成して保存
final document = ModelVectorValueModel(
  text: "サンプルテキスト",
  vector: ModelVectorValue.fromList(embedding), // AIで生成した埋め込みベクトル
);
await document.save();

// 2. クエリの埋め込みベクトルを生成
final queryEmbedding = await generateEmbedding("検索クエリ");

// 3. ベクトル類似度検索で関連ドキュメントを取得
final results = await ModelVectorValueModel.collection()
  .nearest(
    ModelVectorValueModel.vectorKey,
    queryVector: queryEmbedding,
  )
  .limitTo(5)
  .get();
```
