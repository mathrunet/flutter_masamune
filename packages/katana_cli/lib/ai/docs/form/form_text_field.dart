// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_text_field.md.
///
/// form_text_field.mdの中身。
class KatanaFormTextFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_text_field.md.
  ///
  /// form_text_field.mdの中身。
  const KatanaFormTextFieldMdCliAiCode();

  @override
  String get name => "`FormTextField`の利用方法";

  @override
  String get description => "テキスト入力を行うためのフォームフィールドである`FormTextField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`TextFormField`のMasamuneフレームワーク版。テキスト入力を行うフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで`TextFormField`の値を管理可能。バリデーション、サジェスト機能（`SuggestionConfig`による高度な入力補完）、カスタムデザイン、フォーカス制御、複数行入力、文字数制限などの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormTextField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## ラベル・ヒント付きの利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  labelText: "ユーザー名",
  hintText: "例: yamada_taro",
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## サジェスト機能付きの利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  suggestion: SuggestionConfig(
    items: ["東京", "大阪", "名古屋", "福岡"],
    showOnTap: true,
    showOnEmpty: true,
  ),
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## バリデーション付きの利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  emptyErrorText: "必須項目です",
  lengthErrorText: "3文字以上入力してください",
  minLength: 3,
  validator: (value) {
    if (value?.contains("@") == false) {
      return "@を含めてください";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## パスワード入力の利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.password,
  labelText: "パスワード",
  obscureText: true,
  keyboardType: TextInputType.visiblePassword,
  onSaved: (value) => formController.value.copyWith(password: value),
);
```

## 複数行入力の利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.description,
  labelText: "説明",
  hintText: "詳細を入力してください",
  maxLines: 5,
  minLines: 3,
  keyboardType: TextInputType.multiline,
  onSaved: (value) => formController.value.copyWith(description: value),
);
```

## カスタムデザインの適用

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
    borderStyle: FormInputBorderStyle.outline,
    borderColor: Colors.blue,
    borderWidth: 2.0,
  ),
  prefix: FormAffixStyle(
    icon: Icon(Icons.person),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
  ),
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## フォーカス制御の利用方法

```dart
final focusNode = FocusNode();

FormTextField(
  form: formController,
  initialValue: formController.value.text,
  focusNode: focusNode,
  autofocus: true,
  selectionOnFocus: FormTextFieldSelectionOnFocus.selectAll,
  onFocusChanged: (value, hasFocus) {
    if (!hasFocus) {
      // フォーカスが外れた時の処理
      print("入力完了: \$value");
    }
  },
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## 文字数カウンター付きの利用方法

```dart
FormTextField(
  form: formController,
  initialValue: formController.value.text,
  maxLength: 100,
  counterbuilder: (text) => "\${text.length}/100",
  onSaved: (value) => formController.value.copyWith(text: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー（`FormController<TValue>`）。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック（`TValue Function(String value)`）。入力された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック（`void Function(String? value)`）。入力された値の変更時の処理を定義します。
- `style`: フォームのスタイル（`FormStyle`）。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数（`String? Function(String? value)`）。入力値の検証ルールを定義します。エラーメッセージを返すとエラーとして表示されます。
- `enabled`: 入力可否（`bool`、デフォルト: `true`）。`false`の場合、テキストフィールドが無効化されます。
- `initialValue`: 初期値（`String?`）。フォーム表示時の初期テキストを設定します。
- `focusNode`: フォーカスノード（`FocusNode?`）。フォームのフォーカスを制御します。
- `controller`: テキストコントローラー（`TextEditingController?`）。外部からテキストを制御する場合に使用します。

- `prefix`: プレフィックススタイル（`FormAffixStyle?`）。テキストフィールドの前に配置するウィジェット（アイコンやラベルなど）を設定します。
- `suffix`: サフィックススタイル（`FormAffixStyle?`）。テキストフィールドの後に配置するウィジェット（アイコンやラベルなど）を設定します。

- `labelText`: ラベルテキスト（`String?`）。テキストフィールド外に表示するラベルを設定します。
- `hintText`: ヒントテキスト（`String?`）。何も入力されていないときに表示するヒントテキストを設定します。
- `emptyErrorText`: 空のエラーメッセージ（`String?`）。入力が空の場合に表示するエラーメッセージを設定します。
- `lengthErrorText`: 桁数エラーメッセージ（`String?`）。入力された値の文字数が`minLength`未満の場合に表示するエラーメッセージを設定します。

- `keyboardType`: キーボードのタイプ（`TextInputType`、デフォルト: `TextInputType.text`）。テキスト入力のキーボードのタイプを設定します。
- `inputFormatters`: 入力フォーマッター（`List<TextInputFormatter>?`）。入力値のフォーマットを定義します（数字のみ、電話番号形式など）。

- `autofocus`: 自動フォーカス（`bool`、デフォルト: `false`）。`true`の場合、フォーム表示時に自動的にフォーカスされます。
- `autocorrect`: 自動修正（`bool`、デフォルト: `false`）。`true`の場合、入力中に自動的に修正されます。
- `selectionOnFocus`: フォーカス時の選択動作（`FormTextFieldSelectionOnFocus`、デフォルト: `selectAll`）。フォーカス時にテキストを全選択するか、カーソルを末尾に移動するかを設定します。

- `onFocusChanged`: フォーカス変更時のコールバック（`void Function(String? value, bool hasFocus)`）。フォーカスの変更時の処理を定義します。
- `onSubmitted`: 送信時のコールバック（`void Function(String? value)`）。Enterキーやソフトウェアキーボードの送信ボタンが押された時の処理を定義します。
- `onTap`: タップ時のコールバック（`VoidCallback?`）。タップ時の処理を定義します。

- `readOnly`: 読み取り専用（`bool`、デフォルト: `false`）。`true`の場合、テキストフィールドが読み取り専用になります。
- `obscureText`: パスワードマスク（`bool`、デフォルト: `false`）。`true`の場合、入力文字がマスクされます（パスワード入力用）。
- `showCursor`: カーソル表示（`bool?`）。カーソルの表示・非表示を設定します。

- `maxLines`: 最大行数（`int`、デフォルト: `1`）。複数行入力を許可する場合に設定します。`null`の場合は無制限。
- `minLines`: 最小行数（`int`、デフォルト: `1`）。複数行入力の最小行数を設定します。
- `expands`: 拡張（`bool`、デフォルト: `false`）。`true`の場合、テキストフィールドが親のサイズに合わせて拡張されます。

- `minLength`: 最小文字数（`int?`）。入力できる最小文字数を設定します。`lengthErrorText`と併用してバリデーションを行います。
- `maxLength`: 最大文字数（`int?`）。入力できる最大文字数を設定します。

- `counterText`: カウンターテキスト（`String?`、デフォルト: `""`）。入力文字数のカウントを表示するテキストを設定します。デフォルトは空文字（非表示）です。
- `counterbuilder`: カウンタービルダー（`String? Function(String text)?`）。入力文字数のカウントを表示するためのビルダー。`counterText`より優先されます。

- `suggestion`: サジェスト設定（`SuggestionConfig?`）。入力補完として表示するサジェストの設定を行います。候補リスト、表示条件、タップ時の動作などをカスタマイズできます。

- `keepAlive`: 生存維持（`bool`、デフォルト: `true`）。リスト内に配置した場合にスクロール時に破棄されないようにするかどうかを設定します。
- `clearOnSubmitted`: 送信時にクリア（`bool`、デフォルト: `false`）。`true`の場合、送信時に入力内容がクリアされます。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。両方の定義が必須です。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- ヒントテキストは`hintText`パラメータを使用して設定できます。
- 空のエラーメッセージは`emptyErrorText`パラメータを使用して設定できます。
- 文字数のエラーメッセージは`lengthErrorText`と`minLength`を併用して設定できます。
- キーボードのタイプは`keyboardType`パラメータを使用して設定できます。
- 入力フォーマッターは`inputFormatters`パラメータを使用して設定できます。
- 自動フォーカスは`autofocus`パラメータを使用して設定できます。
- 自動修正は`autocorrect`パラメータを使用して設定できます。
- `maxLines`および`minLines`と`expands`は同時に使用できません。
- `obscureText`が`true`の場合、`maxLines`は自動的に`1`に設定されます（複数行入力不可）。
- サジェスト機能を使用する場合は、`SuggestionConfig`を適切に設定してください。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
4. バリデーションは`emptyErrorText`、`lengthErrorText`、`validator`パラメータを組み合わせて定義する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. パスワード入力には必ず`obscureText: true`を設定する
7. 複数行入力の場合は`keyboardType: TextInputType.multiline`を設定する
8. フォーカス制御が必要な場合は`FocusNode`を使用する
9. サジェスト機能を使用する場合は、`SuggestionConfig`で表示条件やタップ時の動作をカスタマイズする
10. `prefix`や`suffix`を使用してアイコンやラベルを配置し、ユーザビリティを向上させる

## 利用シーン

- ユーザー名の入力（プレーンテキスト）
- パスワードの入力（`obscureText: true`を使用）
- メールアドレスの入力（`keyboardType: TextInputType.emailAddress`を使用）
- メモや投稿のコンテンツ入力（複数行入力）
- 電話番号の入力（`keyboardType: TextInputType.phone`を使用）
- 住所の入力（サジェスト機能を使用）
- 検索フィールド（サジェスト機能を使用）
- URL入力（`keyboardType: TextInputType.url`を使用）
- 数値入力（`keyboardType: TextInputType.number`と`inputFormatters`を使用）
- その他あらゆるプレーンテキストの入力
""";
  }
}
