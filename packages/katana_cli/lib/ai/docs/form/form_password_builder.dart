import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_password_builder.mdc.
///
/// form_password_builder.mdcの中身。
class KatanaFormPasswordBuilderMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_password_builder.mdc.
  ///
  /// form_password_builder.mdcの中身。
  const KatanaFormPasswordBuilderMdcCliAiCode();

  @override
  String get name => "`FormPasswordBuilder`の利用方法";

  @override
  String get description => "パスワード入力用のフォームビルダーである`FormPasswordBuilder`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "パスワード入力用のフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでパスワードの状態管理を行えます。パスワードの表示/非表示切り替え、強度チェック、確認入力などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormPasswordBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormPasswordBuilder(
    form: formController,
    builder: (context, form, showPassword) {
      return FormTextField(
        form: form,
        initialValue: formController.value.password,
        obscureText: !showPassword,
        onSaved: (value) => formController.value.copyWith(password: value),
      );
    },
);
```

## パスワード強度チェック付きの利用方法

```dart
FormPasswordBuilder(
    form: formController,
    strengthChecker: (password) {
      if (password == null || password.isEmpty) {
        return PasswordStrength.none;
      }
      if (password.length < 8) {
        return PasswordStrength.weak;
      }
      if (password.contains(RegExp(r'[A-Z]')) &&
          password.contains(RegExp(r'[a-z]')) &&
          password.contains(RegExp(r'[0-9]'))) {
        return PasswordStrength.strong;
      }
      return PasswordStrength.medium;
    },
    builder: (context, form, showPassword) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: formController.value.password,
            obscureText: !showPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "パスワードを入力してください";
              }
              if (value.length < 8) {
                return "パスワードは8文字以上必要です";
              }
              return null;
            },
            onSaved: (value) => formController.value.copyWith(password: value),
          ),
          PasswordStrengthIndicator(
            strength: form.passwordStrength,
          ),
        ],
      );
    },
);
```

## 確認入力付きの利用方法

```dart
FormPasswordBuilder(
    form: formController,
    confirmPassword: true,
    builder: (context, form, showPassword) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: formController.value.password,
            obscureText: !showPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "パスワードを入力してください";
              }
              return null;
            },
            onSaved: (value) => formController.value.copyWith(password: value),
          ),
          const SizedBox(height: 16),
          FormTextField(
            form: form,
            initialValue: formController.value.confirmPassword,
            obscureText: !showPassword,
            validator: (value) {
              if (value != form.password) {
                return "パスワードが一致しません";
              }
              return null;
            },
            onSaved: (value) => formController.value.copyWith(confirmPassword: value),
          ),
        ],
      );
    },
);
```

## カスタムデザインの適用

```dart
FormPasswordBuilder(
    form: formController,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      textFieldStyle: TextFieldStyle(
        obscureIconColor: Colors.blue,
        strengthIndicatorStyle: StrengthIndicatorStyle(
          weakColor: Colors.red,
          mediumColor: Colors.orange,
          strongColor: Colors.green,
          height: 4.0,
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      ),
    ),
    builder: (context, form, showPassword) {
      return FormTextField(
        form: form,
        initialValue: formController.value.password,
        obscureText: !showPassword,
        onSaved: (value) => formController.value.copyWith(password: value),
      );
    },
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `builder`: ビルダー関数。パスワード入力フィールドを生成します。

### オプションパラメータ
- `strengthChecker`: パスワード強度チェック関数。パスワードの強度を評価します。
- `confirmPassword`: 確認入力。`true`の場合、確認用パスワード入力を有効にします。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、入力が無効化されます。
- `autovalidateMode`: 自動検証モード。入力値の検証タイミングを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、パスワードの状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- パスワードの表示/非表示は`showPassword`パラメータで制御できます。
- パスワード強度は`strengthChecker`で評価できます。
- 確認入力は`confirmPassword`パラメータで有効化できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 適切なパスワード強度チェックを実装する
3. 必要に応じて確認入力を有効にする
4. 分かりやすいバリデーションメッセージを設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- ユーザー登録
- パスワード変更
- セキュリティ設定
- アカウント管理
- 認証画面
""";
  }
}
