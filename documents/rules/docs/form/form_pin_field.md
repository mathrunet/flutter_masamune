# `FormPinField`の利用方法

`FormPinField`は下記のように利用する。

## 概要

PINコード入力用のフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでPINコードの状態管理を行えます。桁数設定などの機能を備えています。

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormPinField(
        initialValue: formController.value.pin,
        onSaved: (value) => formController.value.copyWith(pin: value),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormPinField(
  form: formController,
  initialValue: formController.value.pin,
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## 基本的な利用方法

```dart
FormPinField(
  form: formController,
  initialValue: "1234",
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## 最大桁数を指定した利用方法

```dart
FormPinField(
  form: formController,
  onSaved: (value) => formController.value.copyWith(pin: value),
  maxLength: 6,
);
```

## バリデーション付きの利用方法

```dart
FormPinField(
  form: formController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "PINコードを入力してください";
    }
    if (value.length != 4) {
      return "PINコードは4桁で入力してください";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "PINコードは数字のみ入力可能です";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## カスタムデザインの適用

```dart
FormPinField(
  form: formController,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderColor: Colors.blue,
  ),
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormPinField(
  initialValue: "1234",
  maxLength: 4,
  onChanged: (value) {
    print("PIN: $value");
  },
);
```

## パスワードのように非表示にする

```dart
FormPinField(
  form: formController,
  initialValue: formController.value.pin,
  obscureText: true,  // PINコードを非表示
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## 自動フォーカスの利用方法

```dart
FormPinField(
  form: formController,
  initialValue: formController.value.pin,
  autofocus: true,  // 画面表示時に自動でフォーカス
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## 読み取り専用の利用方法

```dart
FormPinField(
  form: formController,
  initialValue: formController.value.pin,
  readOnly: true,  // 入力不可
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## 最小桁数と最大桁数を設定

```dart
FormPinField(
  form: formController,
  maxLength: 6,  // 最大6桁
  minLength: 4,  // 最小4桁
  lengthErrorText: "4桁以上入力してください",
  onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。入力されたPINコード（`String`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。PINコードが変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。入力されたPINコードの検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、PINフィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、入力ができなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期PINコードを設定します（`String`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `maxLength`: PINコードの最大桁数。デフォルトは`6`です。
- `minLength`: PINコードの最小桁数。未指定の場合は制限なしです。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `emptyErrorText`: 空のエラーメッセージ。PINコードが入力されていない場合に表示するエラーメッセージを設定します。
- `lengthErrorText`: 桁数エラーメッセージ。入力された値の桁数が`minLength`未満の場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.phone`です。
- `textInputAction`: テキスト入力アクション。キーボードのアクションボタンを設定します。デフォルトは`TextInputAction.done`です。
- `obscureText`: 入力内容を隠すかどうか。`true`の場合、PINコードが非表示になります（パスワード表示用）。デフォルトは`false`です。
- `autofocus`: 自動フォーカス。`true`の場合、画面表示時に自動的にフォーカスされます。デフォルトは`false`です。
- `inputFormatters`: 入力フォーマッター。入力内容を制限するフォーマッターのリストを設定します。
- `autocorrect`: 自動修正。デフォルトは`false`です。
- `enableInteractiveSelection`: 対話的な選択を有効にするかどうか。デフォルトは`false`です。
- `autofillHints`: 自動入力のヒント。
- `mouseCursor`: マウスカーソルの種類。
- `textCapitalization`: テキストの大文字化設定。デフォルトは`TextCapitalization.none`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- PINコードは`String`型で取り扱います。
- `maxLength`で最大桁数を設定します。デフォルトは`6`桁です。
- `minLength`で最小桁数を設定できます。未指定の場合は制限なしです。
- `lengthErrorText`は`minLength`未満の場合に表示されるエラーメッセージです。
- `readOnly`が`true`の場合、入力ができなくなります。
- `obscureText`を`true`にすると、パスワードのようにPINコードが非表示になります。
- `autofocus`を`true`にすると、画面表示時に自動的にPINフィールドにフォーカスされます。
- `emptyErrorText`を設定すると、PINコードが入力されていない場合にバリデーションエラーとして表示されます。
- デフォルトのキーボードタイプは`TextInputType.phone`（数字キーパッド）です。
- `inputFormatters`を使用して、数字のみの入力制限などを設定できます。
- PINコードは各桁が独立した入力ボックスとして表示されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 桁数チェック、数字のみチェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `maxLength`を用途に合わせて設定する（4桁、6桁など）
8. `minLength`と`lengthErrorText`を組み合わせて、最小桁数のバリデーションを実装する
9. セキュリティが必要な場合は`obscureText: true`を設定する
10. 認証コード入力画面では`autofocus: true`を設定して、ユーザビリティを向上させる
11. `inputFormatters`で`FilteringTextInputFormatter.digitsOnly`を使用して、数字のみの入力に制限する
12. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 認証コードの入力（2FA、MFA認証）
- セキュリティコードの入力（アプリロック解除）
- 確認コードの入力（SMS認証、メール認証）
- ワンタイムパスワードの入力（OTP、TOTP）
- PINコードの設定（新規PIN設定、PIN変更）
- クレジットカードセキュリティコード入力（CVV、CVC）
- 銀行暗証番号の入力（ATM暗証番号）
- ロック解除PIN（スマホロック、アプリロック）
- 親権者確認コード（ペアレンタルコントロール）
- 管理者パスコード入力（管理者権限確認）
