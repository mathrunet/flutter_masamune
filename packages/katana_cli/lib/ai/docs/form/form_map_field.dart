// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_map_field.mdc.
///
/// form_map_field.mdcの中身。
class KatanaFormMapFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_map_field.mdc.
  ///
  /// form_map_field.mdcの中身。
  const KatanaFormMapFieldMdcCliAiCode();

  @override
  String get name => "FormMapFieldの利用方法";

  @override
  String get description => "Map形式のデータを選択できるフォームフィールドである`FormMapField`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`Map`型のデータ入力に特化したフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用してマップデータの入力と管理を行うことができます。キーと値のペアの追加・編集・削除、バリデーション、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormMapField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormMapField(
    form: formController,
    initialValue: formController.value.settings,
    onSaved: (value) => formController.value.copyWith(settings: value),
);
```

## カスタムキー・バリュー入力の利用方法

```dart
FormMapField(
    form: formController,
    initialValue: formController.value.settings,
    keyLabel: "設定項目名",
    valueLabel: "設定値",
    keyHint: "例: テーマカラー",
    valueHint: "例: #FF0000",
    onSaved: (value) => formController.value.copyWith(settings: value),
);
```

## バリデーション付きの利用方法

```dart
FormMapField(
    form: formController,
    initialValue: formController.value.settings,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "設定項目を1つ以上追加してください";
      }
      if (!value.containsKey("theme")) {
        return "テーマの設定は必須です";
      }
      return null;
    },
    keyValidator: (value) {
      if (value == null || value.isEmpty) {
        return "設定項目名を入力してください";
      }
      if (value.length < 2) {
        return "設定項目名は2文字以上で入力してください";
      }
      return null;
    },
    valueValidator: (value) {
      if (value == null || value.isEmpty) {
        return "設定値を入力してください";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(settings: value),
);
```

## カスタムデザインの適用

```dart
FormMapField(
    form: formController,
    initialValue: formController.value.settings,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      backgroundColor: Colors.grey[200],
      mapStyle: MapStyle(
        itemSpacing: 16.0,
        keyValueSpacing: 8.0,
        addButtonStyle: ButtonStyle(
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        ),
        removeButtonStyle: ButtonStyle(
          backgroundColor: Colors.red,
          textColor: Colors.white,
        ),
      ),
    ),
    onSaved: (value) => formController.value.copyWith(settings: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。入力されたマップデータの保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期マップデータを設定します。
- `keyLabel`: キーのラベル。キー入力フィールドのラベルを設定します。
- `valueLabel`: 値のラベル。値入力フィールドのラベルを設定します。
- `keyHint`: キーのヒント。キー入力フィールドのヒントを設定します。
- `valueHint`: 値のヒント。値入力フィールドのヒントを設定します。
- `validator`: マップ全体のバリデーション関数。マップデータ全体の検証ルールを定義します。
- `keyValidator`: キーのバリデーション関数。キーの検証ルールを定義します。
- `valueValidator`: 値のバリデーション関数。値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、マップデータの編集が無効化されます。
- `maxItems`: 最大項目数。追加可能な項目の最大数を指定します。

## 注意点

- `FormController`と組み合わせて使用することで、マップデータの入力と管理を行えます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`、`keyValidator`、`valueValidator`パラメータを使用して定義します。
- キーと値のラベルやヒントは適切に設定することで、ユーザーの入力を補助できます。
- 最大項目数は`maxItems`で制限できます。
- キーは一意である必要があります。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 分かりやすいラベルとヒントを設定する
3. 適切なバリデーションを設定してデータの整合性を保つ
4. 必要に応じて最大項目数を制限する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- アプリケーション設定の管理
- カスタムメタデータの入力
- 属性値の設定
- 環境変数の管理
- タグと値のペアの入力
""";
  }
}
