// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_button.mdc.
///
/// form_button.mdcの中身。
class KatanaFormButtonMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_button.mdc.
  ///
  /// form_button.mdcの中身。
  const KatanaFormButtonMdcCliAiCode();

  @override
  String get name => "`FormButton`の利用方法";

  @override
  String get description => "フォームの送信ボタンを表示するための`FormButton`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`ElevatedButton`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`と連携してフォームの送信や検証を行うことができます。ローディング表示、アイコン表示、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormButton`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormButton(
    form: formController,
    label: "保存",
    onPressed: () {
      if (formController.validate()) {
        formController.save();
      }
    },
);
```

## ローディング表示付きの利用方法

```dart
FormButton(
    form: formController,
    label: "保存",
    loading: formController.value.loading,
    onPressed: () async {
      if (formController.validate()) {
        await formController.save();
      }
    },
);
```

## アイコン付きの利用方法

```dart
FormButton(
    form: formController,
    label: "保存",
    icon: Icons.save,
    onPressed: () {
      if (formController.validate()) {
        formController.save();
      }
    },
);
```

## カスタムデザインの適用

```dart
FormButton(
    form: formController,
    label: "保存",
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      buttonStyle: ButtonStyle(
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        elevation: 2.0,
        pressedOpacity: 0.8,
      ),
    ),
    onPressed: () {
      if (formController.validate()) {
        formController.save();
      }
    },
);
```

## フォーム検証付きの利用方法

```dart
FormButton(
    form: formController,
    label: "保存",
    validateOnPressed: true,
    onPressed: () {
      // validateOnPressedがtrueの場合、
      // onPressedが呼ばれる前に自動的にvalidate()が実行されます
      formController.save();
    },
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `label`: ボタンのラベル。ボタンに表示するテキストを設定します。
- `onPressed`: タップ時のコールバック。ボタンがタップされた時の処理を定義します。

### オプションパラメータ
- `icon`: アイコン。ボタンに表示するアイコンを設定します。
- `loading`: ローディング状態。`true`の場合、ローディングインジケータを表示します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 有効/無効。`false`の場合、ボタンが無効化されます。
- `validateOnPressed`: タップ時の検証。`true`の場合、タップ時に自動的にフォームを検証します。
- `loadingLabel`: ローディング時のラベル。ローディング中に表示するテキストを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの送信と検証を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ローディング状態は`loading`パラメータで制御できます。
- アイコンは`icon`パラメータで追加できます。
- フォームの検証は`validateOnPressed`パラメータを使用して自動化できます。
- ボタンの有効/無効は`enabled`パラメータで制御できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 非同期処理中はローディング状態を表示する
3. ユーザーにとって分かりやすいラベルを設定する
4. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
5. フォームの検証は`validateOnPressed`を使用して自動化する

## 利用シーン

- フォームの送信ボタン
- データの保存ボタン
- 設定の適用ボタン
- 次へ進むボタン
- キャンセルボタン
""";
  }
}
