// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

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

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormChipsField(
        initialValue: formController.value.selectedTags,
        onSaved: (value) => formController.value.copyWith(selectedTags: value),
        builder: (context, ref, item) {
          return Chip(
            label: Text(item),
          );
        },
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
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

## `FormController`を使用しない場合の利用方法

```dart
FormChipsField(
  initialValue: ["Flutter", "React", "Vue.js", "Angular", "Node.js"],
  onChanged: (value) {
    print(value);
  },
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

## カスタムデザインの適用

```dart
FormChipsField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  style: const FormStyle(
    backgroundColor: Colors.grey[100],
    activeBackgroundColor: Colors.blue,
    activeColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderStyle: FormInputBorderStyle.outline,
  ),
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
      onDeleted: () => ref.delete(item),
    );
  },
);
```

## チップのタップ処理

```dart
FormChipsField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
      onDeleted: () => ref.delete(item),
    );
  },
  onChipTapped: (value) {
    print("Chip tapped: \$value");
  },
);
```

## 最大選択数の制限

```dart
FormChipsField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  maxChips: 5,  // 最大5つまで選択可能
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
      onDeleted: () => ref.delete(item),
    );
  },
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormChipsField(
  form: formController,
  initialValue: formController.value.selectedTags,
  onSaved: (value) => formController.value.copyWith(selectedTags: value),
  prefix: FormAffixStyle(
    icon: Icon(Icons.tag),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.arrow_forward),
    iconColor: Colors.grey,
  ),
  builder: (context, ref, item) {
    return Chip(
      label: Text(item),
      onDeleted: () => ref.delete(item),
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: 各チップのウィジェットを生成するビルダー。`FormChipsInputRef`を利用してチップの追加・削除が可能です。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。チップが追加・削除された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択されたチップリストの検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チップの追加・削除が無効化されます。デフォルトは`true`です。
- `initialValue`: 初期値。フォーム表示時の初期チップリストを設定します。デフォルトは空のリスト`[]`です。
- `readOnly`: 読み取り専用。`true`の場合、有効化の表示になりますが値を変更できなくなります。デフォルトは`false`です。
- `focusNode`: フォーカスノード。テキスト入力部分のフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `suggestion`: サジェストのリスト。表示するサジェストの一覧を設定します。デフォルトは空のリスト`[]`です。
- `suggestionStyle`: サジェストのスタイル。`SuggestionStyle`を使用してデザインをカスタマイズできます。
- `suggestionBuilder`: サジェストのウィジェットを生成するビルダー。未指定の場合はデフォルトの表示が使用されます。
- `maxChips`: 最大選択数。選択できるチップの最大数を設定します。未指定の場合は制限なし。
- `emptyErrorText`: 空のエラーメッセージ。チップが1つも選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.text`です。
- `obscureText`: 入力内容を隠すかどうか。`true`の場合、入力内容が隠されます（パスワード入力用）。デフォルトは`false`です。
- `onChipTapped`: チップがタップされた時のコールバック。タップされたチップの値が渡されます。
- `includeEditingTextOnSave`: 保存時に編集中のテキストを含めるかどうか。`true`の場合、編集中のテキストも保存されます。デフォルトは`false`です。

### `FormStyle`で設定可能なプロパティ
- `backgroundColor`: テキストフィールドの背景色
- `activeBackgroundColor`: チップの背景色
- `activeColor`: チップのテキスト色と削除アイコンの色
- `disabledColor`: 無効化時のテキストとチップの色
- `color`: テキストの色
- `subColor`: ヒントテキストの色
- `errorColor`: エラーテキストの色
- `borderColor`: 境界線の色
- `borderWidth`: 境界線の太さ
- `borderStyle`: 境界線のスタイル（`FormInputBorderStyle.outline`、`FormInputBorderStyle.underline`、`FormInputBorderStyle.none`）
- `borderRadius`: 境界線の角丸設定
- `border`: カスタム境界線
- `disabledBorder`: 無効化時のカスタム境界線
- `errorBorder`: エラー時のカスタム境界線
- `contentPadding`: コンテンツのパディング
- `padding`: フォームコンテナの外側のパディング
- `alignment`: フォームコンテナ内でのアライメント
- `width`: フォームの幅
- `height`: フォームの高さ
- `textStyle`: テキストスタイル
- `errorTextStyle`: エラーテキストスタイル
- `textAlign`: テキストの配置
- `textAlignVertical`: テキストの垂直配置

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `suggestion`パラメータを使用することで、サジェストのリストを設定できます。`suggestionBuilder`パラメータを使用することで、サジェストのウィジェットをカスタマイズできます。
- `builder`内で`FormChipsInputRef`の`add`メソッドと`delete`メソッドを使用して、チップの追加・削除を行うことができます。
- `maxChips`を設定すると、指定した数を超えてチップを追加できなくなります。
- `emptyErrorText`を設定すると、チップが1つも選択されていない場合にバリデーションエラーとして表示されます。
- `readOnly`が`true`の場合、チップの追加・削除ができなくなりますが、表示は有効化されたままです。
- `enabled`が`false`の場合、チップの追加・削除ができなくなり、無効化の表示になります。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- `includeEditingTextOnSave`を`true`にすると、保存時に編集中のテキストもチップとして保存されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 最小・最大選択数のチェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. サジェストのリストは`suggestion`パラメータを使用して設定する。`suggestionBuilder`パラメータを使用することで、サジェストのウィジェットをカスタマイズ可能
8. `builder`内で`ref.delete(item)`を使用してチップに削除ボタンを追加する
9. `maxChips`を設定して選択数を制限する
10. `emptyErrorText`を設定して最低1つの選択を必須にする
11. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- タグ選択（記事のタグ、画像のタグなど）
- カテゴリー選択（複数カテゴリーの選択）
- スキル選択（ユーザーのスキルセット）
- 興味・関心の選択（プロフィール設定）
- フィルター設定（検索条件の複数選択）
- キーワード検索（複数キーワードの入力）
- メールアドレス入力（複数のメールアドレス）
- 参加者選択（イベントやプロジェクトの参加者）
- 言語選択（話せる言語の複数選択）
""";
  }
}
