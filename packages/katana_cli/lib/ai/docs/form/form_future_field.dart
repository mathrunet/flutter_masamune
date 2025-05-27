// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_future_field.md.
///
/// form_future_field.mdの中身。
class KatanaFormFutureFieldMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_future_field.md.
  ///
  /// form_future_field.mdの中身。
  const KatanaFormFutureFieldMdCliAiCode();

  @override
  String get name => "`FormFutureField`の利用方法";

  @override
  String get description =>
      "非同期処理の結果を表示・入力するためのフォームフィールドである`FormFutureField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "非同期処理の結果を表示・入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで非同期データの管理と表示を行えます。主に`Modal`や別`Page`にフォームフィールドを作成し、その結果を受け取るために利用することが多いです。";

  @override
  String body(String baseName, String className) {
    return """
`FormFutureField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  }
);
```

## 表示テキストを変更する場合

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  parseToString: (value) => value.label,
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  }
);
```

## 表示を自由に設定する場合

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  },
  builder: (context, ref) {
    return GestureDetector(
      onTap: () {
        ref.onTap();
      },
      child: CircleAvatar(
        backgroundImage: Asset.image(ref.value),
      ),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormFutureField<UserData>(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  parseToString: (value) => value.label,
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  }
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
```

## パラメータ

### 必須パラメータ
- `onTap`: フォームをタップして非同期の結果を取得するための処理を記述するコールバック。

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
- `parseToString`: フォーム内で保持している値をテキストフィールド内で表示する文字列に変換するための処理を定義します。
- `builder`: 自由にカスタマイズしたウィジェットを表示するためのビルダー。
- `emptyErrorText`: 空のエラーメッセージ。選択が空の場合に表示するエラーメッセージを設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `onTap`パラメータを使用することで、フォームをタップして非同期の結果を取得するための処理を定義することができます。
- `parseToString`パラメータを使用することで、フォーム内で保持している値をテキストフィールド内で表示する文字列に変換することができます。
- `builder`パラメータを使用することで、自由にカスタマイズしたウィジェットを表示することができます。
- `parseToString`と`builder`は同時に利用することはできません。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. `onTap`内で`router`や`Modal`を利用して非同期結果を取得。

## 利用シーン

- 別`Modal`や別`Page`でのフォームフィールドの結果を受け取る
- 確認が必要な処理の結果を受け取る
- WebViewなどの外部の結果を受け取る
""";
  }
}
