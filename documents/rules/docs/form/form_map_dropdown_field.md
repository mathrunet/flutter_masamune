# `FormMapDropdownField`の利用方法

`FormMapDropdownField`は下記のように利用する。

## 概要

Key-ValueペアのMap形式のデータをドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。

## 基本的な利用方法

```dart
final countries = <String, String>{
  "ja": "日本語",
  "en": "English",
  "es": "Español",
  "fr": "Français",
};

FormMapDropdownField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormMapDropdownField(
  initialValue: "ja",
  onChanged: (value) {
    print(value);
  },
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
);
```

## カスタムラベルの利用方法

```dart
FormMapDropdownField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
  labelBuilder: (key) => countries[key] ?? "",
);
```

## バリデーション付きの利用方法

```dart
FormMapDropdownField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  validator: (value) {
    if (value == null) {
      return "地域を選択してください";
    }
    return null;
  },
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
);
```

## カスタムデザインの適用

```dart
FormMapDropdownField<String, ThemeData>(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
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
7. `FormEnumDropdownField`と違い、データベース等で動的に設定されたリストから選択するために利用する。

## 利用シーン

- 言語選択
- 国・地域選択
- カテゴリー選択
- テーマ設定
- フィルター選択
