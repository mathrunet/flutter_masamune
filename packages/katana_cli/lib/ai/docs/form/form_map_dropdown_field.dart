// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_map_dropdown_field.md.
///
/// form_map_dropdown_field.mdの中身。
class KatanaFormMapDropdownFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_map_dropdown_field.md.
  ///
  /// form_map_dropdown_field.mdの中身。
  const KatanaFormMapDropdownFieldMdCliAiCode();

  @override
  String get name => "`FormMapDropdownField`の利用方法";

  @override
  String get description =>
      "Key-ValueペアのMap形式のデータをドロップダウンメニューで選択できるフォームフィールドである`FormMapDropdownField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "Key-ValueペアのMap形式のデータをドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormMapDropdownField`は下記のように利用する。

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
      FormMapDropdownField(
        initialValue: formController.value.language,
        onSaved: (value) => formController.value.copyWith(language: value),
        picker: FormMapDropdownFieldPicker(
          values: {"ja": "日本語", "en": "English"},
        ),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormMapDropdownField(
  form: formController,
  initialValue: formController.value.language,
  onSaved: (value) => formController.value.copyWith(language: value),
  picker: FormMapDropdownFieldPicker(
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
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormMapDropdownField(
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
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormMapDropdownField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  icon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapDropdownFieldPicker(
    values: countries,
  ),
);
```

## フォームを横幅いっぱいに拡張

```dart
FormMapDropdownField(
  form: formController,
  initialValue: formController.value.selectedLanguage,
  expanded: true,  // 横幅いっぱいに拡張
  onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
  picker: FormMapDropdownFieldPicker(
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

FormMapDropdownField(
  form: formController,
  initialValue: formController.value.categoryId,
  onSaved: (value) => formController.value.copyWith(categoryId: value),
  picker: FormMapDropdownFieldPicker(
    values: categoryMap,
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: ピッカー（`FormMapDropdownFieldPicker`）。選択肢のMapデータ（Key-Valueペア）を定義します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択されたキー（`String`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。キーが変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択されたキーの検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、ドロップダウンが無効化されます。デフォルトは`true`です。
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します（Mapのキー：`String`）。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も選択されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。ドロップダウンの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。ドロップダウンの右側に表示する追加要素（`FormAffixStyle`）。
- `emptyErrorText`: 空のエラーメッセージ。値が選択されていない場合に表示するエラーメッセージを設定します。
- `icon`: ドロップダウンの右側に表示されるアイコン。未指定の場合はデフォルトのドロップダウンアイコンが使用されます。
- `expanded`: フォームを横幅いっぱいに拡張するかどうか。`true`の場合、親ウィジェットの幅いっぱいに拡張されます。デフォルトは`false`です。

### `FormMapDropdownFieldPicker`で設定可能なプロパティ
- `values`: 選択肢となるMapデータ（必須）。`Map<String, String>`型で、キーが選択されるID、値が表示ラベルになります。
- `labelBuilder`: 各Mapの値（または任意のカスタムロジック）を表示用のラベル文字列に変換するビルダー関数。未指定の場合はMapの値（value）が使用されます。

### `FormStyle`で設定可能なプロパティ（ドロップダウン特有）
- `activeBackgroundColor`: 選択時のドロップダウンの背景色
- `activeColor`: 選択時のテキスト色
- `activeTextStyle`: 選択時のテキストスタイル
- `elevation`: ドロップダウンメニューの影の高さ。デフォルトは`8`です。
- `alignedDropdown`: ドロップダウンメニューを左右に揃えるかどうか。デフォルトは`false`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`の`values`には必ず`Map<String, String>`を渡してください。Mapのキーが選択されるID（保存される値）、Mapの値が表示ラベルになります。
- `onSaved`や`onChanged`で渡される値はMapのキー（`String`）です。
- `labelBuilder`を指定しない場合、Mapの値（value）がそのまま表示されます。
- `labelBuilder`を使用すると、表示ラベルをカスタマイズできます。引数には選択されたキーに対応する値が渡されます。
- `emptyErrorText`を設定すると、値が選択されていない場合にバリデーションエラーとして表示されます。
- `expanded`を`true`にすると、ドロップダウンが親ウィジェットの幅いっぱいに拡張されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- `FormEnumDropdownField`と違い、データベース等で動的に取得したリストから選択する場合に利用します。
- 固定の列挙型を使用する場合は`FormEnumDropdownField`を使用し、動的なデータを使用する場合は`FormMapDropdownField`を使用します。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 必須チェック、特定キーの禁止）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `picker`の`values`には`Map<String, String>`を渡す。キーがID、値が表示ラベル
8. データベースから取得したデータを`Map.fromEntries()`や`map()`を使ってMapに変換する
9. `expanded`を使用して、レイアウトに合わせてドロップダウンの幅を調整する
10. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
11. 固定の列挙型を使用する場合は`FormEnumDropdownField`、動的データを使用する場合は`FormMapDropdownField`を選択する

## 利用シーン

- 言語選択（アプリの表示言語、対応言語など）
- 国・地域選択（配送先国、居住地など）
- カテゴリー選択（データベースから取得した動的カテゴリー）
- テーマ設定（ユーザーカスタマイズ可能なテーマ）
- フィルター選択（動的なフィルター条件）
- ユーザー選択（ユーザーID-ユーザー名のペア）
- 部署選択（部署ID-部署名のペア）
- プロジェクト選択（プロジェクトID-プロジェクト名のペア）
- タグ選択（タグID-タグ名のペア）
- APIから取得した選択肢（動的データ）
""";
  }
}
