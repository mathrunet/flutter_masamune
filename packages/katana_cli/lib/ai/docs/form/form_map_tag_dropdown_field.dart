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
      "Key-ValueペアのMap形式のデータを追加・編集・削除しながらドロップダウンメニューで選択できるフォームフィールドである`FormMapTagDropdownField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "Key-ValueペアのMap形式のデータをタグ付きドロップダウンメニューで選択できるフォームフィールド。各要素を追加・編集・削除可能。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormMapTagDropdownField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
final tags = <String, String>{
  "health": "健康",
  "finance": "金融",
  "education": "教育",
  "entertainment": "エンタメ",
};

FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) {
      tags.addEntries([entry]);
    },
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) {
      tags.remove(key);
    },
  ),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormMapTagDropdownField(
  initialValue: ["health", "finance", "education"],
  onChanged: (value) {
    print(value);
  },
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) {
      tags.addEntries([entry]);
    },
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) {
      tags.remove(key);
    },
  ),
);
```

## 独自Chipの利用方法

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) {
      tags.addEntries([entry]);
    },
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) {
      tags.remove(key);
    },
    chipBuilder: (context, value) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Chip(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.colorScheme.primary,
          color:
              WidgetStatePropertyAll(theme.colorScheme.primary),
          label: Text(
            value ?? "",
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
        ),
      );
    }
  ),
);
```

## バリデーション付きの利用方法

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "タグを1つ以上選択してください";
    }
    if (value.length > 5) {
      return "タグは5つまでしか選択できません";
    }
    return null;
  },
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) {
      tags.addEntries([entry]);
    },
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) {
      tags.remove(key);
    },
  ),
);
```

## カスタムデザインの適用

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) {
      tags.addEntries([entry]);
    },
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) {
      tags.remove(key);
    },
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: 選択肢用のピッカー。`values`にキーと値のペアを持つマップを設定します。また`onAdd`、`onEdit`、`onDelete`を定義することで追加・編集・削除時の処理を定義できます。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。

- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`の`values`には必ず`Map<String, String>`を渡してください。Mapのキーが要素のIDとなりそれが`onSaved`や`onChanged`で渡される値となります。
- `picker`の`onAdd`、`onEdit`、`onDelete`を定義することで追加・編集・削除時の処理を定義できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. `picker`の`values`には必ず`Map<String, String>`を渡す。Mapのキーが要素のIDとなりそれが`onSaved`や`onChanged`で渡される値となる。
7. `picker`の`onAdd`、`onEdit`、`onDelete`を定義することで追加・編集・削除時の処理を定義できる。

## 利用シーン

- 興味・関心の選択
- スキルタグの設定
- カテゴリーの複数選択
- 場所のタグ付け
- フィルターの複数選択
""";
  }
}
