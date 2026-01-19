// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_button.md.
///
/// form_button.mdの中身。
class KatanaFormButtonMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_button.md.
  ///
  /// form_button.mdの中身。
  const KatanaFormButtonMdCliAiCode();

  @override
  String get name => "`FormButton`の利用方法";

  @override
  String get description => "フォームの送信（サブミット）も行えるボタンを表示するための`FormButton`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "`ElevatedButton`、`FilledButton`、`OutlinedButton`、`TextButton`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`と連携してフォームの送信等を行うことができます。勿論通常のボタンとしても利用可能です。アイコン表示、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormButton`は下記のように利用する。

## 概要

$excerpt

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 基本的な利用方法

```dart
FormButton(
  "保存",
  onPressed: () async {
    final value = formController.validate();
    if (value == null) {
      return;
    }
    final document = appRef.model(AnyModel.collection()).create();
    await document.save(value);
    Modal.alert(
      context,
      title: "完了",
      text: "保存が完了しました。",
      submitText: "閉じる",
      onSubmit: () {
        Navigator.pop(context);
      },
    );
  },
);
```

## アイコン付きの利用方法

```dart
FormButton(
  "保存",
  icon: Icon(Icons.save),
  onPressed: () async {
    final value = formController.validate();
    if (value == null) {
      return;
    }
    final document = appRef.model(AnyModel.collection()).create();
    await document.save(value);
    Modal.alert(
      context,
      title: "完了",
      text: "保存が完了しました。",
      submitText: "閉じる",
      onSubmit: () {
        Navigator.pop(context);
      },
    );
  },
);
```

## カスタムデザインの適用

```dart
FormButton(
  "保存",
  icon: Icon(Icons.save),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.blue,
    color: Colors.white,
  ),
  onPressed: () async {
    final value = formController.validate();
    if (value == null) {
      return;
    }
    final document = appRef.model(AnyModel.collection()).create();
    await document.save(value);
    Modal.alert(
      context,
      title: "完了",
      text: "保存が完了しました。",
      submitText: "閉じる",
      onSubmit: () {
        Navigator.pop(context);
      },
    );
  },
);
```

## ボタンのサイズとアライメント設定

```dart
FormButton(
  "保存",
  style: const FormStyle(
    width: 200,
    height: 50,
    alignment: Alignment.center,
    backgroundColor: Colors.blue,
    color: Colors.white,
  ),
  onPressed: () async {
    // 処理
  },
);
```

## 境界線付きボタン

```dart
FormButton(
  "保存",
  style: const FormStyle(
    borderWidth: 2.0,
    borderColor: Colors.blue,
    backgroundColor: Colors.transparent,
    color: Colors.blue,
  ),
  onPressed: () async {
    // 処理
  },
);
```

## プレフィックス・サフィックス付きボタン

```dart
FormButton(
  "保存",
  style: FormStyle(
    prefix: FormAffixStyle(
      icon: Icon(Icons.arrow_back),
      iconColor: Colors.white,
    ),
    suffix: FormAffixStyle(
      icon: Icon(Icons.arrow_forward),
      iconColor: Colors.white,
    ),
    backgroundColor: Colors.blue,
    color: Colors.white,
  ),
  onPressed: () async {
    // 処理
  },
);
```

## ボタンの無効化

```dart
FormButton(
  "保存",
  enabled: false,
  style: const FormStyle(
    disabledBackgroundColor: Colors.grey,
    disabledColor: Colors.white,
  ),
  onPressed: () async {
    // 処理（enabledがfalseなので実行されない）
  },
);
```

## パラメータ

### 必須パラメータ
- 第1パラメータ (`label`): ボタンのラベル。ボタンに表示するテキストを設定します。

### オプションパラメータ
- `icon`: アイコン。ボタンに表示するアイコンを設定します。ラベルの左側に表示されます。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 有効/無効。`false`の場合、ボタンが無効化されます。デフォルトは`true`です。
- `onPressed`: タップ時のコールバック。ボタンがタップされた時の処理を定義します。

### `FormStyle`で設定可能なプロパティ
- `backgroundColor`: ボタンの背景色
- `color`: ボタンのテキスト色とアイコンの色
- `disabledBackgroundColor`: 無効化時のボタンの背景色
- `disabledColor`: 無効化時のボタンのテキスト色とアイコンの色
- `borderRadius`: ボタンの角丸設定
- `borderWidth`: ボタンの境界線の太さ
- `borderColor`: ボタンの境界線の色
- `padding`: ボタンコンテナの外側のパディング
- `contentPadding`: ボタンコンテンツ（テキストとアイコン）の内側のパディング
- `width`: ボタンの幅
- `height`: ボタンの高さ
- `alignment`: ボタンコンテナ内でのアライメント
- `textStyle`: テキストスタイル
- `activeColor`: タップ時のハイライト色
- `prefix`: ボタンの左端に表示する追加要素（`FormAffixStyle`）
- `suffix`: ボタンの右端に表示する追加要素（`FormAffixStyle`）

## 注意点

- `FormStyle`を使用することで、共通のデザインを適用できます。
- ボタンの有効/無効は`enabled`パラメータで制御できます。デフォルトは`true`です。
- `enabled`が`false`の場合、`onPressed`は実行されません。
- フォームの送信（サブミット）を行いたい場合は`onPressed`メソッド内で`formController.validate()`を呼び出してください。`formController.validate()`の戻り値が`null`の場合はフォームの検証に失敗しており、`null`でない場合はフォームの検証に成功しています。その値を`Document`の`save`メソッドに渡して保存を行ってください。
- 通常のボタンとして利用も可能です（`FormController`との連携は必須ではありません）。
- `icon`は`label`の左側に表示されます。`prefix`や`suffix`を使用すると、さらに左右に要素を追加できます。
- ボタンのデフォルトの角丸は`BorderRadius.circular(32)`です。
- `borderWidth`を設定しないと境界線は表示されません。境界線を表示したい場合は`borderWidth`に`0`より大きい値を設定してください。

## ベストプラクティス

1. ユーザーにとって分かりやすいラベルを設定する
2. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
3. フォームの送信（サブミット）には`onPressed`メソッド内で`formController.validate()`を呼び出す。その戻り値によりフォームの検証に成功したかどうかを判断
4. 通常のボタンとして利用も可能（`FormController`との連携は必須ではない）
5. アイコンを使用する場合は、`icon`パラメータを使用して視覚的にわかりやすくする
6. ボタンのサイズは`width`と`height`で明示的に設定することで、レイアウトの一貫性を保つ
7. 境界線付きボタンを作成する場合は、`borderWidth`と`borderColor`を設定し、`backgroundColor`を`Colors.transparent`にする
8. 無効化時のデザインは`disabledBackgroundColor`と`disabledColor`で適切に設定する
9. `prefix`や`suffix`を使用して、ボタンの左右に追加の要素を配置できる

## 利用シーン

- フォームの送信（サブミット）ボタン
- データの保存ボタン
- 設定の適用ボタン
- 次へ進むボタン
- キャンセルボタン
- 削除ボタン
- ログインボタン
- サインアップボタン
- 検索ボタン
- フィルター適用ボタン
- ダウンロードボタン
- アップロードボタン
""";
  }
}
