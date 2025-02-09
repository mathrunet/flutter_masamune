// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_duration_field.mdc.
///
/// form_duration_field.mdcの中身。
class KatanaFormDurationFieldMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_duration_field.mdc.
  ///
  /// form_duration_field.mdcの中身。
  const KatanaFormDurationFieldMdcCliAiCode();

  @override
  String get name => "`FormDurationField`の利用方法";

  @override
  String get description => "時間の長さ（Duration）を入力するための`FormDurationField`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "時間の長さ（Duration）を入力するためのフォームフィールド。時間、分、秒などの単位で時間の長さを設定でき、カスタムフォーマットやバリデーションなどの機能を備えています。`FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで入力値を管理できます。";

  @override
  String body(String baseName, String className) {
    return """
`FormDurationField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormDurationField(
    form: formController,
    initialValue: formController.value.duration,
    onSaved: (value) => formController.value.copyWith(duration: value),
);
```

## カスタム単位の利用方法

```dart
FormDurationField(
    form: formController,
    initialValue: formController.value.duration,
    units: const [DurationUnit.hours, DurationUnit.minutes],
    labels: const {
      DurationUnit.hours: "時間",
      DurationUnit.minutes: "分",
    },
    onSaved: (value) => formController.value.copyWith(duration: value),
);
```

## バリデーション付きの利用方法

```dart
FormDurationField(
    form: formController,
    initialValue: formController.value.duration,
    validator: (value) {
      if (value == null) {
        return "時間を入力してください";
      }
      if (value.inMinutes < 30) {
        return "30分以上の時間を設定してください";
      }
      if (value.inHours > 8) {
        return "8時間以内の時間を設定してください";
      }
      return null;
    },
    onSaved: (value) => formController.value.copyWith(duration: value),
);
```

## カスタムデザインの適用

```dart
FormDurationField(
    form: formController,
    initialValue: formController.value.duration,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      durationStyle: DurationStyle(
        backgroundColor: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        unitSpacing: 8.0,
      ),
    ),
    onSaved: (value) => formController.value.copyWith(duration: value),
);
```

## 最小値・最大値の設定

```dart
FormDurationField(
    form: formController,
    initialValue: formController.value.duration,
    minDuration: const Duration(minutes: 30),
    maxDuration: const Duration(hours: 8),
    onSaved: (value) => formController.value.copyWith(duration: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `onSaved`: 保存時のコールバック。入力された時間の保存処理を定義します。

### オプションパラメータ
- `initialValue`: 初期値。フォーム表示時の初期時間を設定します。
- `units`: 表示する単位。時間の単位（時、分、秒など）を指定します。
- `labels`: 単位のラベル。各単位に対応する表示テキストを設定します。
- `minDuration`: 最小時間。入力可能な最小の時間を設定します。
- `maxDuration`: 最大時間。入力可能な最大の時間を設定します。
- `validator`: バリデーション関数。入力値の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 入力可否。`false`の場合、入力が無効化されます。
- `onChanged`: 値変更時のコールバック。時間が変更された時の処理を定義します。

## 注意点

- `FormController`と組み合わせて使用することで、時間の値を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- バリデーションは`validator`パラメータを使用して定義します。
- 時間の単位は`units`パラメータで制御できます。
- 最小値・最大値は`minDuration`と`maxDuration`で設定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 用途に応じて適切な時間単位を選択する
3. 分かりやすい単位ラベルを設定する
4. 適切な最小値・最大値を設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- タスクの所要時間設定
- タイマーの時間設定
- 作業時間の入力
- 予約時間の長さ設定
- 制限時間の設定
""";
  }
}
