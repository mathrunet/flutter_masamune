# `FormEditableToggleBuilder`の利用方法

`FormEditableToggleBuilder`は下記のように利用する。

## 概要

編集モードと表示モードを切り替えられるフォームビルダー。`FormController`の状態に応じて、編集可能なフォームと読み取り専用の表示を切り替えることができます。編集・保存・キャンセルなどの機能を備えています。

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

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。編集状態に応じたウィジェットを生成します。

### オプションパラメータ
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `onToggle`: 編集モードの切り替え時のコールバック。
- `editableOnInit`: 初期編集状態。`true`の場合は初期表示時に編集可能。

## 注意点

- `builder`内の編集状態は`ref.editable`で取得できます。
- `ref.toggle()`で編集状態を切り替えます。

## ベストプラクティス

1. `builder`内の編集状態は`ref.editable`で取得。
2. `ref.editable`を各種フォームの`enabled`や`readOnly`に設定することで、編集状態に応じたフォームの表示を切り替えることが可能。
3. `ref.toggle()`で編集状態を切り替え。

## 利用シーン

- プロフィール情報の編集
- 設定項目の編集
- 商品情報の編集
- コメントの編集
- メモの編集
