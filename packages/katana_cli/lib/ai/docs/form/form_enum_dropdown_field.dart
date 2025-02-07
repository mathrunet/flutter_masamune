import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_enum_dropdown_field.mdc.
///
/// form_enum_dropdown_field.mdcの中身。
class KatanaFormEnumDropdownFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_enum_dropdown_field.mdc.
  ///
  /// form_enum_dropdown_field.mdcの中身。
  const KatanaFormEnumDropdownFieldMdcCliAiCode();

  @override
  String get name => "`FormEnumDropdownField`の利用方法";

  @override
  String get description =>
      "列挙型の値をドロップダウンメニューで選択できるフォームフィールドである`FormEnumDropdownField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "列挙型の値をドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カスタムラベル、アイコン表示、検索機能などを備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormEnumDropdownField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
enum UserType {
  admin,
  user,
  guest,
}

FormEnumDropdownField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## カスタムラベルの利用方法

```dart
FormEnumDropdownField<UserType>(
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

## アイコン付きの利用方法

```dart
FormEnumDropdownField<UserType>(
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
    iconBuilder: (value) {
      switch (value) {
        case UserType.admin:
          return Icons.admin_panel_settings;
        case UserType.user:
          return Icons.person;
        case UserType.guest:
          return Icons.person_outline;
      }
    },
    onSaved: (value) => formController.value.copyWith(type: value),
);
```

## バリデーション付きの利用方法

```dart
FormEnumDropdownField<UserType>(
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
FormEnumDropdownField<UserType>(
    form: formController,
    initialValue: formController.value.type,
    items: UserType.values,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      dropdownStyle: DropdownStyle(
        backgroundColor: Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black87,
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
- `iconBuilder`: アイコンビルダー。列挙型の値に対応するアイコンを生成します。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、選択が無効化されます。
- `hint`: ヒントテキスト。未選択時に表示するテキストを設定します。
- `searchable`: 検索機能の有効化。`true`の場合、選択肢を検索できます。

## 注意点

- `FormController`と組み合わせて使用することで、選択状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- ラベルとアイコンは`labelBuilder`と`iconBuilder`でカスタマイズできます。
- 検索機能は`searchable`パラメータで有効化できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 分かりやすいラベルとアイコンを設定する
3. 必要に応じて適切なバリデーションを設定する
4. 選択肢が多い場合は検索機能を有効にする
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- ユーザータイプの選択
- 権限レベルの設定
- ステータスの選択
- カテゴリーの選択
- 設定オプションの選択
""";
  }
}
