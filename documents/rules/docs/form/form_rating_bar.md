# `FormRatingBar`の利用方法

`FormRatingBar`は下記のように利用する。

## 概要

評価を星やアイコンで入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで評価値を管理できます。カスタムアイコン、半星表示、タップ・ドラッグでの入力、ラベルの表示などの機能を備えています。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormRatingBar(
        initialValue: formController.value.rating,
        onSaved: (value) => formController.value.copyWith(rating: value),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## 基本的な利用方法

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## アイコンの数を指定した利用方法

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  iconCount: 5,
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## カスタムアイコンの利用方法

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  icon: Icon(Icons.favorite),
  iconSize: 48.0,
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## 半星表示の利用方法

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  allowHalfRating: true,
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## ラベル付き表示の利用方法

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  showLabel: true,
  format: "0.#",
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## バリデーション付きの利用方法

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  validator: (value) {
    if (value == null) {
      return "評価を入力してください";
    }
    if (value < 1.0) {
      return "1以上の評価を入力してください";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## カスタムデザインの適用

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
  ),
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormRatingBar(
  initialValue: 3.5,
  onChanged: (value) {
    print("評価: $value");
  },
);
```

## 読み取り専用（表示のみ）の利用方法

```dart
FormRatingBar(
  initialValue: 4.5,
  readOnly: true,  // 評価値の変更ができない
);

// または.viewコンストラクタを使用
FormRatingBar.view(
  4.5,
  iconCount: 5,
  showLabel: true,
);
```

## タップのみで評価する

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  tapOnlyMode: true,  // ドラッグ無効、タップのみ
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## 縦方向の表示

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  direction: Axis.vertical,  // 縦方向に表示
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## アイコンビルダーでカスタマイズ

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  iconBuilder: (context, index) {
    // インデックスに応じて異なるアイコンを表示
    if (index == 0) return Icon(Icons.sentiment_very_dissatisfied);
    if (index == 1) return Icon(Icons.sentiment_dissatisfied);
    if (index == 2) return Icon(Icons.sentiment_neutral);
    if (index == 3) return Icon(Icons.sentiment_satisfied);
    return Icon(Icons.sentiment_very_satisfied);
  },
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## 最小値・最大値を設定

```dart
FormRatingBar(
  form: formController,
  initialValue: formController.value.rating,
  min: 0.5,  // 最小値0.5
  max: 10.0,  // 最大値10.0
  iconCount: 10,
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された評価値（`double`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。評価値が変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された評価値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、評価バーが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、評価値を変更できなくなります（表示のみ）。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期評価値を設定します（`num`型、内部で`double`に変換されます）。
- `controller`: テキストコントローラー。評価値のテキスト表示のコントロールを外部から制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `iconCount`: アイコンの数。評価に使用するアイコンの数を設定します。デフォルトは`5`です。
- `iconSize`: アイコンのサイズ。評価に使用するアイコンのサイズを設定します。デフォルトは`40.0`です。
- `activeColor`: アクティブなアイコンの色（選択された星の色）。未指定の場合は`Theme.of(context).primaryColor`が使用されます。
- `inactiveColor`: 非アクティブなアイコンの色（選択されていない星の色）。未指定の場合は`Theme.of(context).disabledColor`が使用されます。
- `min`: 最小評価値。デフォルトは`1.0`です。
- `max`: 最大評価値。未指定の場合は`iconCount`の値（double型）が使用されます。
- `icon`: アイコン（`Widget`型）。評価に使用するアイコンを設定します。未指定の場合は`Icons.star`が使用されます。
- `iconBuilder`: アイコンビルダー。インデックスに応じて異なるアイコンを生成する関数を定義します。`icon`より優先されます。
- `allowHalfRating`: 半星評価。`true`の場合、0.5単位での評価が可能になります。デフォルトは`true`です。
- `tapOnlyMode`: タップのみモード。`true`の場合、ドラッグが無効化されタップのみで評価が可能になります。デフォルトは`false`です。
- `direction`: 表示方向。`Axis.horizontal`（横並び）または`Axis.vertical`（縦並び）を設定します。デフォルトは`Axis.horizontal`です。
- `showLabel`: ラベルの表示。`true`の場合、評価値が数値として右側に表示されます。デフォルトは`false`です。
- `format`: ラベルのフォーマット。`showLabel`が`true`の場合の数値フォーマットを指定します。デフォルトは`"0.#"`です。
- `emptyErrorText`: 空のエラーメッセージ。評価値が選択されていない場合に表示するエラーメッセージを設定します。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- 評価値は`double`型で取り扱います。
- `readOnly`パラメータを`true`にすると、評価値を変更できなくなります。評価を表示する際などに利用してください。
- 読み取り専用で使用する場合は、`.view`コンストラクタを使用すると簡潔に記述できます。
- `icon`や`iconBuilder`パラメータを使用することで、カスタムアイコンを利用できます。
- `iconBuilder`は`icon`より優先されます。インデックスに応じて異なるアイコンを表示したい場合に使用します。
- `allowHalfRating`を`true`にすると、0.5単位での評価が可能になります（例: 3.5星）。
- `tapOnlyMode`を`true`にすると、ドラッグが無効化されタップのみで評価できます。
- `direction`を`Axis.vertical`にすると、縦方向に星が並びます。
- `showLabel`を`true`にすると、評価値が数値として右側（または下側）に表示されます。
- `format`は`showLabel`が`true`の場合の数値フォーマットを指定します（例: `"0.#"`は小数点1桁まで表示）。
- `min`と`max`で評価値の範囲を制限できます。
- `emptyErrorText`を設定すると、評価値が選択されていない場合にバリデーションエラーとして表示されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 最小評価値チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `iconCount`を用途に合わせて設定する（5段階、10段階など）
8. `iconSize`を設定して、UIに合わせた適切なサイズにする
9. 半星評価が必要な場合は`allowHalfRating: true`を設定する
10. `showLabel: true`と`format`を使用して、評価値を数値で明示的に表示する
11. 読み取り専用で表示する場合は`readOnly: true`または`.view`コンストラクタを使用する
12. カスタムアイコンを使用する場合は、`icon`（統一アイコン）または`iconBuilder`（インデックス別アイコン）を使用する
13. タッチデバイスで使いやすくするため、必要に応じて`tapOnlyMode: true`を設定する
14. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 商品レビューの評価（ECサイト、レビューサイト）
- サービス満足度の調査（アンケート、フィードバック）
- ユーザー評価システム（アプリ評価、コンテンツ評価）
- 難易度の設定（ゲーム難易度、タスク難易度）
- 優先度の設定（タスク優先度、重要度）
- 映画・動画の評価（レーティング、お気に入り度）
- レストラン・宿泊施設の評価（口コミ評価）
- スキルレベルの自己評価（スキル習熟度）
- 品質評価（製品品質、サービス品質）
- 顧客満足度調査（NPS、CSAT）
