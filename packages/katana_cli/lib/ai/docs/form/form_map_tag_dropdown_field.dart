// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_map_tag_dropdown_field.md.
///
/// form_map_tag_dropdown_field.mdの中身。
class KatanaFormMapTagDropdownFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_map_tag_dropdown_field.md.
  ///
  /// form_map_tag_dropdown_field.mdの中身。
  const KatanaFormMapTagDropdownFieldMdCliAiCode();

  @override
  String get name => "`FormMapTagDropdownField`の利用方法";

  @override
  String get description =>
      "`Map`形式のデータをタグ付きドロップダウンメニューで選択できるフォームフィールドである`FormMapTagDropdownField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "マップ形式のデータをタグ付きドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。タグ表示、カスタムラベル、アイコン表示、検索機能などを備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMapTagDropdownField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormMapTagDropdownField<String, String>(
    form: formController,
    initialValue: formController.value.selectedTags,
    items: const {
      "tech": "技術",
      "design": "デザイン",
      "business": "ビジネス",
      "marketing": "マーケティング",
    },
    onSaved: (value) => formController.value.copyWith(selectedTags: value),
);
```

## カスタムタグの利用方法

```dart
FormMapTagDropdownField<String, CategoryData>(
    form: formController,
    initialValue: formController.value.selectedCategories,
    items: categories,
    tagBuilder: (key, value) {
      return Chip(
        avatar: CircleAvatar(
          backgroundColor: value.color,
          child: Icon(value.icon, size: 12),
        ),
        label: Text(value.name),
      );
    },
    onSaved: (value) => formController.value.copyWith(selectedCategories: value),
);
```

## アイコン付きの利用方法

```dart
FormMapTagDropdownField<String, SkillData>(
    form: formController,
    initialValue: formController.value.selectedSkills,
    items: skills,
    labelBuilder: (key, value) => value.name,
    iconBuilder: (key, value) {
      return Icon(value.icon);
    },
    onSaved: (value) => formController.value.copyWith(selectedSkills: value),
);
```

## バリデーション付きの利用方法

```dart
FormMapTagDropdownField<String, TagData>(
    form: formController,
    initialValue: formController.value.selectedTags,
    items: tags,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "タグを1つ以上選択してください";
      }
      if (value.length > 5) {
        return "タグは5つまでしか選択できません";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(selectedTags: value),
);
```

## 検索機能付きの利用方法

```dart
FormMapTagDropdownField<String, LocationData>(
    form: formController,
    initialValue: formController.value.selectedLocations,
    items: locations,
    searchable: true,
    searchHint: "場所を検索",
    labelBuilder: (key, value) => value.name,
    searchMatcher: (query, key, value) {
      return value.name.toLowerCase().contains(query.toLowerCase()) ||
             value.address.toLowerCase().contains(query.toLowerCase());
    },
    onSaved: (value) => formController.value.copyWith(selectedLocations: value),
);
```

## カスタムデザインの適用

```dart
FormMapTagDropdownField<String, InterestData>(
    form: formController,
    initialValue: formController.value.selectedInterests,
    items: interests,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      dropdownStyle: DropdownStyle(
        backgroundColor: Colors.white,
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black87,
      ),
      tagStyle: TagStyle(
        backgroundColor: Colors.blue[100],
        textColor: Colors.blue[900],
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        spacing: 8.0,
      ),
    ),
    onSaved: (value) => formController.value.copyWith(selectedInterests: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `items`: 選択肢。キーと値のペアを持つマップを設定します。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します。
- `tagBuilder`: タグビルダー。選択されたアイテムのタグウィジェットを生成します。
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
- タグのデザインは`tagBuilder`でカスタマイズできます。
- ラベルとアイコンは`labelBuilder`と`iconBuilder`でカスタマイズできます。
- 検索機能は`searchable`パラメータで有効化できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 分かりやすいタグデザインを設定する
3. 必要に応じて適切なバリデーションを設定する
4. 選択肢が多い場合は検索機能を有効にする
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 興味・関心の選択
- スキルタグの設定
- カテゴリーの複数選択
- 場所のタグ付け
- フィルターの複数選択
""";
  }
}
