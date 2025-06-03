// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_text_editing_controller_builder.md.
///
/// form_text_editing_controller_builder.mdの中身。
class KatanaFormTextEditingControllerBuilderMdCliAiCode
    extends FormUsageCliAiCode {
  /// Contents of form_text_editing_controller_builder.md.
  ///
  /// form_text_editing_controller_builder.mdの中身。
  const KatanaFormTextEditingControllerBuilderMdCliAiCode();

  @override
  String get name => "`FormTextEditingControllerBuilder`の利用方法";

  @override
  String get description =>
      "TextEditingControllerを提供するビルダーである`FormTextEditingControllerBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "TextEditingControllerを提供するビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでテキスト入力の状態管理を行えます。";

  @override
  String body(String baseName, String className) {
    return """
`FormTextEditingControllerBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormTextEditingControllerBuilder(
  builder: (context, controller) {
    return FormTextField(
      form: formController,
      controller: controller,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormTextEditingControllerBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  builder: (context, controller) {
    return FormTextField(
      form: form,
      controller: controller,
      onSaved: (value) => form.value.copyWith(text: value),
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。フォーカス状態に応じたウィジェットを生成します。

### オプションパラメータ
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `controller`: 外部からTextEditingControllerを直接渡す場合に利用。

## 注意点
なし

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 検索フィールドの実装
""";
  }
}
