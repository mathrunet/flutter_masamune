// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

/// Contents of form_list_builder.mdc.
///
/// form_list_builder.mdcの中身。
class KatanaFormListBuilderMdcCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_list_builder.mdc.
  ///
  /// form_list_builder.mdcの中身。
  const KatanaFormListBuilderMdcCliAiCode();

  @override
  String get name => "`FormListBuilder`の利用方法";

  @override
  String get description =>
      "リスト形式のデータを動的に追加・削除・編集できるフォームビルダーである`FormListBuilder`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "リスト形式のデータを動的に追加・削除・編集できるフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでリストの状態管理を行えます。ドラッグ&ドロップによる並び替え、バリデーション、カスタムデザインなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormListBuilder`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
FormListBuilder<String>(
    form: formController,
    initialValue: formController.value.items,
    builder: (context, form, index, item) {
      return FormTextField(
        form: form,
        initialValue: item,
        onSaved: (value) => form.value.items[index] = value ?? "",
      );
    },
    onSaved: (value) => formController.value.copyWith(items: value),
);
```

## 追加・削除ボタン付きの利用方法

```dart
FormListBuilder<TodoItem>(
    form: formController,
    initialValue: formController.value.todos,
    addButtonBuilder: (context, form) {
      return ElevatedButton(
        onPressed: () => form.add(TodoItem()),
        child: const Text("タスクを追加"),
      );
    },
    builder: (context, form, index, item) {
      return Row(
        children: [
          Expanded(
            child: FormTextField(
              form: form,
              initialValue: item.title,
              onSaved: (value) => form.value.todos[index] = item.copyWith(title: value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => form.removeAt(index),
          ),
        ],
      );
    },
    onSaved: (value) => formController.value.copyWith(todos: value),
);
```

## ドラッグ&ドロップ並び替えの実装

```dart
FormListBuilder<TaskItem>(
    form: formController,
    initialValue: formController.value.tasks,
    reorderable: true,
    builder: (context, form, index, item) {
      return ListTile(
        leading: const Icon(Icons.drag_handle),
        title: FormTextField(
          form: form,
          initialValue: item.title,
          onSaved: (value) => form.value.tasks[index] = item.copyWith(title: value),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => form.removeAt(index),
        ),
      );
    },
    onSaved: (value) => formController.value.copyWith(tasks: value),
);
```

## バリデーション付きの利用方法

```dart
FormListBuilder<ContactInfo>(
    form: formController,
    initialValue: formController.value.contacts,
    validator: (value) {
      if (value.isEmpty) {
        return "少なくとも1つの連絡先を追加してください";
      }
      return null;
    },
    builder: (context, form, index, item) {
      return Column(
        children: [
          FormTextField(
            form: form,
            initialValue: item.name,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "名前は必須です";
              }
              return null;
            },
            onSaved: (value) => form.value.contacts[index] = item.copyWith(name: value),
          ),
          FormTextField(
            form: form,
            initialValue: item.email,
            validator: (value) {
              if (!value!.contains("@")) {
                return "有効なメールアドレスを入力してください";
              }
              return null;
            },
            onSaved: (value) => form.value.contacts[index] = item.copyWith(email: value),
          ),
        ],
      );
    },
    onSaved: (value) => formController.value.copyWith(contacts: value),
);
```

## カスタムデザインの適用

```dart
FormListBuilder<NoteItem>(
    form: formController,
    initialValue: formController.value.notes,
    style: const FormStyle(
      padding: EdgeInsets.all(16.0),
      backgroundColor: Colors.grey[100],
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      listStyle: ListStyle(
        itemSpacing: 8.0,
        addButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        deleteButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.red),
        ),
      ),
    ),
    builder: (context, form, index, item) {
      return FormTextField(
        form: form,
        initialValue: item.content,
        onSaved: (value) => form.value.notes[index] = item.copyWith(content: value),
      );
    },
    onSaved: (value) => formController.value.copyWith(notes: value),
);
```

## パラメータ

### 必須パラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。
- `builder`: ビルダー関数。各アイテムのウィジェットを生成します。
- `onSaved`: 保存時のコールバック。リストの値を保存します。

### オプションパラメータ
- `initialValue`: 初期値。初期表示するリストを設定します。
- `addButtonBuilder`: 追加ボタンビルダー。カスタムの追加ボタンを生成します。
- `reorderable`: 並び替え可否。ドラッグ&ドロップによる並び替えを有効にします。
- `validator`: バリデーション関数。リスト全体の検証ルールを定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `enabled`: 有効/無効。`false`の場合、リストの編集が無効化されます。

## 注意点

- `FormController`と組み合わせて使用することで、リストの状態を管理できます。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- リストの操作は`form.add()`, `form.removeAt()`, `form.move()`などのメソッドで行います。
- バリデーションはリスト全体と各アイテムの両方に設定できます。
- 並び替えは`reorderable`パラメータを`true`に設定することで有効化できます。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. 適切なバリデーションを設定して入力値を検証する
3. 使いやすい追加・削除UIを提供する
4. 必要に応じて並び替え機能を有効にする
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する

## 利用シーン

- 複数の連絡先情報の管理
- TODOリストの作成
- タグリストの編集
- 商品リストの管理
- フォームの動的な追加・削除
""";
  }
}
