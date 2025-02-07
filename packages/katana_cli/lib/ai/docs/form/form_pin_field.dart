import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_pin_field.mdc.
///
/// form_pin_field.mdcの中身。
class KatanaFormPinFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_pin_field.mdc.
  ///
  /// form_pin_field.mdcの中身。
  const KatanaFormPinFieldMdcCliAiCode();

  @override
  String get name => "`FormPinField`の利用方法";

  @override
  String get description => "PINコード入力用のフォームフィールドである`FormPinField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "PINコード入力用のフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでPINコードの状態管理を行えます。桁数設定、マスク表示、自動フォーカス移動などの機能を備えています。";

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
    length: 4,
    onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## マスク表示付きの利用方法

```dart
FormPinField(
    form: formController,
    length: 6,
    obscureText: true,
    onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## バリデーション付きの利用方法

```dart
FormPinField(
    form: formController,
    length: 4,
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
    length: 4,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      pinFieldStyle: PinFieldStyle(
        width: 50.0,
        height: 50.0,
        spacing: 16.0,
        backgroundColor: Colors.white,
        borderColor: Colors.blue,
        focusedBorderColor: Colors.blue[700],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        textStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## 自動フォーカス移動の設定

```dart
FormPinField(
    form: formController,
    length: 4,
    autoFocus: true,
    autoDismissKeyboard: true,
    onCompleted: (value) {
      // PINコードの入力が完了した時の処理
      print("Completed: \$value");
    },
    onSaved: (value) => formController.value.copyWith(pin: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `length`: PINコードの桁数。入力フィールドの数を設定します。
- `onSaved`: 保存時のコールバック。入力された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期値を設定します。
- `obscureText`: マスク表示。`true`の場合、入力値をマスク表示します。
- `validator`: バリデーション関数。入力値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、入力が無効化されます。
- `autoFocus`: 自動フォーカス。`true`の場合、表示時に最初のフィールドにフォーカスします。
- `autoDismissKeyboard`: キーボード自動非表示。`true`の場合、入力完了時にキーボードを非表示にします。
- `onCompleted`: 完了時のコールバック。全桁の入力が完了した時の処理を定義します。

## 注意点

- `FormController`と組み合わせて使用することで、PINコードの状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- マスク表示は`obscureText`パラメータで制御できます。
- 自動フォーカス移動は`autoFocus`パラメータで制御できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. セキュリティが必要な場合はマスク表示を有効にする
3. 適切なバリデーションを設定する
4. ユーザビリティを考慮して自動フォーカス移動を設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 認証コードの入力
- セキュリティコードの入力
- 確認コードの入力
- ワンタイムパスワードの入力
- PINコードの設定
""";
  }
}
