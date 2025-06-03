// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_label.md.
///
/// form_label.mdの中身。
class KatanaFormLabelMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_label.md.
  ///
  /// form_label.mdの中身。
  const KatanaFormLabelMdCliAiCode();

  @override
  String get name => "`FormLabel`の利用方法";

  @override
  String get description => "フォームフィールドのラベルを表示するための`FormLabel`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "フォームフィールドのラベルを表示するためのウィジェット。`FormStyle`で共通したデザインを適用可能。必須マーク、ヘルプテキスト、エラーメッセージなどの表示機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormLabel`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormLabel(
  "ユーザー名",
);
```

## アイコン付きの利用方法

```dart
FormLabel(
  "ユーザー名",
  icon: Icon(Icons.person),
);
```

## ヘルプテキスト付きの利用方法

```dart
FormLabel(
  "ユーザー名",
  icon: Icon(Icons.person),
  notice: Text("8文字以上の英数字を入力してください"),
);
```

## カスタムデザインの適用

```dart
FormLabel(
  "ユーザー名",
  style: const FormStyle(
    color: Colors.blue,
  ),
);
```

## パラメータ

### 必須パラメータ
- 第1パラメーター: ラベルテキスト。フィールドの説明ラベルを設定します。

### オプションパラメータ
- `icon`: アイコン。ラベルの前に表示するアイコンを設定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `color`: ラベルとアイコンの色を変更します。
- `prefix`: 分断線の前に表示するウィジェットを設定します。
- `suffix`: 分断線の後に表示するウィジェットを設定します。
- `notice`: ヘルプテキスト。フィールドの説明文を設定します。
- `showDivider`: 分断線を表示するかどうかを設定します。

## 注意点

- `FormStyle`を使用することで、共通のデザインを適用できます。
- アイコンは`icon`パラメータを使用して設定できます。
- ヘルプテキストは`notice`パラメータを使用して設定できます。
- 分断線は`showDivider`パラメータを使用して設定できます。

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
2. ラベルテキストは`label`パラメータを使用して設定する。
3. アイコンは`icon`パラメータを使用して設定する。
4. ヘルプテキストは`notice`パラメータを使用して設定する。
5. 分断線は`showDivider`パラメータを使用して設定する。

## 利用シーン

- フォームフィールドのラベル表示
- 必須入力項目の明示
- フィールドの説明表示
- フォームのセクション分け
""";
  }
}
