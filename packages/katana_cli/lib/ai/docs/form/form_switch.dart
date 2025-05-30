// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_switch.md.
///
/// form_switch.mdの中身。
class KatanaFormSwitchMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_switch.md.
  ///
  /// form_switch.mdの中身。
  const KatanaFormSwitchMdCliAiCode();

  @override
  String get name => "`FormSwitch`の利用方法";

  @override
  String get description => "トグルスイッチを表示し切り替えるためのフォームフィールドである`FormSwitch`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Switch`のMasamuneフレームワーク版。トグルスイッチを表示し切り替えるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでスイッチの値を管理可能。ラベル付きスイッチ、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormSwitch`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## ラベル付きの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  labelText: "通知を有効にする",
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## バリデーション付きの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  validator: (value) {
    if (value != true) {
      return "利用規約への同意が必要です";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## カスタムデザインの適用

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.grey[200],
  ),
  onSaved: (value) => formController.value.copyWith(enabled: value),
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

- 設定画面でのON/OFF切り替え
- 通知設定の有効/無効
- プライバシー設定の切り替え
- 機能の有効/無効化
- モード切り替え
""";
  }
}
