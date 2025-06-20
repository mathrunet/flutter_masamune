# `FormTextField`の利用方法

`FormTextField`は下記のように利用する。

## 概要

`TextFormField`のMasamuneフレームワーク版。テキスト入力を行うフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`TextFormField`の値を管理可能。バリデーション、サジェスト機能、カスタムデザインなどの機能を備えています。

## 基本的な利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## サジェスト機能付きの利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  suggestion: const ["東京", "大阪", "名古屋", "福岡"],
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## バリデーション付きの利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return "必須項目です";
    }
    if (value!.length < 3) {
      return "3文字以上入力してください";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## カスタムデザインの適用

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
  onSaved: (value) => formController.value.copyWith(text: value),
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

- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。
- `inputFormatters`: 入力フォーマッター。入力値のフォーマットを定義します。
- `autofocus`: 自動フォーカス。`true`の場合、フォーム表示時に自動的にフォーカスされます。
- `autocorrect`: 自動修正。`true`の場合、入力中に自動的に修正されます。
- `onFocusChanged`: フォーカス時のコールバック。フォーカス時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。送信時の処理を定義します。
- `readOnly`: 読み取り専用。`true`の場合、テキストフィールドが読み取り専用になります。
- `obscureText`: パスワードマスク。`true`の場合、入力文字がマスクされます。
- `maxLines`: 最大行数。複数行入力を許可する場合に設定します。
- `minLines`: 最小行数。複数行入力を許可する場合に設定します。
- `lengthErrorText`: 桁数エラーメッセージ。入力された値の桁数が最大桁数を超えた場合に表示するエラーメッセージを設定します。
- `minLength`: 最小文字数。入力できる最小文字数を設定します。
- `maxLength`: 最大文字数。入力できる最大文字数を設定します。
- `expands`: 拡張。`true`の場合、テキストフィールドが拡張されます。
- `counterText`: カウンターテキスト。入力文字数のカウントを表示します。
- `counterbuilder`: カウンタービルダー。入力文字数のカウントを表示するためのウィジェットを定義します。
- `onTap`: タップ時のコールバック。タップ時の処理を定義します。
- `suggestion`: サジェスト候補。入力補完として表示する候補を設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- ヒントテキストは`hintText`パラメータを使用して設定できます。
- 空のエラーメッセージは`emptyErrorText`パラメータを使用して設定できます。
- キーボードのタイプは`keyboardType`パラメータを使用して設定できます。
- 入力フォーマッターは`inputFormatters`パラメータを使用して設定できます。
- 自動フォーカスは`autofocus`パラメータを使用して設定できます。
- 自動修正は`autocorrect`パラメータを使用して設定できます。
- `maxLines`および`minLines`と`expands`は同時に使用できません。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- ユーザー名の入力
- パスワードの入力
- メールアドレスの入力
- メモや投稿のコンテンツ入力
- 電話番号の入力
- 住所の入力
- その他プレーンテキストの入力
