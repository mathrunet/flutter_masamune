# `FormCheckbox`の利用方法

`FormCheckbox`は下記のように利用する。

## 概要

`Checkbox`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`Checkbox`の値を管理可能。ラベル付きチェックボックスやカスタムデザインなどの機能を備えています。

## 基本的な利用方法

```dart
FormCheckbox(
  form: formController,
  initialValue: formController.value.checked,
  onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormCheckbox(
  initialValue: true,
  onChanged: (value) {
    print(value);
  },
);
```

## ラベル付きチェックボックスの利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    labelText: "利用規約に同意する",
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## バリデーション付きの利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    labelText: "利用規約に同意する",
    validator: (value) {
      if (value != true) {
        return "利用規約への同意が必要です";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## カスタムデザインの適用

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    style: const FormStyle(
      padding: EdgeInsets.all(8.0),
      backgroundColor: Colors.grey[200],
      activeColor: Colors.blue,
    ),
    onSaved: (value) => formController.value.copyWith(checked: value),
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

- `labelText`: ラベルテキスト。チェックボックスの横に表示するテキストを設定します。`labelText`と`labelWidget`を両方設定することはできません。
- `labelWidget`: ラベルウィジェット。チェックボックスの横に表示するウィジェットを設定します。`labelText`と`labelWidget`を両方設定することはできません。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`もしくは`labelWidget`パラメータを使用して設定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 利用規約への同意
- 設定画面でのオプション選択
- フィルター条件の選択
- 複数選択可能なリストの項目選択
