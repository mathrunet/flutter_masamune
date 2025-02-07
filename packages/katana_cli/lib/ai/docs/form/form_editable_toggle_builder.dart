import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_editable_toggle_builder.mdc.
///
/// form_editable_toggle_builder.mdcの中身。
class KatanaFormEditableToggleBuilderMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_editable_toggle_builder.mdc.
  ///
  /// form_editable_toggle_builder.mdcの中身。
  const KatanaFormEditableToggleBuilderMdcCliAiCode();

  @override
  String get name => "`FormEditableToggleBuilder`の利用方法";

  @override
  String get description =>
      "編集モードと表示モードを切り替えられるフォームビルダーである`FormEditableToggleBuilder`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "編集モードと表示モードを切り替えられるフォームビルダー。`FormController`の状態に応じて、編集可能なフォームと読み取り専用の表示を切り替えることができます。編集・保存・キャンセルなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormEditableToggleBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormEditableToggleBuilder(
    form: formController,
    builder: (context, form, editable, child) {
      return Column(
        children: [
          if (editable)
            FormTextField(
              form: form,
              initialValue: form.value.text,
              onSaved: (value) => form.value.copyWith(text: value),
            )
          else
            Text(form.value.text),
          FormButton(
            form: form,
            label: editable ? "保存" : "編集",
            onPressed: () {
              if (editable) {
                if (form.validate()) {
                  form.save();
                  form.setEditable(false);
                }
              } else {
                form.setEditable(true);
              }
            },
          ),
        ],
      );
    },
);
```

## 編集モード切り替えの利用方法

```dart
FormEditableToggleBuilder(
    form: formController,
    builder: (context, form, editable, child) {
      return Column(
        children: [
          if (editable)
            FormTextField(
              form: form,
              initialValue: form.value.name,
              onSaved: (value) => form.value.copyWith(name: value),
            )
          else
            Text(form.value.name),
          Row(
            children: [
              FormButton(
                form: form,
                label: editable ? "保存" : "編集",
                onPressed: () {
                  if (editable) {
                    if (form.validate()) {
                      form.save();
                      form.setEditable(false);
                    }
                  } else {
                    form.setEditable(true);
                  }
                },
              ),
              if (editable)
                FormButton(
                  form: form,
                  label: "キャンセル",
                  onPressed: () {
                    form.reset();
                    form.setEditable(false);
                  },
                ),
            ],
          ),
        ],
      );
    },
);
```

## カスタムデザインの適用

```dart
FormEditableToggleBuilder(
    form: formController,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.grey[200],
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    builder: (context, form, editable, child) {
      return Column(
        children: [
          if (editable)
            FormTextField(
              form: form,
              initialValue: form.value.text,
              onSaved: (value) => form.value.copyWith(text: value),
            )
          else
            Text(
              form.value.text,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      );
    },
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `builder`: ビルダー関数。編集状態に応じたウィジェットを生成します。

### オプションパラメータ
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `child`: 静的なウィジェット。再ビルドが不要な部分を最適化します。
- `initialEditable`: 初期編集状態。初期表示時の編集可否を設定します。

## 注意点

- `FormController`と組み合わせて使用することで、編集状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- 編集状態の切り替えは`form.setEditable()`メソッドで行います。
- キャンセル時は`form.reset()`メソッドで初期状態に戻せます。
- 保存前に必ず`form.validate()`で検証を行うことを推奨します。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 編集モードと表示モードで適切なUIを提供する
3. キャンセル機能を提供して編集内容を破棄できるようにする
4. 保存前にバリデーションを実行する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- プロフィール情報の編集
- 設定項目の編集
- 商品情報の編集
- コメントの編集
- メモの編集
""";
  }
}
