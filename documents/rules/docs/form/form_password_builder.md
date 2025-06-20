# `FormPasswordBuilder`の利用方法

`FormPasswordBuilder`は下記のように利用する。

## 概要

パスワード入力時の内容を隠すかどうかを切り替えることができるフォームビルダー。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでパスワードの状態管理を行えます。パスワードの表示/非表示切り替え、および表示切替のトグルスイッチの機能を備えています。

## 基本的な利用方法

```dart
FormPasswordBuilder(
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
);
```

## 自由なトグルスイッチの利用方法

```dart
FormPasswordBuilder(
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
  switchBuilder: (context, obscure, onSwitch) {
    return Positioned.fill(
      right: 16,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.zero,
          child: IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onSwitch,
            color: Colors.blue,
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            padding: const EdgeInsets.only(top: 16),
            constraints: const BoxConstraints(),
          ),
        ),
      ),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormPasswordBuilder(
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
  ),
  builder: (context, obscure) {
    return FormTextField(
      form: formController,
      initialValue: formController.value.password,
      obscureText: obscure,
      onSaved: (value) => formController.value.copyWith(password: value),
    );
  },
);
```

## パラメータ

### 必須パラメータ
- `builder`: ビルダー関数。パスワード入力フィールドを生成します。

### オプションパラメータ
- `switchBuilder`: トグルスイッチビルダー関数。パスワード入力フィールドの右側に表示するトグルスイッチを生成します。
- `switchPadding`: トグルスイッチのパディング。トグルスイッチのパディングを設定します。
- `switchAlignment`: トグルスイッチの配置。トグルスイッチの配置を設定します。
- `switchColor`: トグルスイッチの色。トグルスイッチの色を設定します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。

## 注意点

- このビルダーは`FormTextField`などのフォームフィールドと組み合わせて利用します。
- `builder`の`obscure`パラメータでパスワードの表示/非表示を判別します。
- `builder`で設定したフォームフィールドの上にトグルスイッチが表示されます。
- `switchBuilder`でトグルスイッチのビルダーを設定することができます。

## ベストプラクティス

1. `FormTextField`などのフォームフィールドと組み合わせて利用。
2. `builder`の`obscure`パラメータでパスワードの表示/非表示を判別。そのまま`FormTextField`の`obscureText`パラメータに渡す。
3. `switchBuilder`でトグルスイッチのビルダーを設定することができます。

## 利用シーン

- ユーザー登録
- パスワード変更
- セキュリティ設定
- アカウント管理
- 認証画面
