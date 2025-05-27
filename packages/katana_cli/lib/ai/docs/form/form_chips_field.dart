// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_chips_field.md.
///
/// form_chips_field.mdの中身。
class KatanaFormChipsFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_chips_field.md.
  ///
  /// form_chips_field.mdの中身。
  const KatanaFormChipsFieldMdCliAiCode();

  @override
  String get name => "`FormChipsField`の利用方法";

  @override
  String get description => "Chipを並べて複数の選択を行うフォームを表示するための`FormChipsField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Chip`ウィジェットを使用して複数の選択肢を表示・選択できるフォームフィールド。テキスト入力を同時に行えるため、選択肢を新しく作ったり、検索したりすることが可能。タグ選択やフィルター選択などに最適で、`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormChipsField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormChipsField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
    );
  },
);
```

## サジェスト付きの利用方法

```dart
FormChipsField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
    );
  },
  suggestion: const ["開発", "デザイン", "マーケティング", "営業", "カスタマーサポート"],
  suggestionStyle: const FormSuggestionStyle(
    backgroundColor: Colors.blue,
    color: Colors.white,
  ),
  suggestionBuilder: (context, ref, item) {
    return Text(item);
  },
);
```

## バリデーション付きの利用方法

```dart
FormChipsField<String>(
  form: formController,
  initialValue: formController.value.selectedSkills,
  onSaved: (value) => formController.value.copyWith(selectedSkills: value),
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
    );
  },
  suggestion: const ["Flutter", "React", "Vue.js", "Angular", "Node.js"],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "スキルを1つ以上選択してください";
    }
    if (value.length > 3) {
      return "スキルは3つまでしか選択できません";
    }
    return null;
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: 各チップのウィジェットを生成するビルダー。

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
- `suggestion`: サジェストのリスト。表示するサジェストの一覧を設定します。
- `suggestionStyle`: サジェストのスタイル。`FormSuggestionStyle`を使用してデザインをカスタマイズできます。
- `suggestionBuilder`: サジェストのウィジェットを生成するビルダー。
- `maxChips`: 最大選択数。選択できるチップの最大数を設定します。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `suggestion`パラメータを使用することで、サジェストのリストを設定できます。`suggestionBuilder`パラメータを使用することで、サジェストのウィジェットをカスタマイズできます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. サジェストのリストは`suggestion`パラメータを使用して設定する。`suggestionBuilder`パラメータを使用することで、サジェストのウィジェットをカスタマイズ可能。

## 利用シーン

- タグ選択
- カテゴリー選択
- スキル選択
- フィルター設定
- 興味・関心の選択
""";
  }
}
