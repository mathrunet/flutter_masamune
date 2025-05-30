// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_pin_field.md.
///
/// form_pin_field.mdの中身。
class KatanaFormPinFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_pin_field.md.
  ///
  /// form_pin_field.mdの中身。
  const KatanaFormPinFieldMdCliAiCode();

  @override
  String get name => "`FormPinField`の利用方法";

  @override
  String get description => "PINコード入力用のフォームフィールドである`FormPinField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "PINコード入力用のフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでPINコードの状態管理を行えます。桁数設定などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormPinField`は下記のように利用する。

## 概要

$excerpt

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
    if (!RegExp(r'^[0-9]+\$').hasMatch(value)) {
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
  ),
  onSaved: (value) => formController.value.copyWith(pin: value),
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

- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。
- `lengthErrorText`: 桁数エラーメッセージ。入力された値の桁数が最大桁数を超えた場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- 桁数の設定は`maxLength`パラメータを使用して行えます。
- バリデーションは`validator`パラメータを使用して定義します。
- キーボードのタイプは`keyboardType`パラメータを使用して設定します。
- 空のエラーメッセージは`emptyErrorText`パラメータを使用して設定します。
- 桁数エラーメッセージは`lengthErrorText`パラメータを使用して設定します。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. 桁数の設定は`maxLength`パラメータを使用して行える。
7. バリデーションは`validator`パラメータを使用して定義する。
8. キーボードのタイプは`keyboardType`パラメータを使用して設定します。
9. 空のエラーメッセージは`emptyErrorText`パラメータを使用して設定します。
10. 桁数エラーメッセージは`lengthErrorText`パラメータを使用して設定します。

## 利用シーン

- 認証コードの入力
- セキュリティコードの入力
- 確認コードの入力
- ワンタイムパスワードの入力
- PINコードの設定
""";
  }
}
