// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_focus_node_builder.md.
///
/// form_focus_node_builder.mdの中身。
class KatanaFormFocusNodeBuilderMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_focus_node_builder.md.
  ///
  /// form_focus_node_builder.mdの中身。
  const KatanaFormFocusNodeBuilderMdCliAiCode();

  @override
  String get name => "`FormFocusNodeBuilder`の利用方法";

  @override
  String get description =>
      "フォーカスノードを保持して提供するためのビルダーである`FormFocusNodeBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "フォーカスノードを保持して提供するためのビルダー。フォーカス状態を管理し、フォーカスの取得・解放時の処理を実装できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormFocusNodeBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormFocusNodeBuilder(
  form: formController,
  builder: (context, focusNode) {
    return FormTextField(
      form: form,
      focusNode: focusNode,
      initialValue: form.value.text,
      onSaved: (value) => form.value.copyWith(text: value),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormFocusNodeBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  builder: (context, focusNode) {
    return FormTextField(
      form: form,
      focusNode: focusNode,
      initialValue: form.value.text,
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
- `focusNode`: 外部からフォーカスノードを直接渡す場合に利用。

## 注意点
なし

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- フォーカス時のハイライト表示
- フォーカス状態に応じたアニメーション
- フォーカスイベントのログ記録
- フォーカス制御が必要なカスタムフォーム
- キーボード操作の最適化
""";
  }
}
