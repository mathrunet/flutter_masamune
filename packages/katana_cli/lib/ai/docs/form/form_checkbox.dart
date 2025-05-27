// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_checkbox.md.
///
/// form_checkbox.mdの中身。
class KatanaFormCheckboxMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_checkbox.md.
  ///
  /// form_checkbox.mdの中身。
  const KatanaFormCheckboxMdCliAiCode();

  @override
  String get name => "`FormCheckbox`の利用方法";

  @override
  String get description => "フォームのチェックボックスを表示するための`FormCheckbox`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Checkbox`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`Checkbox`の値を管理可能。ラベル付きチェックボックスやカスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormCheckbox`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## ラベル付きチェックボックスの利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    label: "利用規約に同意する",
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## バリデーション付きの利用方法

```dart
FormCheckbox(
    form: formController,
    initialValue: formController.value.checked,
    label: "利用規約に同意する",
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
      checkColor: Colors.white,
    ),
    onSaved: (value) => formController.value.copyWith(checked: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。チェック状態の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。
- `label`: ラベルテキスト。チェックボックスの横に表示するテキストを設定します。
- `validator`: バリデーション関数。チェック状態の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `tristate`: 3状態の許可。`true`の場合、null値を含む3状態が許可されます。

## 注意点

- `FormController`と組み合わせて使用することで、チェックボックスの状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- ラベルテキストは`label`パラメータを使用して設定できます。
- `enabled`パラメータを使用することで、チェックボックスの有効/無効を制御できます。
- `tristate`を使用することで、未定義状態（null）を含む3状態のチェックボックスを実装できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. ユーザーにとって分かりやすいラベルテキストを設定する
3. 必須チェックの場合は適切なバリデーションメッセージを設定する
4. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
5. チェックボックスの状態変更時の処理は`onChanged`で実装する

## 利用シーン

- 利用規約への同意
- 設定画面でのオプション選択
- フィルター条件の選択
- 複数選択可能なリストの項目選択
""";
  }
}
