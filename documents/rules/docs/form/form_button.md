# `FormButton`の利用方法

`FormButton`は下記のように利用する。

## 概要

`ElevatedButton`、`FilledButton`、`OutlinedButton`、`TextButton`のMasamuneフレームワーク版。`FormStyle`で共通したデザインを適用可能。また`FormController`と連携してフォームの送信等を行うことができます。勿論通常のボタンとしても利用可能です。アイコン表示、カスタムデザインなどの機能を備えています。

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

## パラメータ

### 必須パラメータ
- 第1パラメータ: ボタンのラベル。ボタンに表示するテキストを設定します。

### オプションパラメータ
- `icon`: アイコン。ボタンに表示するアイコンを設定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 有効/無効。`false`の場合、ボタンが無効化されます。
- `onPressed`: タップ時のコールバック。ボタンがタップされた時の処理を定義します。

## 注意点

- `FormStyle`を使用することで、共通のデザインを適用できます。
- ボタンの有効/無効は`enabled`パラメータで制御できます。
- フォームの送信（サブミット）を行いたい場合は`onPressed`メソッド内で`formController.validate()`を呼び出してください。`formController.validate()`の戻り値が`null`の場合はフォームの検証に失敗しており、`null`でない場合はフォームの検証に成功しています。その値を`Document`の`save`メソッドに渡して保存を行ってください。
- 通常のボタンとして利用も可能です。

## ベストプラクティス

1. ユーザーにとって分かりやすいラベルを設定する
2. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
3. フォームの送信（サブミット）には`onPressed`メソッド内で`formController.validate()`を呼び出す。その戻り値によりフォームの検証に成功したかどうかを判断。
4. 通常のボタンとして利用も可能。

## 利用シーン

- フォームの送信（サブミット）ボタン
- データの保存ボタン
- 設定の適用ボタン
- 次へ進むボタン
- キャンセルボタン
