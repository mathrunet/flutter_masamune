import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_focus_node_builder.mdc.
///
/// form_focus_node_builder.mdcの中身。
class KatanaFormFocusNodeBuilderMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_focus_node_builder.mdc.
  ///
  /// form_focus_node_builder.mdcの中身。
  const KatanaFormFocusNodeBuilderMdcCliAiCode();

  @override
  String get name => "`FormFocusNodeBuilder`の利用方法";

  @override
  String get description =>
      "フォーカス状態に応じてウィジェットを構築するためのビルダーである`FormFocusNodeBuilder`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "フォーカス状態に応じてウィジェットを構築するためのビルダー。`FormController`と連携してフォーカス状態を管理し、フォーカスの取得・解放時の処理やアニメーションなどを実装できます。";

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
    builder: (context, form, focusNode, child) {
      return FormTextField(
        form: form,
        focusNode: focusNode,
        initialValue: form.value.text,
        onSaved: (value) => form.value.copyWith(text: value),
      );
    },
);
```

## フォーカス状態に応じた表示の切り替え

```dart
FormFocusNodeBuilder(
    form: formController,
    builder: (context, form, focusNode, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: focusNode.hasFocus ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: FormTextField(
          form: form,
          focusNode: focusNode,
          initialValue: form.value.text,
          onSaved: (value) => form.value.copyWith(text: value),
        ),
      );
    },
);
```

## フォーカスイベントの処理

```dart
FormFocusNodeBuilder(
    form: formController,
    onFocusChanged: (focused) {
      print("フォーカス状態: \${focused ? "取得" : "解放"}");
    },
    builder: (context, form, focusNode, child) {
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
    form: formController,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      focusedStyle: FocusedStyle(
        backgroundColor: Colors.blue[50],
        borderColor: Colors.blue,
        borderWidth: 2.0,
      ),
      unfocusedStyle: FocusedStyle(
        backgroundColor: Colors.grey[200],
        borderColor: Colors.grey,
        borderWidth: 1.0,
      ),
    ),
    builder: (context, form, focusNode, child) {
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
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `builder`: ビルダー関数。フォーカス状態に応じたウィジェットを生成します。

### オプションパラメータ
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `onFocusChanged`: フォーカス変更時のコールバック。フォーカスの取得・解放時の処理を定義します。
- `child`: 静的なウィジェット。再ビルドが不要な部分を最適化します。
- `autofocus`: 自動フォーカス。`true`の場合、表示時に自動的にフォーカスを取得します。

## 注意点

- `FormController`と組み合わせて使用することで、フォーカス状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- フォーカスの変更は`focusNode`を通じて制御できます。
- フォーカスイベントは`onFocusChanged`で監視できます。
- 自動フォーカスは`autofocus`パラメータで制御できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. フォーカス状態に応じて適切なビジュアルフィードバックを提供する
3. フォーカスイベントを適切に処理する
4. パフォーマンスを考慮して`child`パラメータを活用する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- フォーカス時のハイライト表示
- フォーカス状態に応じたアニメーション
- フォーカスイベントのログ記録
- フォーカス制御が必要なカスタムフォーム
- キーボード操作の最適化
""";
  }
}
