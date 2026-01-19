// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

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

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();
final tags = <String, String>{
  "health": "健康",
  "finance": "金融",
  "education": "教育",
};

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormMapTagDropdownField(
        initialValue: formController.value.selectedTags,
        onSaved: (value) => formController.value.copyWith(selectedTags: value),
        picker: FormMapTagDropdownFieldPicker(
          values: tags,
          onAdd: (entry) => tags.addEntries([entry]),
          onEdit: (entry) {
            tags.remove(entry.key);
            tags.addEntries([entry]);
          },
          onDelete: (key) => tags.remove(key),
        ),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) => tags.addEntries([entry]),
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) => tags.remove(key),
  ),
);
```

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
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
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

## 最大選択数の制限

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  maxChips: 5,  // 最大5つまで選択可能
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) => tags.addEntries([entry]),
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) => tags.remove(key),
  ),
);
```

## 読み取り専用の利用方法

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  readOnly: true,  // 選択・追加・編集・削除ができない
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
  ),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  prefix: FormAffixStyle(
    icon: Icon(Icons.tag),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.arrow_forward),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) => tags.addEntries([entry]),
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) => tags.remove(key),
  ),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormMapTagDropdownField(
  form: formController,
  initialValue: formController.value.selectedTags,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  picker: FormMapTagDropdownFieldPicker(
    values: tags,
    onAdd: (entry) => tags.addEntries([entry]),
    onEdit: (entry) {
      tags.remove(entry.key);
      tags.addEntries([entry]);
    },
    onDelete: (key) => tags.remove(key),
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: ピッカー（`FormMapTagDropdownFieldPicker`）。選択肢のMapデータと追加・編集・削除のコールバックを定義します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択されたキーのリスト（`List<String>`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。選択されたキーのリストが変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択されたキーのリストの検証ルールを定義します（例: 最小・最大選択数のチェック）。
- `enabled`: 入力可否。`false`の場合、ドロップダウンが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、選択・追加・編集・削除ができなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します（Mapのキーのリスト：`List<String>`）。デフォルトは空のリスト`[]`です。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も選択されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。ドロップダウンの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。ドロップダウンの右側に表示する追加要素（`FormAffixStyle`）。
- `maxChips`: 最大選択数。選択できるタグの最大数を設定します。未指定の場合は制限なしです。
- `emptyErrorText`: 空のエラーメッセージ。タグが1つも選択されていない場合に表示するエラーメッセージを設定します。
- `suggestionStyle`: サジェストボックスのスタイル。`SuggestionStyle`を使用してデザインをカスタマイズできます。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormMapTagDropdownFieldPicker`で設定可能なプロパティ
- `values`: 選択肢となるMapデータ（必須）。`Map<String, String>`型で、キーが選択されるID、値が表示ラベルになります。
- `onAdd`: 選択肢追加時のコールバック。新しく追加された`MapEntry<String, String>`が渡されます。
- `onEdit`: 選択肢編集時のコールバック。編集された`MapEntry<String, String>`が渡されます。
- `onDelete`: 選択肢削除時のコールバック。削除されたキー（`String`）が渡されます。
- `chipBuilder`: 選択されたタグの表示をカスタマイズするビルダー関数。`BuildContext`と値（`String`）を受け取り、カスタムChipウィジェットを返します。
- `backgroundColor`: ドロップダウンボックスの背景色。
- `color`: ドロップダウンボックスのテキスト色（前景色）。
- `tilePadding`: 各タイルのパディング。
- `width`: ドロップダウンボックスの幅。未指定の場合はフィールドの幅と同じになります。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`の`values`には必ず`Map<String, String>`を渡してください。Mapのキーが選択されるID（保存される値）、Mapの値が表示ラベルになります。
- `onSaved`や`onChanged`で渡される値はMapのキーのリスト（`List<String>`）です。
- `picker`の`onAdd`、`onEdit`、`onDelete`を定義することで、選択肢自体の追加・編集・削除時の処理を実装できます。
- `onAdd`には新しく追加された`MapEntry`が渡され、`onEdit`には編集された`MapEntry`が渡され、`onDelete`には削除されたキーが渡されます。
- ドロップダウンボックス内で各選択肢の編集ボタン（鉛筆アイコン）や削除ボタン（ゴミ箱アイコン）を押すことで、選択肢を編集・削除できます。
- 新しい選択肢を追加するには、ドロップダウンボックス内の追加ボタン（プラスアイコン）を押します。
- `maxChips`を設定すると、指定した数を超えてタグを選択できなくなります。
- `emptyErrorText`を設定すると、タグが1つも選択されていない場合にバリデーションエラーとして表示されます。
- `readOnly`が`true`の場合、ドロップダウンの表示、選択、追加、編集、削除のすべての操作ができなくなります。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- `FormMapDropdownField`との違い: `FormMapDropdownField`は単一選択、`FormMapTagDropdownField`は複数選択可能です。
- 選択肢の動的な追加・編集・削除が必要な場合に使用します。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 最小・最大選択数のチェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `picker`の`values`には`Map<String, String>`を渡す。キーがID、値が表示ラベル
8. `picker`の`onAdd`、`onEdit`、`onDelete`を定義して、選択肢の動的な管理を実装する
9. `maxChips`を設定して選択数を制限する
10. `emptyErrorText`を設定して最低1つの選択を必須にする
11. `chipBuilder`を使用して、選択されたタグのデザインをカスタマイズする
12. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 興味・関心の選択（複数選択＋追加・編集可能）
- スキルタグの設定（ユーザーが自由にスキルを追加・編集）
- カテゴリーの複数選択（カテゴリーの追加・削除が可能）
- 場所のタグ付け（訪問した場所、行きたい場所など）
- フィルターの複数選択（検索条件の動的な追加）
- プロジェクトタグの管理（プロジェクトのラベル付け）
- キーワードタグの管理（記事やブログのキーワード）
- ハッシュタグの管理（SNS投稿のハッシュタグ）
- 属性値の複数選択（商品の属性、特徴など）
- ラベル管理（GitHubのissueラベルのような機能）
""";
  }
}
