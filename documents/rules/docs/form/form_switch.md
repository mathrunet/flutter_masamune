# `FormSwitch`の利用方法

`FormSwitch`は下記のように利用する。

## 概要

`Switch`のMasamuneフレームワーク版。トグルスイッチを表示し切り替えるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することでスイッチの値を管理可能。ラベル付きスイッチ、カスタムデザインなどの機能を備えています。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormSwitch(
        initialValue: formController.value.enabled,
        onSaved: (value) => formController.value.copyWith(enabled: value),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## 基本的な利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## ラベル付きの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  labelText: "通知を有効にする",
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## バリデーション付きの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  validator: (value) {
    if (value != true) {
      return "利用規約への同意が必要です";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## カスタムデザインの適用

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.grey[200],
    activeColor: Colors.blue,  // ONの時のスイッチの色
  ),
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormSwitch(
  initialValue: true,
  onChanged: (value) {
    print("スイッチ: $value");
  },
);
```

## 読み取り専用の利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  readOnly: true,  // スイッチの切り替えができない
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## カスタムラベルウィジェットの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  labelWidget: Row(
    children: [
      Icon(Icons.notifications, size: 20),
      SizedBox(width: 8),
      Text("プッシュ通知を受け取る"),
    ],
  ),
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  labelText: "通知を有効にする",
  prefix: FormAffixStyle(
    icon: Icon(Icons.info),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    label: "推奨",
    iconColor: Colors.green,
  ),
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## 自動フォーカスの利用方法

```dart
FormSwitch(
  form: formController,
  initialValue: formController.value.enabled,
  autofocus: true,  // 画面表示時に自動でフォーカス
  onSaved: (value) => formController.value.copyWith(enabled: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。スイッチの値（`bool`）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。スイッチの値が変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。スイッチの値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、スイッチが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、有効化の表示になりますがスイッチを切り替えられなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期スイッチ状態を設定します。デフォルトは`false`です。
- `focusNode`: フォーカスノード。スイッチのフォーカスを制御します。
- `autofocus`: 自動フォーカス。`true`の場合、画面表示時に自動的にフォーカスされます。デフォルトは`false`です。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。スイッチの横に表示するテキストを設定します。`labelText`と`labelWidget`を両方設定することはできません。
- `labelWidget`: ラベルウィジェット。スイッチの横に表示するウィジェットを設定します。`labelText`と`labelWidget`を両方設定することはできません。
- `prefix`: プレフィックス。スイッチの左側に表示する追加要素（`FormAffixStyle`）。`labelText`または`labelWidget`が設定されている場合のみ有効です。
- `suffix`: サフィックス。スイッチの右側に表示する追加要素（`FormAffixStyle`）。`labelText`または`labelWidget`が設定されている場合のみ有効です。

### `FormStyle`で設定可能なプロパティ（FormSwitch特有）
- `activeColor`: ONの時のスイッチのthumb色
- `disabledColor`: 無効化時のスイッチのthumb色

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`もしくは`labelWidget`パラメータを使用して設定できます。
- `labelText`と`labelWidget`は同時に設定できません。どちらか一方を選択してください。
- `prefix`と`suffix`は、`labelText`または`labelWidget`が設定されている場合のみ有効です。
- `readOnly`が`true`の場合、スイッチは有効化の表示になりますが値を変更できません。
- `enabled`が`false`の場合、スイッチは無効化の表示になり値を変更できません。
- スイッチの値は`bool`型で取り扱います。
- ラベルなしの場合は、スイッチのみが表示されます。
- ラベルありの場合は、`InputDecorator`でラップされ、境界線や背景色が適用されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 利用規約同意の必須チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. ラベルを設定する場合は、シンプルなテキストなら`labelText`、複雑なレイアウトなら`labelWidget`を使用
8. `labelText`と`labelWidget`は同時に設定しない
9. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
10. 読み取り専用の表示が必要な場合は`readOnly`を使用し、完全に無効化する場合は`enabled`を`false`にする
11. `prefix`や`suffix`を使用して、スイッチに追加の情報やアイコンを表示できる

## 利用シーン

- 設定画面でのON/OFF切り替え（各種設定項目）
- 通知設定の有効/無効（プッシュ通知、メール通知）
- プライバシー設定の切り替え（公開/非公開、位置情報）
- 機能の有効/無効化（自動保存、自動同期）
- モード切り替え（ダークモード、省電力モード）
- 表示設定の切り替え（詳細表示、コンパクト表示）
- フィルター設定（表示/非表示フィルター）
- アクセシビリティ設定（字幕、音声ガイド）
- セキュリティ設定（二段階認証、生体認証）
- 自動更新設定（アプリ自動更新、コンテンツ自動更新）
