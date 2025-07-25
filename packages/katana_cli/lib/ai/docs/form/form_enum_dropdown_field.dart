// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_enum_dropdown_field.md.
///
/// form_enum_dropdown_field.mdの中身。
class KatanaFormEnumDropdownFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_enum_dropdown_field.md.
  ///
  /// form_enum_dropdown_field.mdの中身。
  const KatanaFormEnumDropdownFieldMdCliAiCode();

  @override
  String get name => "`FormEnumDropdownField`の利用方法";

  @override
  String get description =>
      "列挙型の値をドロップダウンメニューで選択できるフォームフィールドである`FormEnumDropdownField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "列挙型の値をドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カスタムラベルやバリデーションなどを備えています。";

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
  guest;

  String get label => switch (this) {
      admin => "管理者",
      user => "一般ユーザー",
      guest => "ゲスト",
    };
}

FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
    labelBuilder: (value) {
      return value.label;
    },
  ),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormEnumDropdownField(
  initialValue: UserType.admin,
  onChanged: (value) {
    print(value);
  },
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
    labelBuilder: (value) {
      return value.label;
    },
  ),
);
```

## カスタムラベルの利用方法

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
    labelBuilder: (value) {
      return value.label;
    },
  ),
);
```

## バリデーション付きの利用方法

```dart
FormEnumDropdownField<UserType>(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  validator: (value) {
    if (value == null) {
      return "ユーザータイプを選択してください";
    }
    if (value == UserType.guest) {
      return "ゲストユーザーは選択できません";
    }
    return null;
  },
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## カスタムデザインの適用

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: ピッカー。選択肢の要素を定義します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。
- `focusNode`: フォーカスノード。フォームのフォーカスを設定します。

- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. `picker`の`values`には列挙型の`values`をそのまま渡すと列挙型すべてが選択肢に追加される。where等で制限すると選択肢を絞ることができる。
7. `FormMapDropdownField`と違い、予めプログラム内で固定で定義されているリストを選択肢として利用する場合に利用する。

## 利用シーン

- ユーザータイプの選択
- 権限レベルの設定
- ステータスの選択
- カテゴリーの選択
- 設定オプションの選択
""";
  }
}
