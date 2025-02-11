// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_style_container.mdc.
///
/// form_style_container.mdcの中身。
class KatanaFormStyleContainerMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_style_container.mdc.
  ///
  /// form_style_container.mdcの中身。
  const KatanaFormStyleContainerMdcCliAiCode();

  @override
  String get name => "`FormStyleContainer`の利用方法";

  @override
  String get description =>
      "`FormStyle`を適用するためのコンテナウィジェットである`FormStyleContainer`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`FormStyle`を適用するためのコンテナウィジェット。パディング、背景色、ボーダー、影などのスタイルを統一的に管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormStyleContainer`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormStyleContainer(
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Column(
      children: [
        FormTextField(...),
        FormPasswordBuilder(...),
        FormRatingBar(...),
      ],
    ),
);
```

## カスタムスタイルの適用

```dart
FormStyleContainer(
    style: const FormStyle(
      padding: EdgeInsets.all(24.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      elevation: 4.0,
      border: Border.all(
        color: Colors.grey[300],
        width: 1.0,
      ),
      textFieldStyle: TextFieldStyle(
        borderColor: Colors.blue,
        focusedBorderColor: Colors.blue[700],
        errorBorderColor: Colors.red,
        textStyle: TextStyle(fontSize: 16.0),
      ),
      buttonStyle: ButtonStyle(
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    child: Column(
      children: [
        FormTextField(...),
        FormPasswordBuilder(...),
        FormButton(...),
      ],
    ),
);
```

## スタイルの継承

```dart
FormStyleContainer(
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.white,
    ),
    child: Column(
      children: [
        FormStyleContainer(
          style: const FormStyle(
            margin: EdgeInsets.only(bottom: 16.0),
            border: Border.all(color: Colors.grey),
          ),
          child: FormTextField(...),
        ),
        FormStyleContainer(
          style: const FormStyle(
            backgroundColor: Colors.grey[100],
          ),
          child: FormPasswordBuilder(...),
        ),
      ],
    ),
);
```

## パラメータ

### 必須パラメータ
- `child`: 子ウィジェット。スタイルを適用する対象のウィジェットを指定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインを定義します。

### オプションパラメータ
- `enabled`: 有効/無効。`false`の場合、子ウィジェットが無効化されます。

## 注意点

- `FormStyle`は子ウィジェットに継承されます。
- 子ウィジェットで個別に`FormStyle`を指定すると、そのスタイルが優先されます。
- スタイルの継承は複数階層に渡って適用されます。
- `enabled`パラメータは子ウィジェットすべてに影響します。

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために使用する
2. 関連するフォームフィールドをグループ化する
3. 階層構造を活用して効率的にスタイルを管理する
4. 必要に応じて個別のフィールドでスタイルをオーバーライドする
5. レスポンシブデザインに対応したスタイルを設定する

## 利用シーン

- フォームのグループ化
- セクション別のスタイル適用
- 共通デザインの一括適用
- フォームのレイアウト管理
- デザインテーマの実装
""";
  }
}
