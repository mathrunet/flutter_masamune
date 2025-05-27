// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_rating_bar.md.
///
/// form_rating_bar.mdの中身。
class KatanaFormRatingBarMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_rating_bar.md.
  ///
  /// form_rating_bar.mdの中身。
  const KatanaFormRatingBarMdCliAiCode();

  @override
  String get name => "`FormRatingBar`の利用方法";

  @override
  String get description => "評価を星やアイコンで入力するためのフォームフィールドである`FormRatingBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "評価を星やアイコンで入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで評価値を管理できます。カスタムアイコン、半星表示、タップ・ドラッグでの入力などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormRatingBar`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormRatingBar(
    form: formController,
    initialValue: formController.value.rating,
    onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## カスタムアイコンの利用方法

```dart
FormRatingBar(
    form: formController,
    initialValue: formController.value.rating,
    itemBuilder: (context, index) {
      return Icon(
        index >= formController.value.rating ? Icons.favorite_border : Icons.favorite,
        color: Colors.pink,
      );
    },
    onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## 半星表示の利用方法

```dart
FormRatingBar(
    form: formController,
    initialValue: formController.value.rating,
    allowHalfRating: true,
    itemCount: 5,
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
      ratingStyle: RatingStyle(
        itemSize: 40.0,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        unratedColor: Colors.grey[300],
        ratedColor: Colors.amber,
      ),
    ),
    onSaved: (value) => formController.value.copyWith(rating: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。評価値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期評価値を設定します。
- `itemCount`: アイテム数。評価に使用するアイテムの数を設定します。
- `itemBuilder`: アイテムビルダー。カスタムアイコンを生成する関数を定義します。
- `allowHalfRating`: 半星評価。`true`の場合、0.5単位での評価が可能になります。
- `validator`: バリデーション関数。評価値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、評価入力が無効化されます。
- `onChanged`: 値変更時のコールバック。評価値が変更された時の処理を定義します。

## 注意点

- `FormController`と組み合わせて使用することで、評価値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- カスタムアイコンは`itemBuilder`で定義できます。
- 半星評価は`allowHalfRating`で有効化できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 用途に応じて適切なアイテム数を設定する
3. 必要に応じて半星評価を有効にする
4. 分かりやすいアイコンやデザインを使用する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 商品レビューの評価
- サービス満足度の調査
- ユーザー評価システム
- 難易度の設定
- 優先度の設定
""";
  }
}
