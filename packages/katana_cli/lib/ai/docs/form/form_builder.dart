import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_builder.mdc.
///
/// form_builder.mdcの中身。
class KatanaFormBuilderMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_builder.mdc.
  ///
  /// form_builder.mdcの中身。
  const KatanaFormBuilderMdcCliAiCode();

  @override
  String get name => "`FormBuilder`の利用方法";

  @override
  String get description => "動的にフォームを構築するためのビルダーである`FormBuilder`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`FormController`を使用して動的にフォームを構築するためのビルダー。フォームの状態に応じて異なるフォームフィールドを表示したり、条件に基づいてフォームの構造を変更したりすることができます。";

  @override
  String body(String baseName, String className) {
    return """
`FormBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormBuilder(
    form: formController,
    builder: (context, form, child) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: form.value.name,
            onSaved: (value) => form.value.copyWith(name: value),
          ),
          if (form.value.type == UserType.admin)
            FormTextField(
              form: form,
              initialValue: form.value.adminCode,
              onSaved: (value) => form.value.copyWith(adminCode: value),
            ),
        ],
      );
    },
);
```

## フォーム状態に応じた動的な表示

```dart
FormBuilder(
    form: formController,
    builder: (context, form, child) {
      return Column(
        children: [
          FormEnumField<UserType>(
            form: form,
            initialValue: form.value.type,
            items: UserType.values,
            onSaved: (value) => form.value.copyWith(type: value),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildTypeSpecificFields(form),
          ),
        ],
      );
    },
);

Widget _buildTypeSpecificFields(FormController form) {
  switch (form.value.type) {
    case UserType.admin:
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: form.value.adminCode,
            onSaved: (value) => form.value.copyWith(adminCode: value),
          ),
          FormSwitch(
            form: form,
            initialValue: form.value.hasFullAccess,
            onSaved: (value) => form.value.copyWith(hasFullAccess: value),
          ),
        ],
      );
    case UserType.user:
      return FormTextField(
        form: form,
        initialValue: form.value.department,
        onSaved: (value) => form.value.copyWith(department: value),
      );
    default:
      return const SizedBox.shrink();
  }
}
```

## バリデーション状態の監視

```dart
FormBuilder(
    form: formController,
    builder: (context, form, child) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: form.value.email,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "メールアドレスを入力してください";
              }
              return null;
            },
            onSaved: (value) => form.value.copyWith(email: value),
          ),
          const SizedBox(height: 16),
          FormButton(
            form: form,
            label: "保存",
            enabled: !form.hasError,
            onPressed: () {
              if (form.validate()) {
                form.save();
              }
            },
          ),
        ],
      );
    },
);
```

## カスタムデザインの適用

```dart
FormBuilder(
    form: formController,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.grey[100],
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    builder: (context, form, child) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: form.value.name,
            onSaved: (value) => form.value.copyWith(name: value),
          ),
          const SizedBox(height: 16),
          FormButton(
            form: form,
            label: "保存",
            onPressed: () {
              if (form.validate()) {
                form.save();
              }
            },
          ),
        ],
      );
    },
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `builder`: ビルダー関数。フォームの構造を動的に生成します。

### オプションパラメータ
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `child`: 静的なウィジェット。再ビルドが不要な部分を最適化します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ビルダー関数内でフォームの状態に応じて条件分岐を行うことができます。
- パフォーマンスを考慮して、静的な部分は`child`パラメータを使用します。
- フォームのバリデーション状態は`form.hasError`で監視できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 動的な表示切り替えには適切なアニメーションを使用する
3. 複雑なフォームは適切に関数を分割する
4. バリデーション状態に応じてUIを適切に更新する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 複雑なフォームの構築
- 条件付きフォームフィールドの表示
- ステップ形式のフォーム
- 動的なフォームレイアウト
- フォームの状態に応じたUI更新
""";
  }
}
