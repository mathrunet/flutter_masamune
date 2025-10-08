// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_list_builder.md.
///
/// form_list_builder.mdの中身。
class KatanaFormListBuilderMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_list_builder.md.
  ///
  /// form_list_builder.mdの中身。
  const KatanaFormListBuilderMdCliAiCode();

  @override
  String get name => "`FormListBuilder`の利用方法";

  @override
  String get description =>
      "リスト形式のデータを動的に追加・削除・編集できるフォームビルダーである`FormListBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "リスト形式のデータを動的に追加・削除・編集できるフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでリストの状態管理を行えます。バリデーション、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormListBuilder`は下記のように利用する。

## 概要

$excerpt

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormListBuilder(
        initialValue: formController.value.tags,
        onSaved: (value) => formController.value.copyWith(tags: value),
        builder: (context, ref, item, index) {
          return Text(item);
        },
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormListBuilder(
  form: formController,
  initialValue: formController.value.tags,
  onSaved: (value) => formController.value.copyWith(tags: value),
  builder: (context, ref, item, index) {
    return Text(item);
  },
);
```

## 基本的な利用方法

```dart
FormListBuilder(
  form: formController,
  initialValue: formController.value.selection,
  onSaved: (value) {
    final newList = List<AnyModel>.from(formController.value);
    newList[index] = newList[index].copyWith(selection: []);
    return newList;
  },
  builder: (context, ref, item, index) {
    return FormTextField(
      form: formController,
      key: ValueKey("selection_\${ref.version}_\$index"),
      hintText: "選択肢\${index + 1}",
      initialValue: item,
      onFocusChanged: (value, focus) {
        if (!focus) {
          ref.update(index, value ?? item);
        }
      },
      onSubmitted: (value) {
        ref.update(index, value ?? item);
      },
      onSaved: (value) {
        final newList =
            List<AnyModel>.from(formController.value);
        newList[index] = newList[index].copyWith(
          selection: [...newList[index].selection, value],
        );
        return newList;
      },
    );
  },
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormListBuilder(
  initialValue: ["Flutter", "React", "Vue.js", "Angular", "Node.js"],
  onChanged: (value) {
    print(value);
  },
  builder: (context, ref, item, index) {
    return FormTextField(
      form: formController,
      key: ValueKey("selection_\${ref.version}_\$index"),
      hintText: "選択肢\${index + 1}",
      initialValue: item,
      onFocusChanged: (value, focus) {
        if (!focus) {
          ref.update(index, value ?? item);
        }
      },
      onSubmitted: (value) {
        ref.update(index, value ?? item);
      },
      onSaved: (value) {
        final newList =
            List<AnyModel>.from(formController.value);
        newList[index] = newList[index].copyWith(
          selection: [...newList[index].selection, value],
        );
        return newList;
      },
    );
  },
);
```

## 追加・削除ボタン付きの利用方法

```dart
FormListBuilder(
  form: formController,
  initialValue: formController.value.selection,
  onSaved: (value) {
    final newList = List<AnyModel>.from(formController.value);
    newList[index] = newList[index].copyWith(selection: []);
    return newList;
  },
  builder: (context, ref, item, index) {
    return Row(
      children: [
        16.sx,
        Text("\${index + 1}"),
        8.sx,
        Expanded(
          child: FormTextField(
            form: formController,
            key: ValueKey("selection_\${ref.version}_\$index"),
            hintText: "選択肢\${index + 1}",
            initialValue: item,
            onFocusChanged: (value, focus) {
              if (!focus) {
                ref.update(index, value ?? item);
              }
            },
            onSubmitted: (value) {
              ref.update(index, value ?? item);
            },
            onSaved: (value) {
              final newList =
                  List<AnyModel>.from(formController.value);
              newList[index] = newList[index].copyWith(
                selection: [...newList[index].selection, value],
              );
              return newList;
            },
          ),
        ),
        InkWell(
          onTap: () async {
            // フォーカスを外さないとエラー
            FocusScope.of(context).unfocus();
            // 待たないとエラー
            await Future.delayed(const Duration(milliseconds: 100));
            ref.deleteAt(index);
          },
          child: const Icon(Icons.delete),
        ),
        16.sx,
      ],
    );
  },
  bottom: (context, ref) {
    return Center(
      child: Padding(
        key: const ValueKey("add"),
        padding: 8.pt,
        child: FormButton(
          onPressed: () async {
            // フォーカスを外さないとエラー
            FocusScope.of(context).unfocus();
            // 待たないとエラー
            await Future.delayed(const Duration(milliseconds: 100));
            ref.add("");
          },
          label: const Text("選択肢を追加"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  },
);
```

## バリデーション付きの利用方法

```dart

FormListBuilder(
  form: formController,
  initialValue: formController.value.selection,
  onSaved: (value) {
    final newList = List<AnyModel>.from(formController.value);
    newList[index] = newList[index].copyWith(selection: []);
    return newList;
  },
  validator: (value) {
    if (value.isEmpty) {
      return "少なくとも1つの連絡先を追加してください";
    }
    return null;
  },
  builder: (context, ref, item, index) {
    return Row(
      children: [
        16.sx,
        Text("\${index + 1}"),
        8.sx,
        Expanded(
          child: FormTextField(
            form: formController,
            key: ValueKey("selection_\${ref.version}_\$index"),
            hintText: "選択肢\${index + 1}",
            initialValue: item,
            onFocusChanged: (value, focus) {
              if (!focus) {
                ref.update(index, value ?? item);
              }
            },
            onSubmitted: (value) {
              ref.update(index, value ?? item);
            },
            onSaved: (value) {
              final newList =
                  List<AnyModel>.from(formController.value);
              newList[index] = newList[index].copyWith(
                selection: [...newList[index].selection, value],
              );
              return newList;
            },
          ),
        ),
        InkWell(
          onTap: () async {
            // フォーカスを外さないとエラー
            FocusScope.of(context).unfocus();
            // 待たないとエラー
            await Future.delayed(const Duration(milliseconds: 100));
            ref.deleteAt(index);
          },
          child: const Icon(Icons.delete),
        ),
        16.sx,
      ],
    );
  },
  bottom: (context, ref) {
    return Center(
      child: Padding(
        key: const ValueKey("add"),
        padding: 8.pt,
        child: FormButton(
          onPressed: () async {
            // フォーカスを外さないとエラー
            FocusScope.of(context).unfocus();
            // 待たないとエラー
            await Future.delayed(const Duration(milliseconds: 100));
            ref.add("");
          },
          label: const Text("選択肢を追加"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormListBuilder(
  form: formController,
  initialValue: formController.value.selection,
  onSaved: (value) {
    final newList = List<AnyModel>.from(formController.value);
    newList[index] = newList[index].copyWith(selection: []);
    return newList;
  },
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.grey[100],
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  builder: (context, ref, item, index) {
    return FormTextField(
      form: formController,
      key: ValueKey("selection_\${ref.version}_\$index"),
      hintText: "選択肢\${index + 1}",
      initialValue: item,
      onFocusChanged: (value, focus) {
        if (!focus) {
          ref.update(index, value ?? item);
        }
      },
      onSubmitted: (value) {
        ref.update(index, value ?? item);
      },
      onSaved: (value) {
        final newList =
            List<AnyModel>.from(formController.value);
        newList[index] = newList[index].copyWith(
          selection: [...newList[index].selection, value],
        );
        return newList;
      },
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。各アイテムのウィジェットを生成します。`BuildContext`、`FormListBuilderRef`、アイテム（型`T`）、インデックス（`int`）を受け取ります。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。リスト全体の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。`builder`の中で定義された各要素の`Form`の`onSaved`メソッドよりも必ず前に実行されるのでリストの初期化などが行えます。
- `onChanged`: 変更時のコールバック。リストが変更された時（追加、削除、更新）の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。リスト全体の検証ルールを定義します（例: 最小・最大アイテム数のチェック）。
- `enabled`: 入力可否。`false`の場合、リスト全体が無効化されます。デフォルトは`true`です。
- `readOnly`: リストの読み取り専用化。`true`の場合、追加・削除・編集ができなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期リストを設定します（型`List<T>`）。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `top`: リストの上部に表示するウィジェットを生成するビルダー関数。`BuildContext`と`FormListBuilderRef`を受け取ります。
- `bottom`: リストの下部に表示するウィジェットを生成するビルダー関数。`BuildContext`と`FormListBuilderRef`を受け取ります。通常は追加ボタンの配置に使用します。

### `FormListBuilderRef`で利用可能なプロパティとメソッド
- `version`: リストのバージョン番号（`int`型）。アイテムの追加・削除時にインクリメントされます。`ValueKey`に使用して要素の再構築を制御します。
- `add(T item)`: リストの末尾にアイテムを追加します。
- `update(int index, T item)`: 指定したインデックスのアイテムを更新します。
- `delete(T item)`: 指定したアイテムをリストから削除します。
- `deleteAt(int index)`: 指定したインデックスのアイテムをリストから削除します。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- `builder`内で各要素のフォームフィールドを配置する際、必ず`ValueKey("list_\${ref.version}_\$index")`のような一意のキーを設定してください。これにより、要素の追加・削除時に正しく再構築されます。
- `FormListBuilder`の`onSaved`メソッドはリストの初期化に使用し、各要素の`Form`の`onSaved`メソッドで個別の要素を追加していく実装パターンが推奨されます。
- 各要素のフォームフィールドで`onFocusChanged`や`onSubmitted`を使用して、`ref.update(index, value)`を呼び出すことで、リアルタイムでリストを更新できます。
- **重要**: アイテムの追加（`ref.add()`）や削除（`ref.deleteAt()`）を行う前に、必ずフォーカスを解放してください（`FocusScope.of(context).unfocus()`）。
- **重要**: フォーカスを解放した後、`await Future.delayed(const Duration(milliseconds: 100))`で待機時間を設けてからアイテムの追加・削除を実行してください。これを行わないとエラーが発生します。
- `readOnly`が`true`の場合、追加・削除・編集は無効化されますが、表示は行われます。
- `version`プロパティは、アイテムの追加・削除時に自動的にインクリメントされます。`update()`メソッドでは変更されません。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 最小アイテム数、最大アイテム数のチェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. 各要素に`ValueKey("list_\${ref.version}_\$index")`のような一意のキーを必ず設定する
8. `FormListBuilder`の`onSaved`でリストを初期化し、各要素の`onSaved`で個別要素を追加する
9. `onFocusChanged`や`onSubmitted`で`ref.update()`を呼び出して、リアルタイム更新を実装する
10. アイテムの追加・削除時は、必ず`FocusScope.of(context).unfocus()`でフォーカスを解放する
11. フォーカス解放後、`await Future.delayed(const Duration(milliseconds: 100))`で待機してから追加・削除を実行する
12. `bottom`パラメータを使用して、リスト下部に追加ボタンを配置する
13. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 複数の連絡先情報の管理（電話番号、メールアドレスの複数登録）
- TODOリストの作成（タスクの追加・削除・編集）
- タグリストの編集（記事やブログのタグ管理）
- 商品リストの管理（カート内商品、注文商品の管理）
- フォームの動的な追加・削除（質問項目、選択肢の追加）
- 参加者リストの管理（イベント参加者、プロジェクトメンバー）
- 画像リストの管理（複数画像のアップロード、編集）
- スケジュールリストの管理（複数の予定管理）
- 住所リストの管理（複数配送先の登録）
- SNSアカウントリストの管理（複数アカウント連携）
""";
  }
}
