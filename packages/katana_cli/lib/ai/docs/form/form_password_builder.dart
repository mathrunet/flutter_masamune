// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_password_builder.md.
///
/// form_password_builder.mdの中身。
class KatanaFormPasswordBuilderMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_password_builder.md.
  ///
  /// form_password_builder.mdの中身。
  const KatanaFormPasswordBuilderMdCliAiCode();

  @override
  String get name => "`FormPasswordBuilder`の利用方法";

  @override
  String get description =>
      "パスワード入力時の内容を隠すかどうかを切り替えることができるフォームビルダーである`FormPasswordBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "パスワード入力時の内容を隠すかどうかを切り替えることができるフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでパスワードの状態管理を行えます。パスワードの表示/非表示切り替え、および表示切替のトグルスイッチの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormPasswordBuilder`は下記のように利用する。

## 概要

$excerpt

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormPasswordBuilder`は`FormTextField`などのパスワード入力フィールドを囲んで使用します。`FormController`の配置は内部の`FormTextField`で行います。

```dart
final formController = FormController();

FormPasswordBuilder(
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,  // obscureパラメータをそのまま渡す
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
);
```

## 基本的な利用方法

```dart
FormPasswordBuilder(
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
);
```

## 自由なトグルスイッチの利用方法

```dart
FormPasswordBuilder(
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
  switchBuilder: (context, obscure, onSwitch) {
    return Positioned.fill(
      right: 16,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.zero,
          child: IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onSwitch,
            color: Colors.blue,
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            padding: const EdgeInsets.only(top: 16),
            constraints: const BoxConstraints(),
          ),
        ),
      ),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormPasswordBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
);
```

## トグルスイッチのカスタマイズ

```dart
FormPasswordBuilder(
  switchColor: Colors.blue,
  switchPadding: EdgeInsets.only(right: 8),
  switchAlignment: Alignment.centerRight,
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
);
```

## パスワード確認フィールドとの組み合わせ

```dart
Column(
  children: [
    FormPasswordBuilder(
      builder: (context, obscure) {
        return FormTextField(
          form: formController,
          labelText: "パスワード",
          initialValue: formController.value.password,
          obscureText: obscure,
          onSaved: (value) => formController.value.copyWith(password: value),
        );
      },
    ),
    FormPasswordBuilder(
      builder: (context, obscure) {
        return FormTextField(
          form: formController,
          labelText: "パスワード（確認）",
          initialValue: formController.value.confirmPassword,
          obscureText: obscure,
          onSaved: (value) => formController.value.copyWith(confirmPassword: value),
        );
      },
    ),
  ],
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。`BuildContext`と`bool obscure`を受け取り、パスワード入力フィールド（通常は`FormTextField`）を生成します。

### オプションパラメータ
- `switcherBuilder`: トグルスイッチビルダー関数。`BuildContext`、`bool obscure`、`VoidCallback onSwitch`を受け取り、カスタムトグルスイッチを生成します。未指定の場合はデフォルトのトグルスイッチが表示されます。
- `padding`: テキストフィールドのパディング。`builder`で生成されたフィールドの外側のパディングを設定します。
- `switchPadding`: トグルスイッチのパディング。トグルスイッチの内側のパディングを設定します。
- `switchAlignment`: トグルスイッチの配置。トグルスイッチの位置を設定します。デフォルトは`Alignment.centerRight`です。
- `switchColor`: トグルスイッチの色。トグルスイッチのアイコン色を設定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。

### デフォルトのトグルスイッチ仕様
- アイコン: パスワード非表示時は`Icons.visibility_off`、表示時は`Icons.visibility`
- 位置: 右寄せ（`Alignment.centerRight`）
- 動作: クリックで表示/非表示を切り替え

## 注意点

- このビルダーは`FormTextField`などのパスワード入力フォームフィールドと組み合わせて利用します。
- `builder`の`obscure`パラメータでパスワードの表示/非表示を判別します。
- `obscure`が`true`の場合はパスワードが隠され、`false`の場合は表示されます。
- `builder`で生成したフォームフィールドの上にトグルスイッチが`Stack`で重ねて表示されます。
- `switcherBuilder`を指定すると、デフォルトのトグルスイッチの代わりにカスタムスイッチが表示されます。
- `switcherBuilder`内で`onSwitch`を呼び出すと、`obscure`の値が反転します。
- トグルスイッチは`Positioned.fill`で配置されるため、フィールドの右側に表示されます。
- デフォルトのトグルスイッチは`IconButton`で実装されており、視覚的にコンパクトです（`VisualDensity.compact`）。
- `padding`は`builder`で生成されたフィールド全体のパディングで、`switchPadding`はトグルスイッチのみのパディングです。
- `FormController`の配置や管理は、内部の`FormTextField`で行います（`FormPasswordBuilder`自体は`FormController`を持ちません）。

## ベストプラクティス

1. `FormTextField`などのパスワード入力フォームフィールドと組み合わせて利用する
2. `builder`の`obscure`パラメータを、そのまま`FormTextField`の`obscureText`パラメータに渡す
3. デフォルトのトグルスイッチで十分な場合は`switcherBuilder`を指定しない
4. カスタムトグルスイッチが必要な場合は`switcherBuilder`を使用する
5. `switcherBuilder`内で必ず`onSwitch`を呼び出すボタンやウィジェットを配置する
6. トグルスイッチの色やアライメントは`switchColor`、`switchAlignment`で調整する
7. パスワードと確認用パスワードの2つのフィールドを使用する場合、それぞれに`FormPasswordBuilder`を使用する
8. `FormContainer`と組み合わせて、パスワードと確認用パスワードのバリデーション（一致確認）を実装する

## 利用シーン

- ユーザー登録（新規アカウント作成）
- パスワード変更（パスワードリセット、パスワード更新）
- セキュリティ設定（パスワード管理、セキュリティ強化）
- アカウント管理（プロフィール編集）
- 認証画面（ログイン、サインイン）
- パスワード再設定（パスワード忘れ）
- 初期設定（初回パスワード設定）
- 暗証番号入力（PINコード、セキュリティコード）
- 二段階認証（確認用パスワード）
- 管理者パスワード入力（管理者権限確認）
""";
  }
}
