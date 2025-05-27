// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_enum_field.md.
///
/// form_enum_field.mdの中身。
class KatanaFormEnumFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_enum_field.md.
  ///
  /// form_enum_field.mdの中身。
  const KatanaFormEnumFieldMdCliAiCode();

  @override
  String get name => "`FormEnumField`の利用方法";

  @override
  String get description => "列挙型の値を選択できるフォームフィールドである`FormEnumField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`DropdownButtonFormField`の列挙型特化版。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで列挙型の値を管理可能。列挙型の値をラベル付きで表示、検索機能、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormEnumField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
enum UserType {
  admin,
  user,
  guest,
}

FormEnumField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## ラベル付きの利用方法

```dart
FormEnumField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    labelBuilder: (value) {
      switch (value) {
        case UserType.admin:
          return "管理者";
        case UserType.user:
          return "一般ユーザー";
        case UserType.guest:
          return "ゲスト";
      }
    },
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## 検索機能付きの利用方法

```dart
FormEnumField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    searchable: true,
    labelBuilder: (value) {
      switch (value) {
        case UserType.admin:
          return "管理者";
        case UserType.user:
          return "一般ユーザー";
        case UserType.guest:
          return "ゲスト";
      }
    },
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## バリデーション付きの利用方法

```dart
FormEnumField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    validator: (value) {
      if (value == null) {
        return "ユーザータイプを選択してください";
      }
      if (value == UserType.guest) {
        return "ゲストユーザーは選択できません";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## カスタムデザインの適用

```dart
FormEnumField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      backgroundColor: Colors.grey[200],
      dropdownStyle: DropdownStyle(
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `items`: 選択肢。列挙型の値のリストを設定します。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します。
- `labelBuilder`: ラベルビルダー。列挙型の値に対応する表示ラベルを生成します。
- `searchable`: 検索可否。`true`の場合、選択肢を検索できるようになります。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、選択が無効化されます。
- `hint`: ヒントテキスト。未選択時に表示するテキストを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、列挙型の値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- `labelBuilder`を使用することで、列挙型の値を分かりやすいラベルで表示できます。
- 検索機能は`searchable`パラメータを`true`に設定することで有効になります。
- 選択肢が多い場合は検索機能の使用を検討してください。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. ユーザーにとって分かりやすいラベルを設定する
3. 選択肢が多い場合は検索機能を有効にする
4. 必須選択の場合は適切なバリデーションメッセージを設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- ユーザータイプの選択
- カテゴリーの選択
- ステータスの選択
- 権限レベルの設定
- 設定項目の選択
""";
  }
}
