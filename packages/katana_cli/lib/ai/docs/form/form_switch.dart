import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_switch.mdc.
///
/// form_switch.mdcの中身。
class KatanaFormSwitchMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_switch.mdc.
  ///
  /// form_switch.mdcの中身。
  const KatanaFormSwitchMdcCliAiCode();

  @override
  String get name => "`FormSwitch`の利用方法";

  @override
  String get description => "スイッチを表示し切り替えるためのフォームフィールドである`FormSwitch`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Switch`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでスイッチの値を管理可能。ラベル付きスイッチ、カスタムデザイン、アニメーションなどの機能を備えています。";

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
    label: "通知を有効にする",
    onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## バリデーション付きの利用方法

```dart
FormSwitch(
    form: formController,
    initialValue: formController.value.enabled,
    label: "利用規約に同意する",
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
      switchStyle: SwitchStyle(
        activeColor: Colors.blue,
        activeTrackColor: Colors.blue[200],
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey[300],
      ),
    ),
    onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## アニメーション付きの利用方法

```dart
FormSwitch(
    form: formController,
    initialValue: formController.value.enabled,
    label: "通知を有効にする",
    animationDuration: const Duration(milliseconds: 300),
    onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。スイッチの状態の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期状態を設定します。
- `label`: ラベルテキスト。スイッチの横に表示するテキストを設定します。
- `validator`: バリデーション関数。スイッチの状態の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、スイッチが無効化されます。
- `animationDuration`: アニメーション時間。状態変更時のアニメーション時間を設定します。
- `onChanged`: 変更時のコールバック。スイッチの状態が変更された時の処理を定義します。

## 注意点

- `FormController`と組み合わせて使用することで、スイッチの状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- ラベルテキストは`label`パラメータを使用して設定できます。
- `enabled`パラメータを使用することで、スイッチの有効/無効を制御できます。
- アニメーションは`animationDuration`で調整できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. ユーザーにとって分かりやすいラベルテキストを設定する
3. 必須の設定項目の場合は適切なバリデーションメッセージを設定する
4. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
5. 状態変更時の処理は`onChanged`で実装する

## 利用シーン

- 設定画面でのON/OFF切り替え
- 通知設定の有効/無効
- プライバシー設定の切り替え
- 機能の有効/無効化
- モード切り替え
""";
  }
}
