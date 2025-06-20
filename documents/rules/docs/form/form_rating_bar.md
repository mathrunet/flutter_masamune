# `FormRatingBar`の利用方法

`FormRatingBar`は下記のように利用する。

## 概要

評価を星やアイコンで入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで評価値を管理できます。カスタムアイコン、半星表示、タップ・ドラッグでの入力、ラベルの表示などの機能を備えています。

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
  ),
  onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。
- `focusNode`: フォーカスノード。フォームのフォーカスを設定します。

- `iconCount`: アイコンの数。評価に使用するアイコンの数を設定します。
- `iconSize`: アイコンのサイズ。評価に使用するアイコンのサイズを設定します。
- `readOnly`: 読み取り専用。`true`の場合、評価値を変更できなくなります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `activeColor`: アクティブなアイコンの色。評価に使用するアイコンの色を設定します。
- `inactiveColor`: 非アクティブなアイコンの色。評価に使用するアイコンの色を設定します。
- `min`: 最小値。評価に使用する最小値を設定します。
- `max`: 最大値。評価に使用する最大値を設定します。
- `iconBuilder`: アイコンビルダー。カスタムアイコンを生成する関数を定義します。
- `allowHalfRating`: 半星評価。`true`の場合、0.5単位での評価が可能になります。
- `tapOnlyMode`: タップのみモード。`true`の場合、タップのみで評価が可能になります。
- `direction`: 方向。評価の方向を設定します。
- `showLabel`: ラベルの表示。`true`の場合、ラベルを表示します。
- `icon`: アイコン。評価に使用するアイコンを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- ラベルの表示は`showLabel`パラメータを使用して設定します。
- ラベルのフォーマットは`format`パラメータを使用して設定します。
- `readOnly`パラメータを`true`にすると、評価値を変更できなくなります。評価を表示する際などに利用してください。
- `icon`や`iconBuilder`パラメータを使用することで、カスタムアイコンを利用できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. アイコンの数は`iconCount`パラメータを使用して設定する。
7. アイコンのサイズは`iconSize`パラメータを使用して設定する。
8. 半星評価は`allowHalfRating`パラメータを使用して設定する。
9. ラベルの表示は`showLabel`パラメータを使用して設定する。
10. ラベルのフォーマットは`format`パラメータを使用して設定する。
11. 読み取り専用は`readOnly`パラメータを使用して設定する。
12. カスタムアイコンは`icon`や`iconBuilder`パラメータを使用して設定する。

## 利用シーン

- 商品レビューの評価
- サービス満足度の調査
- ユーザー評価システム
- 難易度の設定
- 優先度の設定
