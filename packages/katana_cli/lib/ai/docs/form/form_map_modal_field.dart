// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_map_field.md.
///
/// form_map_field.mdの中身。
class KatanaFormMapModalFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_map_field.md.
  ///
  /// form_map_field.mdの中身。
  const KatanaFormMapModalFieldMdCliAiCode();

  @override
  String get name => "FormMapModalFieldの利用方法";

  @override
  String get description =>
      "Key-ValueペアのMap形式のデータを選択できるフォームフィールドである`FormMapModalField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "Key-ValueペアのMap型のデータ入力に特化したフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してマップデータの入力と管理を行うことができます。カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMapField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
final countries = <String, String>{
  "ja": "日本語",
  "en": "English",
  "es": "Español",
  "fr": "Français",
};

FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormMapModalField(
  initialValue: "ja",
  onChanged: (value) {
    print(value);
  },
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## バリデーション付きの利用方法

```dart
FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  validator: (value) {
    if (value == null) {
      return "地域を選択してください";
    }
    return null;
  },
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## カスタムデザインの適用

```dart
FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: 選択肢用のピッカー。`values`にキーと値のペアを持つマップを設定します。

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
- `picker`の`values`には必ず`Map<String, String>`を渡してください。Mapのキーが要素のIDとなりそれが`onSaved`や`onChanged`で渡される値となります。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. `picker`の`values`には必ず`Map<String, String>`を渡す。Mapのキーが要素のIDとなりそれが`onSaved`や`onChanged`で渡される値となる。
7. `FormEnumModalField`と違い、データベース等で動的に設定されたリストから選択するために利用する。

## 利用シーン

- アプリケーション設定の管理
- カスタムメタデータの入力
- 属性値の設定
- 環境変数の管理
- タグと値のペアの入力
""";
  }
}
