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
      "非同期処理の結果を表示・入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで非同期データの管理と表示を行えます。ローディング表示、エラー表示、リトライ機能などを備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormFutureField`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormFutureField<String>(
    form: formController,
    future: () => fetchUserData(),
    builder: (context, form, data, child) {
      return FormTextField(
        form: form,
        initialValue: data,
        onSaved: (value) => form.value.copyWith(userData: value),
      );
    },
);
```

## ローディング表示のカスタマイズ

```dart
FormFutureField<UserData>(
    form: formController,
    future: () => fetchUserData(),
    loadingBuilder: (context, form, child) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    builder: (context, form, data, child) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: data.name,
            onSaved: (value) => form.value.copyWith(name: value),
          ),
          FormTextField(
            form: form,
            initialValue: data.email,
            onSaved: (value) => form.value.copyWith(email: value),
          ),
        ],
      );
    },
);
```

## エラー処理の実装

```dart
FormFutureField<UserData>(
    form: formController,
    future: () => fetchUserData(),
    errorBuilder: (context, form, error, child) {
      return Column(
        children: [
          Text("データの取得に失敗しました: \$error"),
          ElevatedButton(
            onPressed: () => form.refresh(),
            child: const Text("リトライ"),
          ),
        ],
      );
    },
    builder: (context, form, data, child) {
      return FormTextField(
        form: form,
        initialValue: data.name,
        onSaved: (value) => form.value.copyWith(name: value),
      );
    },
);
```

## 自動更新の実装

```dart
FormFutureField<PriceData>(
    form: formController,
    future: () => fetchLatestPrice(),
    refreshInterval: const Duration(minutes: 1),
    builder: (context, form, data, child) {
      return Text("現在の価格: ¥\${data.price}");
    },
);
```

## カスタムデザインの適用

```dart
FormFutureField<UserData>(
    form: formController,
    future: () => fetchUserData(),
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      loadingStyle: LoadingStyle(
        color: Colors.blue,
        size: 24.0,
      ),
      errorStyle: ErrorStyle(
        backgroundColor: Colors.red[50],
        textColor: Colors.red,
        iconColor: Colors.red,
      ),
    ),
    builder: (context, form, data, child) {
      return FormTextField(
        form: form,
        initialValue: data.name,
        onSaved: (value) => form.value.copyWith(name: value),
      );
    },
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `future`: 非同期処理。データを取得する非同期関数を定義します。
- `builder`: ビルダー関数。取得したデータを表示するウィジェットを生成します。

### オプションパラメータ
- `loadingBuilder`: ローディングビルダー。ローディング中の表示を定義します。
- `errorBuilder`: エラービルダー。エラー発生時の表示を定義します。
- `refreshInterval`: 更新間隔。自動更新の間隔を設定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `onData`: データ取得時のコールバック。データが取得された時の処理を定義します。
- `onError`: エラー発生時のコールバック。エラーが発生した時の処理を定義します。

## 注意点

- `FormController`と組み合わせて使用することで、非同期データを管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- エラー発生時は`errorBuilder`で適切なエラー表示を提供します。
- データの再取得は`form.refresh()`メソッドで実行できます。
- 自動更新は`refreshInterval`パラメータで設定できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 適切なローディングとエラー表示を提供する
3. エラー時のリトライ機能を実装する
4. 必要に応じて自動更新を設定する
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- APIからのデータ取得と表示
- 定期的なデータ更新
- 非同期データの編集
- バックグラウンド処理の状態表示
- リアルタイムデータの表示
""";
  }
}
