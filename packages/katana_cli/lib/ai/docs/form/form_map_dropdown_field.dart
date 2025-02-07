import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_map_dropdown_field.mdc.
///
/// form_map_dropdown_field.mdcの中身。
class KatanaFormMapDropdownFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_map_dropdown_field.mdc.
  ///
  /// form_map_dropdown_field.mdcの中身。
  const KatanaFormMapDropdownFieldMdcCliAiCode();

  @override
  String get name => "FormMapDropdownFieldの利用方法";

  @override
  String get description => "MasamuneフレームワークにおけるFormMapDropdownFieldの利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "マップ形式のデータをドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。キーと値のペアを扱い、カスタムラベル、アイコン表示、検索機能などを備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMapDropdownField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormMapDropdownField<String, String>(
    form: formController,
    initialValue: formController.value.selectedLanguage,
    items: const {
      "ja": "日本語",
      "en": "English",
      "es": "Español",
      "fr": "Français",
    },
    onSaved: (value) => formController.value.copyWith(selectedLanguage: value),
);
```

## カスタムラベルの利用方法

```dart
FormMapDropdownField<String, CountryData>(
    form: formController,
    initialValue: formController.value.selectedCountry,
    items: countries,
    labelBuilder: (key, value) {
      return "\${value.flag} \${value.name} (\${value.code})";
    },
    onSaved: (value) => formController.value.copyWith(selectedCountry: value),
);
```

## アイコン付きの利用方法

```dart
FormMapDropdownField<String, CategoryData>(
    form: formController,
    initialValue: formController.value.selectedCategory,
    items: categories,
    labelBuilder: (key, value) => value.name,
    iconBuilder: (key, value) {
      return Icon(value.icon);
    },
    onSaved: (value) => formController.value.copyWith(selectedCategory: value),
);
```

## バリデーション付きの利用方法

```dart
FormMapDropdownField<String, RegionData>(
    form: formController,
    initialValue: formController.value.selectedRegion,
    items: regions,
    validator: (value) {
      if (value == null) {
        return "地域を選択してください";
      }
      if (!value.isAvailable) {
        return "この地域は現在利用できません";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(selectedRegion: value),
);
```

## 検索機能付きの利用方法

```dart
FormMapDropdownField<String, CityData>(
    form: formController,
    initialValue: formController.value.selectedCity,
    items: cities,
    searchable: true,
    searchHint: "都市名を検索",
    labelBuilder: (key, value) => value.name,
    searchMatcher: (query, key, value) {
      return value.name.toLowerCase().contains(query.toLowerCase()) ||
             value.code.toLowerCase().contains(query.toLowerCase());
    },
    onSaved: (value) => formController.value.copyWith(selectedCity: value),
);
```

## カスタムデザインの適用

```dart
FormMapDropdownField<String, ThemeData>(
    form: formController,
    initialValue: formController.value.selectedTheme,
    items: themes,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      dropdownStyle: DropdownStyle(
        backgroundColor: Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black87,
        searchTextStyle: TextStyle(
          fontSize: 14.0,
          color: Colors.grey[800],
        ),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(selectedTheme: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `items`: 選択肢。キーと値のペアを持つマップを設定します。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します。
- `labelBuilder`: ラベルビルダー。キーと値に対応する表示ラベルを生成します。
- `iconBuilder`: アイコンビルダー。キーと値に対応するアイコンを生成します。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、選択が無効化されます。
- `hint`: ヒントテキスト。未選択時に表示するテキストを設定します。
- `searchable`: 検索機能の有効化。`true`の場合、選択肢を検索できます。
- `searchHint`: 検索ヒント。検索ボックスのプレースホルダーを設定します。
- `searchMatcher`: 検索マッチャー。検索クエリとアイテムのマッチング方法を定義します。

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

- 言語選択
- 国・地域選択
- カテゴリー選択
- テーマ設定
- フィルター選択
""";
  }
}
