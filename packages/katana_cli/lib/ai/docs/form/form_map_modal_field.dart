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
`FormMapModalField`は下記のように利用する。

## 概要

$excerpt

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormMapModalField(
        initialValue: formController.value.language,
        onSaved: (value) => formController.value.copyWith(language: value),
        picker: FormMapModalFieldPicker(
          values: {"ja": "日本語", "en": "English"},
        ),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormMapModalField(
  form: formController,
  initialValue: formController.value.language,
  onSaved: (value) => formController.value.copyWith(language: value),
  picker: FormMapModalFieldPicker(
    values: {"ja": "日本語", "en": "English"},
  ),
);
```

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

## 読み取り専用の利用方法

```dart
FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  readOnly: true,  // モーダルピッカーが開かない
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## カスタムピッカーカラーの適用

```dart
FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapModalFieldPicker(
    values: countries,
    backgroundColor: Colors.white,
    color: Colors.black,
    confirmText: "決定",
    cancelText: "キャンセル",
  ),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  prefix: FormAffixStyle(
    icon: Icon(Icons.language),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.arrow_forward),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormMapModalField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapModalFieldPicker(
    values: countries,
  ),
);
```

## 動的なデータの利用方法

```dart
// データベースから取得したカテゴリーリスト
final categories = await fetchCategoriesFromDatabase();
final categoryMap = Map<String, String>.fromEntries(
  categories.map((category) => MapEntry(category.id, category.name)),
);

FormMapModalField(
  form: formController,
  initialValue: formController.value.categoryId,
  onSaved: (value) => formController.value.copyWith(categoryId: value),
  picker: FormMapModalFieldPicker(
    values: categoryMap,
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: ピッカー（`FormMapModalFieldPicker`）。選択肢のMapデータ（Key-Valueペア）を定義します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択されたキー（`String`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。キーが変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択されたキーの検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、モーダルピッカーが開かなくなります。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、モーダルピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します（Mapのキー：`String`）。
- `controller`: テキストコントローラー。テキスト表示のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も選択されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `emptyErrorText`: 空のエラーメッセージ。値が選択されていない場合に表示するエラーメッセージを設定します。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormMapModalFieldPicker`で設定可能なプロパティ
- `values`: 選択肢となるMapデータ（必須）。`Map<String, String>`型で、キーが選択されるID、値が表示ラベルになります。空のMapは許可されません。
- `defaultKey`: 選択されていない場合のデフォルトキー。未指定の場合は最初のキーが使用されます。`values`に含まれていないキーを指定するとエラーになります。
- `backgroundColor`: モーダルピッカーの背景色。
- `color`: モーダルピッカーのテキスト色（前景色）。
- `confirmText`: 確定ボタンのテキスト。デフォルトは`"Confirm"`です。
- `cancelText`: キャンセルボタンのテキスト。デフォルトは`"Cancel"`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`の`values`には必ず`Map<String, String>`を渡してください。Mapのキーが選択されるID（保存される値）、Mapの値が表示ラベルになります。
- `values`に空のMapを渡すとエラーになります。
- `onSaved`や`onChanged`で渡される値はMapのキー（`String`）です。
- `defaultKey`を指定する場合、そのキーは`values`に含まれている必要があります。含まれていない場合はエラーになります。
- `readOnly`が`true`の場合、フィールドをタップしてもモーダルピッカーは開きません。
- `emptyErrorText`を設定すると、値が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- `FormMapDropdownField`との違い: `FormMapDropdownField`はインラインドロップダウン、`FormMapModalField`はモーダルピッカーで選択します。
- `FormEnumModalField`と違い、データベース等で動的に取得したリストから選択する場合に利用します。
- 固定の列挙型を使用する場合は`FormEnumModalField`を使用し、動的なデータを使用する場合は`FormMapModalField`を使用します。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 必須チェック、特定キーの禁止）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `picker`の`values`には`Map<String, String>`を渡す。キーがID、値が表示ラベル
8. データベースから取得したデータを`Map.fromEntries()`や`map()`を使ってMapに変換する
9. `defaultKey`を設定する場合は、必ず`values`に含まれているキーを指定する
10. モバイルやタッチデバイスで大きな選択肢リストを扱う場合は、`FormMapModalField`を使用する
11. デスクトップやWeb、選択肢が少ない場合は、`FormMapDropdownField`を使用する
12. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
13. 固定の列挙型を使用する場合は`FormEnumModalField`、動的データを使用する場合は`FormMapModalField`を選択する

## 利用シーン

- 言語選択（アプリの表示言語、対応言語など）
- 国・地域選択（配送先国、居住地など）
- カテゴリー選択（データベースから取得した動的カテゴリー）
- ユーザー選択（ユーザーID-ユーザー名のペア）
- 部署選択（部署ID-部署名のペア）
- プロジェクト選択（プロジェクトID-プロジェクト名のペア）
- タグ選択（タグID-タグ名のペア）
- APIから取得した選択肢（動的データ）
- アプリケーション設定の管理
- カスタムメタデータの入力
- 属性値の設定
""";
  }
}
