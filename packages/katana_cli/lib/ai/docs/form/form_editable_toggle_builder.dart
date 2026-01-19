// Project imports:
import "package:katana_cli/ai/docs/form_usage.dart";

/// Contents of form_editable_toggle_builder.md.
///
/// form_editable_toggle_builder.mdの中身。
class KatanaFormEditableToggleBuilderMdCliAiCode extends FormUsageCliAiCode {
  /// Contents of form_editable_toggle_builder.md.
  ///
  /// form_editable_toggle_builder.mdの中身。
  const KatanaFormEditableToggleBuilderMdCliAiCode();

  @override
  String get name => "`FormEditableToggleBuilder`の利用方法";

  @override
  String get description =>
      "編集モードと表示モードを切り替えられるフォームビルダーである`FormEditableToggleBuilder`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/form";

  @override
  String get excerpt =>
      "編集モードと表示モードを切り替えられるフォームビルダー。`FormController`の状態に応じて、編集可能なフォームと読み取り専用の表示を切り替えることができます。編集・保存・キャンセルなどの機能を備えています。";

  @override
  String body(String baseName, String className) {
    return """
`FormEditableToggleBuilder`は下記のように利用する。

## 概要

$excerpt

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormEditableToggleBuilder`は他のフォームウィジェットを囲んで使用し、編集モードと表示モードを切り替えます。

```dart
final formController = FormController();

FormEditableToggleBuilder(
  builder: (context, ref) {
    return Column(
      children: [
        // ref.editableで編集状態を判定
        if (ref.editable)
          FormTextField(
            form: formController,
            initialValue: formController.value.name,
            onSaved: (value) => formController.value.copyWith(name: value),
          )
        else
          Text(formController.value.name),
        FormButton(
          ref.editable ? "保存" : "編集",
          onPressed: () {
            if (ref.editable) {
              formController.validate();
            }
            // 編集状態を切り替え
            ref.toggle();
          },
        ),
      ],
    );
  },
);
```

## 基本的な利用方法

```dart
FormEditableToggleBuilder(
  builder: (context, ref) {
    return Column(
      children: [
        if (ref.editable)
          FormTextField(
            form: form,
            initialValue: form.value.text,
            onSaved: (value) => form.value.copyWith(text: value),
          )
        else
          Text(form.value.text),
        FormButton(
          form: form,
          label: ref.editable ? "保存" : "編集",
          onPressed: () {
            if (ref.editable) {
              final value = form.validate();
              if (value == null) {
                return;
              }
              final document = appRef.model(AnyModel.collection()).create();
              await document.save(value);
              // 表示モードへ切り替え
              ref.toggle();
            } else {
              // 編集モードへ切り替え
              ref.toggle();
            }
          },
        ),
      ],
    );
  },
);
```

## キャンセルボタン付きの利用方法

```dart
FormEditableToggleBuilder(
  builder: (context, ref) {
    return Column(
      children: [
        if (ref.editable)
          FormTextField(
            form: form,
            initialValue: form.value.text,
            onSaved: (value) => form.value.copyWith(text: value),
          )
        else
          Text(form.value.text),
        Row(
          children: [
            if (ref.editable) ...[
              FormButton(
                "保存",
                onPressed: () async {
                  final value = form.validate();
                  if (value == null) {
                    return;
                  }
                  await document.save(value);
                  ref.toggle();
                },
              ),
              SizedBox(width: 16),
              FormButton(
                "キャンセル",
                onPressed: () {
                  form.reset();  // フォームをリセット
                  ref.toggle();
                },
              ),
            ] else
              FormButton(
                "編集",
                onPressed: () => ref.toggle(),
              ),
          ],
        ),
      ],
    );
  },
);
```

## 初期状態を編集モードにする

```dart
FormEditableToggleBuilder(
  editableOnInit: true,  // 初期表示時に編集モード
  builder: (context, ref) {
    return Column(
      children: [
        if (ref.editable)
          FormTextField(
            form: form,
            initialValue: form.value.text,
            onSaved: (value) => form.value.copyWith(text: value),
          )
        else
          Text(form.value.text),
        FormButton(
          ref.editable ? "保存" : "編集",
          onPressed: () => ref.toggle(),
        ),
      ],
    );
  },
);
```

## 複数フィールドでの利用方法

```dart
FormEditableToggleBuilder(
  builder: (context, ref) {
    return Column(
      children: [
        if (ref.editable) ...[
          FormTextField(
            form: form,
            labelText: "名前",
            initialValue: form.value.name,
            onSaved: (value) => form.value.copyWith(name: value),
          ),
          FormTextField(
            form: form,
            labelText: "メールアドレス",
            initialValue: form.value.email,
            onSaved: (value) => form.value.copyWith(email: value),
          ),
          FormTextField(
            form: form,
            labelText: "電話番号",
            initialValue: form.value.phone,
            onSaved: (value) => form.value.copyWith(phone: value),
          ),
        ] else ...[
          Text("名前: \${form.value.name}"),
          Text("メールアドレス: \${form.value.email}"),
          Text("電話番号: \${form.value.phone}"),
        ],
        FormButton(
          ref.editable ? "保存" : "編集",
          onPressed: () => ref.toggle(),
        ),
      ],
    );
  },
);
```

## スタイルを適用した利用方法

```dart
FormEditableToggleBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(24.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  builder: (context, ref) {
    return Column(
      children: [
        if (ref.editable)
          FormTextField(
            form: form,
            initialValue: form.value.text,
            onSaved: (value) => form.value.copyWith(text: value),
          )
        else
          Text(form.value.text),
        FormButton(
          ref.editable ? "保存" : "編集",
          onPressed: () => ref.toggle(),
        ),
      ],
    );
  },
);
```

## トグルイベントを監視する

```dart
FormEditableToggleBuilder(
  onToggle: (editable) {
    print("編集モード: \$editable");
    if (editable) {
      // 編集モードに入った時の処理
    } else {
      // 表示モードに入った時の処理
    }
  },
  builder: (context, ref) {
    return Column(
      children: [
        if (ref.editable)
          FormTextField(
            form: form,
            initialValue: form.value.text,
            onSaved: (value) => form.value.copyWith(text: value),
          )
        else
          Text(form.value.text),
        FormButton(
          ref.editable ? "保存" : "編集",
          onPressed: () => ref.toggle(),
        ),
      ],
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。編集状態（`FormEditableToggleBuilderRef`）に応じたウィジェットを生成します。

### オプションパラメータ
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。設定すると`FormContainer`でラップされます。
- `onToggle`: 編集モードの切り替え時のコールバック。編集状態（`bool`）が渡されます。
- `editableOnInit`: 初期編集状態。`true`の場合は初期表示時に編集可能になります。デフォルトは`false`です。

### `FormEditableToggleBuilderRef`で利用可能なプロパティとメソッド
- `editable`: 現在の編集状態を取得します（`bool`型）。`true`の場合は編集モード、`false`の場合は表示モードです。
- `toggle()`: 編集状態を切り替えます。編集モードと表示モードをトグルします。

## 注意点

- `builder`内の編集状態は`ref.editable`で取得できます。
- `ref.toggle()`で編集状態を切り替えます。
- `ref.editable`に応じて条件分岐し、編集用のフォームと表示用のウィジェットを切り替えます。
- `style`を設定すると、`FormContainer`で自動的にラップされます。
- `onToggle`は`ref.toggle()`が呼ばれた後に実行されます。
- `editableOnInit`を`true`にすると、初期表示時から編集モードになります（新規作成時などに有用）。
- 編集モードから表示モードに切り替える前に、必要に応じて`FormController.validate()`でバリデーションを行うことを推奨します。
- キャンセル時には`FormController.reset()`を呼び出して、変更を元に戻すことができます。

## ベストプラクティス

1. `builder`内で`ref.editable`を使用して編集状態を判定する
2. `ref.editable`に応じて編集用フォームと表示用ウィジェットを条件分岐で切り替える
3. 保存前に`FormController.validate()`でバリデーションを実行する
4. キャンセル時には`FormController.reset()`でフォームをリセットする
5. `onToggle`を使用して、編集モードの切り替え時に追加処理を実行する（例: ログ記録、状態管理）
6. 新規作成画面では`editableOnInit: true`を設定して、初期状態を編集モードにする
7. `style`を使用して、編集エリアの視覚的な境界を明確にする
8. 編集ボタンと保存ボタンの区別を明確にする（アイコンやラベルを工夫）
9. 複数フィールドを扱う場合は、すべてのフィールドを同じ編集状態で管理する
10. 編集中の変更を破棄する場合は、必ずキャンセルボタンを提供する

## 利用シーン

- プロフィール情報の編集（ユーザー情報、アカウント設定）
- 設定項目の編集（アプリ設定、環境設定）
- 商品情報の編集（商品詳細、在庫情報）
- コメントの編集（投稿コメント、レビュー）
- メモの編集（ノート、メモ帳）
- 住所情報の編集（配送先住所、請求先住所）
- タスク詳細の編集（ToDoの詳細情報）
- イベント情報の編集（イベント詳細、スケジュール）
- 投稿の編集（ブログ記事、SNS投稿）
- 問い合わせ内容の編集
""";
  }
}
