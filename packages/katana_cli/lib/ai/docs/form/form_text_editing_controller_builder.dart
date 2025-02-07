import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_text_editing_controller_builder.mdc.
///
/// form_text_editing_controller_builder.mdcの中身。
class KatanaFormTextEditingControllerBuilderMdcCliAiCode
    extends FormUsageCliAiCode {
  /// Contents of form_text_editing_controller_builder.mdc.
  ///
  /// form_text_editing_controller_builder.mdcの中身。
  const KatanaFormTextEditingControllerBuilderMdcCliAiCode();

  @override
  String get name => "`FormTextEditingControllerBuilder`の利用方法";

  @override
  String get description =>
      "テキスト入力のコントローラーを提供するビルダーである`FormTextEditingControllerBuilder`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "テキスト入力のコントローラーを提供するビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでテキスト入力の状態管理を行えます。テキストの選択、カーソル位置の制御、テキスト変更の監視などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormTextEditingControllerBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormTextEditingControllerBuilder(
    form: formController,
    builder: (context, controller) {
      return FormTextField(
        form: formController,
        controller: controller,
        onSaved: (value) => formController.value.copyWith(text: value),
      );
    },
);
```

## テキスト変更の監視

```dart
FormTextEditingControllerBuilder(
    form: formController,
    onChanged: (text) {
      print("Text changed: \$text");
    },
    builder: (context, controller) {
      return FormTextField(
        form: formController,
        controller: controller,
        onSaved: (value) => formController.value.copyWith(text: value),
      );
    },
);
```

## テキスト選択の制御

```dart
FormTextEditingControllerBuilder(
    form: formController,
    onSelectionChanged: (selection) {
      print("Selection changed: \$selection");
    },
    builder: (context, controller) {
      return FormTextField(
        form: formController,
        controller: controller,
        onSaved: (value) => formController.value.copyWith(text: value),
      );
    },
);
```

## 初期値とカーソル位置の設定

```dart
FormTextEditingControllerBuilder(
    form: formController,
    initialValue: "初期テキスト",
    initialSelection: const TextSelection(
      baseOffset: 0,
      extentOffset: 5,
    ),
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
    form: formController,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      textFieldStyle: TextFieldStyle(
        cursorColor: Colors.blue,
        selectionColor: Colors.blue[100],
        textStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
      ),
    ),
    builder: (context, controller) {
      return FormTextField(
        form: formController,
        controller: controller,
        onSaved: (value) => formController.value.copyWith(text: value),
      );
    },
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `builder`: ビルダー関数。コントローラーを使用するウィジェットを生成します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期テキストを設定します。
- `initialSelection`: 初期選択範囲。初期表示時のテキスト選択範囲を設定します。
- `onChanged`: テキスト変更時のコールバック。テキストが変更された時の処理を定義します。
- `onSelectionChanged`: 選択範囲変更時のコールバック。選択範囲が変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、テキスト入力が無効化されます。

## 注意点

- `FormController`と組み合わせて使用することで、テキスト入力の状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- テキストの変更は`onChanged`で監視できます。
- 選択範囲の変更は`onSelectionChanged`で監視できます。
- コントローラーは自動的にdisposeされます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 必要に応じてテキスト変更を監視する
3. 適切な初期値と選択範囲を設定する
4. メモリリークを防ぐためにコントローラーの管理を任せる
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 高度なテキスト入力制御
- テキストエディタの実装
- 検索フィールドの実装
- フォーマット付きテキスト入力
- リアルタイムテキスト処理
""";
  }
}
