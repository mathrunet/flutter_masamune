import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_text_field.mdc.
///
/// form_text_field.mdcの中身。
class KatanaFormTextFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_text_field.mdc.
  ///
  /// form_text_field.mdcの中身。
  const KatanaFormTextFieldMdcCliAiCode();

  @override
  String get name => "`FormTextField`の利用方法";

  @override
  String get description => "テキスト入力を行うためのフォームフィールドである`FormTextField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`TextFormField`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`TextFormField`の値を管理可能。バリデーション、サジェスト機能、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormTextField`は下記のように利用する。

## 概要

$excerpt

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
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。入力値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期値を設定します。
- `suggestion`: サジェスト候補。入力補完として表示する候補を設定します。
- `validator`: バリデーション関数。入力値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、フォームが無効化されます。
- `obscureText`: パスワードマスク。`true`の場合、入力文字がマスクされます。
- `maxLines`: 最大行数。複数行入力を許可する場合に設定します。
- `keyboardType`: キーボードタイプ。入力に適したキーボードを表示します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- サジェスト機能は`suggestion`パラメータを使用して実装できます。
- `enabled`パラメータを使用することで、フォームの有効/無効を制御できます。
- パスワード入力などのセキュアな入力には`obscureText`を使用します。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. バリデーションは適切なエラーメッセージを返すようにする
3. ユーザーの入力をサポートするためにサジェスト機能を活用する
4. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
""";
  }
}
