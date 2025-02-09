// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_chips_field.mdc.
///
/// form_chips_field.mdcの中身。
class KatanaFormChipsFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_chips_field.mdc.
  ///
  /// form_chips_field.mdcの中身。
  const KatanaFormChipsFieldMdcCliAiCode();

  @override
  String get name => "`FormChipsField`の利用方法";

  @override
  String get description => "フォームのチップフィールドを表示するための`FormChipsField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Chip`ウィジェットを使用して複数の選択肢を表示・選択できるフォームフィールド。タグ選択やフィルター選択などに最適で、`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormChipsField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormChipsField<String>(
    form: formController,
    initialValue: formController.value.selectedTags,
    items: const ["開発", "デザイン", "マーケティング", "営業", "カスタマーサポート"],
    itemBuilder: (context, item) {
      return Text(item);
    },
    onSaved: (value) => formController.value.copyWith(selectedTags: value),
);
```

## カスタムチップデザインの利用方法

```dart
FormChipsField<String>(
    form: formController,
    initialValue: formController.value.selectedCategories,
    items: const ["技術", "ビジネス", "デザイン", "マネジメント"],
    itemBuilder: (context, item) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getCategoryIcon(item)),
          const SizedBox(width: 4),
          Text(item),
        ],
      );
    },
    style: const FormStyle(
      chipStyle: ChipStyle(
        selectedColor: Colors.blue,
        unselectedColor: Colors.grey[200],
        selectedTextColor: Colors.white,
        unselectedTextColor: Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(selectedCategories: value),
);

IconData _getCategoryIcon(String category) {
  switch (category) {
    case "技術":
      return Icons.code;
    case "ビジネス":
      return Icons.business;
    case "デザイン":
      return Icons.design_services;
    case "マネジメント":
      return Icons.manage_accounts;
    default:
      return Icons.label;
  }
}
```

## バリデーション付きの利用方法

```dart
FormChipsField<String>(
    form: formController,
    initialValue: formController.value.selectedSkills,
    items: const ["Flutter", "React", "Vue.js", "Angular", "Node.js"],
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "スキルを1つ以上選択してください";
      }
      if (value.length > 3) {
        return "スキルは3つまでしか選択できません";
      }
      return null;
    },
    itemBuilder: (context, item) {
      return Text(item);
    },
    onSaved: (value) => formController.value.copyWith(selectedSkills: value),
);
```

## 検索機能付きの利用方法

```dart
FormChipsField<String>(
    form: formController,
    initialValue: formController.value.selectedTags,
    items: const ["Flutter", "Dart", "Firebase", "AWS", "GCP", "Azure"],
    searchable: true,
    searchHint: "タグを検索",
    itemBuilder: (context, item) {
      return Text(item);
    },
    onSaved: (value) => formController.value.copyWith(selectedTags: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `items`: 選択肢のリスト。表示するチップの一覧を設定します。
- `itemBuilder`: 項目ビルダー。各チップのウィジェットを生成します。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、選択が無効化されます。
- `searchable`: 検索機能の有効化。`true`の場合、チップの検索が可能になります。
- `searchHint`: 検索プレースホルダー。検索ボックスのヒントテキストを設定します。
- `onChanged`: 値変更時のコールバック。選択値が変更された時の処理を定義します。

## 注意点

- `FormController`と組み合わせて使用することで、選択状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 検索機能は`searchable`パラメータで有効化できます。
- 各チップのウィジェットは`itemBuilder`で自由にカスタマイズできます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 分かりやすいラベルとアイコンを設定する
3. 適切なバリデーションを設定してデータの整合性を保つ
4. 選択肢が多い場合は検索機能を有効化する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- タグ選択
- カテゴリー選択
- スキル選択
- フィルター設定
- 興味・関心の選択
""";
  }
}
