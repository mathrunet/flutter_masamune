# `FormFocusNodeBuilder`の利用方法

`FormFocusNodeBuilder`は下記のように利用する。

## 概要

フォーカスノードを保持して提供するためのビルダー。フォーカス状態を管理し、フォーカスの取得・解放時の処理を実装できます。

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormFocusNodeBuilder`は、フォーカスノードを必要とするフォームウィジェットを囲んで使用します。内部で`FocusNode`を自動生成・管理し、ビルダー関数に渡します。

```dart
FormFocusNodeBuilder(
  builder: (context, focusNode) {
    // focusNodeがビルダーに渡される
    return FormTextField(
      form: formController,
      focusNode: focusNode,  // 渡されたfocusNodeを使用
      initialValue: formController.value.text,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## 基本的な利用方法

```dart
FormFocusNodeBuilder(
  builder: (context, focusNode) {
    return FormTextField(
      form: formController,
      focusNode: focusNode,
      initialValue: formController.value.text,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## 外部からフォーカスノードを渡す

```dart
final customFocusNode = FocusNode();

FormFocusNodeBuilder(
  focusNode: customFocusNode,  // 外部で作成したFocusNodeを使用
  builder: (context, focusNode) {
    return FormTextField(
      form: formController,
      focusNode: focusNode,
      initialValue: formController.value.text,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);

// 外部からフォーカスを制御
customFocusNode.requestFocus();  // フォーカスを取得
customFocusNode.unfocus();  // フォーカスを解放
```

## フォーカス状態を監視する

```dart
FormFocusNodeBuilder(
  builder: (context, focusNode) {
    // FocusNodeにリスナーを追加してフォーカス状態を監視
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print("フォーカスが取得されました");
      } else {
        print("フォーカスが解放されました");
      }
    });
    
    return FormTextField(
      form: formController,
      focusNode: focusNode,
      initialValue: formController.value.text,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## 複数フィールドでフォーカスを制御

```dart
FormFocusNodeBuilder(
  builder: (context, emailFocusNode) {
    return FormFocusNodeBuilder(
      builder: (context, passwordFocusNode) {
        return Column(
          children: [
            FormTextField(
              form: formController,
              focusNode: emailFocusNode,
              labelText: "メールアドレス",
              initialValue: formController.value.email,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                // Enterキーで次のフィールドにフォーカス
                passwordFocusNode.requestFocus();
              },
              onSaved: (value) => formController.value.copyWith(email: value),
            ),
            FormTextField(
              form: formController,
              focusNode: passwordFocusNode,
              labelText: "パスワード",
              initialValue: formController.value.password,
              textInputAction: TextInputAction.done,
              onSaved: (value) => formController.value.copyWith(password: value),
            ),
          ],
        );
      },
    );
  },
);
```

## カスタムデザインの適用

```dart
FormFocusNodeBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  builder: (context, focusNode) {
    return FormTextField(
      form: formController,
      focusNode: focusNode,
      initialValue: formController.value.text,
      onSaved: (value) => formController.value.copyWith(text: value),
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。`BuildContext`と`FocusNode`を受け取り、フォーカスノードを使用するウィジェットを生成します。

### オプションパラメータ
- `focusNode`: 外部からフォーカスノードを直接渡す場合に利用。未指定の場合は内部で自動生成されます。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。設定すると`FormContainer`でラップされます。

### `FocusNode`で利用可能な主なメソッドとプロパティ
- `hasFocus`: 現在フォーカスを持っているかどうかを取得します（`bool`型）。
- `requestFocus()`: フォーカスを取得します。
- `unfocus()`: フォーカスを解放します。
- `addListener()`: フォーカス状態の変更を監視するリスナーを追加します。
- `removeListener()`: リスナーを削除します。
- `dispose()`: フォーカスノードを破棄します（通常は`FormFocusNodeBuilder`が自動的に行います）。

## 注意点

- `builder`内で渡された`FocusNode`をフォームウィジェットの`focusNode`パラメータに渡す必要があります。
- `style`を設定すると、`FormContainer`で自動的にラップされます。
- 外部から`focusNode`を渡した場合、そのフォーカスノードが使用されます。未指定の場合は内部で自動生成されます。
- 外部から渡した`FocusNode`のライフサイクルは自分で管理する必要があります（`dispose()`の呼び出しなど）。
- 内部で自動生成された`FocusNode`は、`FormFocusNodeBuilder`が自動的に破棄します。
- `focusNode.addListener()`でリスナーを追加する場合、メモリリークを防ぐために`removeListener()`も実行する必要があります。ただし、`builder`内で毎回リスナーを追加すると問題が発生するため、`StatefulWidget`を使用して適切に管理してください。
- フォーカスの取得・解放時に処理を実行する場合は、`focusNode.addListener()`を使用します。

## ベストプラクティス

1. フォーカスノードが必要なフォームウィジェットには`FormFocusNodeBuilder`を使用する
2. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
3. 外部からフォーカスを制御する必要がある場合は、`focusNode`パラメータに外部で作成した`FocusNode`を渡す
4. フォーカス状態を監視する場合は、`focusNode.addListener()`を使用する
5. 複数のフォームフィールド間でフォーカスを移動する場合は、各フィールドに`FormFocusNodeBuilder`を使用する
6. `textInputAction`を`TextInputAction.next`に設定し、`onSubmitted`で次のフィールドに`requestFocus()`を呼び出す
7. リスナーを追加する場合は、適切なタイミングで`removeListener()`を呼び出してメモリリークを防ぐ
8. 内部で自動生成される`FocusNode`を使用する場合は、`dispose()`を呼び出す必要はない

## 利用シーン

- フォーカス時のハイライト表示（フォーカスされたフィールドの強調）
- フォーカス状態に応じたアニメーション（フォーカス取得時のアニメーション効果）
- フォーカスイベントのログ記録（ユーザー行動のトラッキング）
- フォーカス制御が必要なカスタムフォーム（複雑なフォーム操作）
- キーボード操作の最適化（Enterキーでのフィールド移動）
- フォーム入力の順序制御（次へ進む、前に戻るなどの操作）
- 自動フォーカス（画面表示時に特定のフィールドにフォーカス）
- フォーカス状態に応じたバリデーション表示
- フォーカス状態に応じたヘルプメッセージの表示
- アクセシビリティの向上（キーボードナビゲーション）
