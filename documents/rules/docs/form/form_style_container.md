# `FormContainer`の利用方法

`FormContainer`は下記のように利用する。

## 概要

`FormStyle`を適用するためのコンテナウィジェット。パディング、背景色、ボーダー、影などのスタイルを統一的に管理できます。また、任意の値のバリデーションを行うことができます。

## 基本的な利用方法

```dart
FormContainer(
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    elevation: 4.0,
    border: Border.all(
      color: Colors.grey[300],
      width: 1.0,
    ),
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormPasswordBuilder(...),
      FormRatingBar(...),
    ],
  ),
);
```

## バリデーションの利用方法

```dart
FormContainer(
  form: formController,
  validator: (value) {
    if (value == null || value.isEmpty) {
        return "値を入力してください";
    }
    return null;
  },
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    elevation: 4.0,
    border: Border.all(
      color: Colors.grey[300],
      width: 1.0,
    ),
  ),
  child: Column(
    children: [
      FormTextField(...),
      FormPasswordBuilder(...),
      FormRatingBar(...),
    ],
  ),
);
```

```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。定義する場合は`form`パラメータも定義する必要があります。
- `enabled`: 有効/無効。`false`の場合、子ウィジェットが無効化されます。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインを定義します。
- `child`: 子ウィジェット。スタイルを適用する対象のウィジェットを指定します。
- `prefix`: プレフィックス。ウィジェットの前に表示するウィジェットを指定します。
- `suffix`: サフィックス。ウィジェットの後に表示するウィジェットを指定します。

## 注意点

- 子ウィジェットで個別に`FormStyle`を指定すると、そのスタイルが優先されます。
- `enabled`パラメータは子ウィジェットすべてに影響します。
- バリデーションは`validator`パラメータを使用して定義します。その場合は`form`パラメータも定義する必要があります。

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために使用する
2. 関連するフォームフィールドをグループ化する
3. 階層構造を活用して効率的にスタイルを管理する
4. バリデーションは`validator`パラメータを使用して定義する。その場合は`form`パラメータも定義する必要があります。

## 利用シーン

- フォームのグループ化
- セクション別のスタイル適用
- 共通デザインの一括適用
- フォームのレイアウト管理
- デザインテーマの実装
