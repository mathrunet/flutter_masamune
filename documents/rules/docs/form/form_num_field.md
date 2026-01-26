# `FormNumModalField`の利用方法

`FormNumModalField`は下記のように利用する。

## 概要

モーダルで数値を選択するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで数値の値を管理可能。最小値・最大値の制限、小数点以下の桁数制限、通貨表示などの機能を備えています。

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormNumModalField(
        initialValue: formController.value.quantity,
        onSaved: (value) => formController.value.copyWith(quantity: value),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormNumModalField(
  form: formController,
  initialValue: formController.value.quantity,
  onSaved: (value) => formController.value.copyWith(quantity: value),
);
```

## 基本的な利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## 最小値・最大値制限、間隔付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
  picker: FormNumModalFieldPicker(
    begin: 5,
    end: 50,
    interval: 10,
  ),
);
```

## 小数点以下の桁数制限付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
  picker: FormNumModalFieldPicker(
    begin: 0.0,
    end: 0.1,
    interval: 0.01,
    fractionDigits: 2,
  ),
);
```

## 通貨表示の利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  onSaved: (value) => formController.value.copyWith(number: value),
  picker: FormNumModalFieldPicker(
    begin: 0,
    end: 10000,
    interval: 100,
    suffix: "円",
  ),
);
```

## バリデーション付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  validator: (value) {
    if (value == null) {
      return "数値を入力してください";
    }
    if (value < 0) {
      return "正の数を入力してください";
    }
    if (value % 2 != 0) {
      return "偶数を入力してください";
    }
    return null;
  },
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## カスタムデザインの適用

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## 読み取り専用の利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  readOnly: true,  // ピッカーが開かない
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## カスタムピッカーの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  picker: const FormNumModalFieldPicker(
    begin: 0,
    end: 100,
    interval: 5,
    suffix: "個",
    backgroundColor: Colors.white,
    color: Colors.black,
    confirmText: "決定",
    cancelText: "キャンセル",
  ),
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  prefix: FormAffixStyle(
    icon: Icon(Icons.numbers),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    label: "個",
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormNumModalField(
  form: formController,
  initialValue: formController.value.number,
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(number: value),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された数値（`num`型）の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。数値が変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された数値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、数値フィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、ピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期数値を設定します（`num`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `picker`: 数値選択ピッカー（`FormNumModalFieldPicker`）。数値の範囲、間隔、小数点桁数などを設定できます。デフォルトは`FormNumModalFieldPicker()`です。
- `emptyErrorText`: 空のエラーメッセージ。数値が選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.number`です。
- `obscureText`: 入力内容を隠すかどうか。`true`の場合、表示される値が隠されます（パスワード表示用）。デフォルトは`false`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormNumModalFieldPicker`で設定可能なプロパティ
- `begin`: 選択可能な最小値。デフォルトは`0`です。
- `end`: 選択可能な最大値。デフォルトは`100`です。`begin`より大きい値である必要があります。
- `interval`: 選択肢の間隔。デフォルトは`1`です。`0`より大きい値である必要があります。
- `defaultValue`: 選択されていない場合のデフォルト値。
- `suffix`: 数値の接尾辞（例: "円"、"個"、"kg"など）。デフォルトは空文字です。
- `fractionDigits`: 小数点以下の表示桁数。デフォルトは`0`です。`0`以上の値である必要があります。
- `backgroundColor`: ピッカーの背景色。
- `color`: ピッカーのテキスト色（前景色）。
- `confirmText`: 確定ボタンのテキスト。デフォルトは`"Confirm"`です。
- `cancelText`: キャンセルボタンのテキスト。デフォルトは`"Cancel"`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- 数値は`num`型（`int`または`double`）で取り扱います。
- `readOnly`が`true`の場合、フィールドをタップしてもピッカーは開きません。
- `emptyErrorText`を設定すると、数値が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- `picker`の`begin`は`end`より小さい値である必要があります。
- `picker`の`interval`は`0`より大きい値である必要があります。
- `picker`の`fractionDigits`は`0`以上の値である必要があります。
- `fractionDigits`を設定することで、小数点以下の桁数を制限できます（例: `0.01`刻みで選択する場合は`fractionDigits: 2`）。
- `suffix`を使用して、数値に単位を付けて表示できます（例: "円"、"個"、"kg"など）。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 範囲チェック、偶数チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `picker`の`begin`、`end`、`interval`を設定して、選択可能な数値の範囲と間隔を適切に制限する
8. 小数を扱う場合は、`interval`に小数を設定し、`fractionDigits`で表示桁数を指定する
9. `suffix`を使用して、数値に単位を付けて表示する（ユーザーフレンドリーな表示）
10. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 金額の入力（価格設定、料金入力）
- 数量の入力（商品数、在庫数、注文数）
- 年齢の入力（プロフィール登録、年齢制限）
- 評価点数の入力（レビュー評価、スコア入力）
- 寸法・サイズの入力（身長、体重、商品サイズ）
- パーセンテージの入力（割引率、進捗率）
- 金利・利率の入力（ローン計算、投資計算）
- 距離の入力（配送距離、移動距離）
- 温度の入力（設定温度、測定温度）
- 時間の入力（作業時間、待機時間）
