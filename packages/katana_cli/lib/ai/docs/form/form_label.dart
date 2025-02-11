// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_label.mdc.
///
/// form_label.mdcの中身。
class KatanaFormLabelMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_label.mdc.
  ///
  /// form_label.mdcの中身。
  const KatanaFormLabelMdcCliAiCode();

  @override
  String get name => "`FormLabel`の利用方法";

  @override
  String get description => "フォームフィールドのラベルを表示するための`FormLabel`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "フォームフィールドのラベルを表示するためのウィジェット。`FormStyle`で共通したデザインを適用可能。必須マーク、ヘルプテキスト、エラーメッセージなどの表示機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormLabel`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormLabel(
    form: formController,
    label: "ユーザー名",
    child: FormTextField(
      form: formController,
      initialValue: formController.value.name,
      onSaved: (value) => formController.value.copyWith(name: value),
    ),
);
```

## 必須マーク付きの利用方法

```dart
FormLabel(
    form: formController,
    label: "メールアドレス",
    required: true,
    child: FormTextField(
      form: formController,
      initialValue: formController.value.email,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "メールアドレスは必須です";
        }
        return null;
      },
      onSaved: (value) => formController.value.copyWith(email: value),
    ),
);
```

## ヘルプテキスト付きの利用方法

```dart
FormLabel(
    form: formController,
    label: "パスワード",
    required: true,
    help: "8文字以上の英数字を入力してください",
    child: FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: true,
      validator: (value) {
        if (value?.length ?? 0 < 8) {
          return "パスワードは8文字以上必要です";
        }
        return null;
      },
      onSaved: (value) => formController.value.copyWith(password: value),
    ),
);
```

## エラーメッセージ付きの利用方法

```dart
FormLabel(
    form: formController,
    label: "年齢",
    error: "有効な年齢を入力してください",
    child: FormNumField(
      form: formController,
      initialValue: formController.value.age,
      validator: (value) {
        if (value == null) {
          return "年齢を入力してください";
        }
        if (value < 0 || value > 120) {
          return "有効な年齢を入力してください";
        }
        return null;
      },
      onSaved: (value) => formController.value.copyWith(age: value),
    ),
);
```

## カスタムデザインの適用

```dart
FormLabel(
    form: formController,
    label: "プロフィール",
    style: const FormStyle(
      labelStyle: LabelStyle(
        textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        requiredMarkColor: Colors.red,
        helpTextStyle: TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
        errorTextStyle: TextStyle(
          fontSize: 12.0,
          color: Colors.red,
        ),
        spacing: 8.0,
      ),
    ),
    child: FormTextField(
      form: formController,
      initialValue: formController.value.profile,
      onSaved: (value) => formController.value.copyWith(profile: value),
    ),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `label`: ラベルテキスト。フィールドの説明ラベルを設定します。
- `child`: 子ウィジェット。ラベルの下に表示するフォームフィールドを設定します。

### オプションパラメータ
- `required`: 必須マーク。`true`の場合、必須マークを表示します。
- `help`: ヘルプテキスト。フィールドの説明文を設定します。
- `error`: エラーメッセージ。バリデーションエラー時のメッセージを設定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 有効/無効。`false`の場合、ラベルとフィールドが無効化されます。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- 必須フィールドには`required`パラメータを設定します。
- ヘルプテキストは`help`パラメータで追加できます。
- エラーメッセージは`error`パラメータで表示できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 必須フィールドには必ず必須マークを表示する
3. 分かりやすいヘルプテキストを提供する
4. エラーメッセージは具体的で分かりやすく設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- フォームフィールドのラベル表示
- 必須入力項目の明示
- フィールドの説明表示
- バリデーションエラーの表示
- フォームのセクション分け
""";
  }
}
