// Project imports:
import 'package:katana_cli/ai/docs/form_usage.dart';

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
- `builder`: ビルダー関数。各アイテムのウィジェットを生成します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。`builder`の中で定義された`Form`の`onSaved`メソッドよりも必ず前に実行されるのでリストの初期化などが行えます。
- `onChanged`: 変更時のコールバック。選択された値の変更時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、チェックボックスが無効化されます。
- `initialValue`: 初期値。フォーム表示時の初期チェック状態を設定します。

- `top`: リストの上部に表示するウィジェットを設定します。
- `bottom`: リストの下部に表示するウィジェットを設定します。
- `readOnly`: リストの読み取り専用化を設定します。

## 注意点

- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- `builder`内で`Form`を利用する場合、各要素に`index`を含めた`ValueKey`を設定して、各要素の内容を維持してください。また`FormListBuilder`の`onSaved`メソッドでリストを初期化した後、各要素の`Form`の`onSaved`メソッド内でその要素を１つずつ追加していくような実装を行ってください。また、各要素の`Form`の`onFocusChanged`や`onSubmitted`内で`ref.update`を行うことで都度更新を行うことができます。
- `builder`内で`Form`を利用する場合、`top`や`bottom`パラメーターで要素の追加を行う場合はフォーカスを外さないとエラーが発生します。また、フォーカスを外してから要素の追加を行う場合は待ち時間を設ける必要があります。
- `builder`内で`Form`を利用する場合、各要素の削除ボタンを押した場合はフォーカスを外さないとエラーが発生します。また、フォーカスを外してから要素の削除を行う場合は待ち時間を設ける必要があります。

## ベストプラクティス

1. フォームの状態管理には必ず`FormController`を使用する
2. `FormController`を使用する場合は`onSaved`メソッドも合わせて定義する。
3. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能。
4. バリデーションは`validator`パラメータを使用して定義する。
5. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
6. `builder`内で`Form`を利用する場合、各要素に`index`を含めた`ValueKey`を設定して、各要素の内容を維持してください。また`FormListBuilder`の`onSaved`メソッドでリストを初期化した後、各要素の`Form`の`onSaved`メソッド内でその要素を１つずつ追加していくような実装を行ってください。また、各要素の`Form`の`onFocusChanged`や`onSubmitted`内で`ref.update`を行うことで都度更新を行うことができます。
7. `builder`内で`Form`を利用する場合、`top`や`bottom`パラメーターで要素の追加を行う場合はフォーカスを外さないとエラーが発生します。また、フォーカスを外してから要素の追加を行う場合は待ち時間を設ける必要があります。
8. `builder`内で`Form`を利用する場合、各要素の削除ボタンを押した場合はフォーカスを外さないとエラーが発生します。また、フォーカスを外してから要素の削除を行う場合は待ち時間を設ける必要があります。

## 利用シーン

- 複数の連絡先情報の管理
- TODOリストの作成
- タグリストの編集
- 商品リストの管理
- フォームの動的な追加・削除
""";
  }
}
