// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_builder.md.
///
/// form_builder.mdの中身。
class KatanaFormBuilderMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_builder.md.
  ///
  /// form_builder.mdの中身。
  const KatanaFormBuilderMdCliAiCode();

  @override
  String get name => "`FormBuilder`の利用方法";

  @override
  String get description => "独自のフォームを構築するためのビルダーである`FormBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`FormController`を使用して独自のフォームを構築するためのビルダー。`ref.update`メソッドでフォームの情報を更新することができるためボタンを並べたフォームやモーダルで表示するフォームなどを構築することができます。";

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
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  builder: (context, ref, item) {
    return Row(
      children: [
        FilledButton(
          onPressed: item == UserType.admin ? null : () {
            ref.update(UserType.admin);
          },
          child: const Text("管理者"),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: item == UserType.user ? null : () {
            ref.update(UserType.user);
          },
          child: const Text("一般ユーザー"),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: item == UserType.guest ? null : () {
            ref.update(UserType.guest);
          },
          child: const Text("ゲスト"),
        ),
      ],
    );
  },
);
```

## モーダルを利用したフォームの構築

```dart
FormBuilder(
  form: formController,
  onSaved: (value) => formController.value.copyWith(type: value),
  initialValue: formController.value.type,
  builder: (context, ref, item) {
    return FilledButton(
      onPressed: () async {
        final res = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return FormEnumModalField(
              initialValue: formController.value.type,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
              picker: FormEnumModalFieldPicker(
                values: UserType.values,
              ),
            );
          },
        );
        if (res != null) {
          ref.update(res);
        }
      },
      child: const Text("モーダルを表示して選択"),
    );
  },
);
```

## バリデーション状態の監視

```dart
FormBuilder(
  form: formController,
  onSaved: (value) => formController.value.copyWith(type: value),
  initialValue: formController.value.type,
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return "メールアドレスを入力してください";
    }
    return null;
  },
  builder: (context, ref, item) {
    return Row(
      children: [
        FilledButton(
          onPressed: item == UserType.admin ? null : () {
            ref.update(UserType.admin);
          },
          child: const Text("管理者"),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: item == UserType.user ? null : () {
            ref.update(UserType.user);
          },
          child: const Text("一般ユーザー"),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: item == UserType.guest ? null : () {
            ref.update(UserType.guest);
          },
          child: const Text("ゲスト"),
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
  onSaved: (value) => formController.value.copyWith(type: value),
  initialValue: formController.value.type,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.grey[100],
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  builder: (context, ref, item) {
    return Column(
      children: [
        FilledButton(
          onPressed: item == UserType.admin ? null : () {
            ref.update(UserType.admin);
          },
          child: const Text("管理者"),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: item == UserType.user ? null : () {
            ref.update(UserType.user);
          },
          child: const Text("一般ユーザー"),
        ),
        const SizedBox(width: 16),
        FilledButton(
          onPressed: item == UserType.guest ? null : () {
            ref.update(UserType.guest);
          },
          child: const Text("ゲスト"),
        ),
      ],
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。フォームの構造を動的に生成します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、フォームが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ビルダー関数内で自由にフォーム作成することができます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
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
