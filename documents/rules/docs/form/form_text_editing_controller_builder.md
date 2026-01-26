# `FormTextEditingControllerBuilder`の利用方法

`FormTextEditingControllerBuilder`は下記のように利用する。

## 概要

TextEditingControllerを提供するビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでテキスト入力の状態管理を行えます。

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormTextEditingControllerBuilder`は、`TextEditingController`を必要とするフォームウィジェットを囲んで使用します。内部で`TextEditingController`を自動生成・管理し、ビルダー関数に渡します。

```dart
FormTextEditingControllerBuilder(
  builder: (context, controller) {
    // controllerがビルダーに渡される
    return FormTextField(
      form: formController,
      controller: controller,  // 渡されたcontrollerを使用
      initialValue: formController.value.text,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## 基本的な利用方法

```dart
FormTextEditingControllerBuilder(
  builder: (context, controller) {
    return FormTextField(
      form: formController,
      controller: controller,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormTextEditingControllerBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  builder: (context, controller) {
    return FormTextField(
      form: formController,
      controller: controller,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## 外部からコントローラーを渡す

```dart
final customController = TextEditingController();

FormTextEditingControllerBuilder(
  controller: customController,  // 外部で作成したTextEditingControllerを使用
  builder: (context, controller) {
    return FormTextField(
      form: formController,
      controller: controller,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);

// 外部からテキストを制御
customController.text = "新しいテキスト";
customController.clear();  // テキストをクリア
```

## コントローラーを使ってテキストを監視

```dart
FormTextEditingControllerBuilder(
  builder: (context, controller) {
    // TextEditingControllerにリスナーを追加してテキスト変更を監視
    controller.addListener(() {
      print("テキストが変更されました: ${controller.text}");
    });
    
    return FormTextField(
      form: formController,
      controller: controller,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## 複数フィールドでコントローラーを制御

```dart
FormTextEditingControllerBuilder(
  builder: (context, searchController) {
    return Column(
      children: [
        FormTextField(
          form: formController,
          controller: searchController,
          labelText: "検索",
          onSaved: (value) => formController.value.copyWith(search: value),
        ),
        ElevatedButton(
          onPressed: () {
            // コントローラーを使って検索をクリア
            searchController.clear();
          },
          child: Text("クリア"),
        ),
      ],
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。`BuildContext`と`TextEditingController`を受け取り、テキスト入力コントローラーを使用するウィジェットを生成します。

### オプションパラメータ
- `controller`: 外部からTextEditingControllerを直接渡す場合に利用。未指定の場合は内部で自動生成されます。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。設定すると`FormContainer`でラップされます。

### `TextEditingController`で利用可能な主なメソッドとプロパティ
- `text`: 現在のテキスト内容を取得・設定します（`String`型）。
- `clear()`: テキストをクリアします。
- `selection`: 現在の選択範囲を取得・設定します（`TextSelection`型）。
- `addListener()`: テキスト変更を監視するリスナーを追加します。
- `removeListener()`: リスナーを削除します。
- `dispose()`: コントローラーを破棄します（通常は`FormTextEditingControllerBuilder`が自動的に行います）。

## 注意点

- `builder`内で渡された`TextEditingController`をフォームウィジェットの`controller`パラメータに渡す必要があります。
- `style`を設定すると、`FormContainer`で自動的にラップされます。
- 外部から`controller`を渡した場合、そのコントローラーが使用されます。未指定の場合は内部で自動生成されます。
- 外部から渡した`TextEditingController`のライフサイクルは自分で管理する必要があります（`dispose()`の呼び出しなど）。
- 内部で自動生成された`TextEditingController`は、`FormTextEditingControllerBuilder`が自動的に破棄します。
- `controller.addListener()`でリスナーを追加する場合、メモリリークを防ぐために`removeListener()`も実行する必要があります。ただし、`builder`内で毎回リスナーを追加すると問題が発生するため、`StatefulWidget`を使用して適切に管理してください。
- コントローラーの変更を監視する場合は、`controller.addListener()`を使用します。
- `FormController`の配置や管理は、内部の`FormTextField`で行います（`FormTextEditingControllerBuilder`自体は`FormController`を持ちません）。

## ベストプラクティス

1. テキストコントローラーが必要なフォームウィジェットには`FormTextEditingControllerBuilder`を使用する
2. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
3. 外部からテキストを制御する必要がある場合は、`controller`パラメータに外部で作成した`TextEditingController`を渡す
4. テキスト変更を監視する場合は、`controller.addListener()`を使用する
5. リスナーを追加する場合は、適切なタイミングで`removeListener()`を呼び出してメモリリークを防ぐ
6. 内部で自動生成される`TextEditingController`を使用する場合は、`dispose()`を呼び出す必要はない
7. 検索フィールドでクリアボタンを実装する場合、`controller.clear()`を使用する
8. フォームのリセット時に`controller.text`を初期値に戻す

## 利用シーン

- 検索フィールドの実装（検索テキストの制御、クリアボタン）
- テキスト入力の外部制御（プログラムからテキスト設定）
- テキスト変更の監視（リアルタイム検証、文字数カウント）
- フォームのリセット機能（入力内容のクリア）
- 自動入力機能（テンプレート挿入、定型文挿入）
- テキストのプログラマティックな操作（テキスト変換、フォーマット）
- 複数フィールド間でのテキスト連携（住所自動入力など）
- デバッグ用のテキスト制御（開発時のテスト入力）
- カスタムテキスト入力UI（独自の入力補助機能）
- テキスト編集履歴の管理（Undo/Redo機能）
