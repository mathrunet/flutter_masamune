# `FormDurationField`の利用方法

`FormDurationField`は下記のように利用する。

## 概要

時間の長さ（Duration）を入力するためのフォームフィールド。時間、分、秒などの単位で時間の長さを設定でき、範囲制限やバリデーションなどの機能を備えています。`FormStyle`で共通したデザインを適用可能で、`FormController`を利用することで入力値を管理できます。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormDurationField(
        initialValue: Duration(milliseconds: formController.value.duration),
        onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## 基本的な利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormDurationField(
  initialValue: Duration(minutes: 30),
  onChanged: (value) {
    print(value);
  },
);
```

## 範囲制限の利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
  picker: const FormDurationFieldPicker(
    begin: Duration(minutes: 1),
    end: Duration(minutes: 30),
  ),
);
```

## バリデーション付きの利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
  validator: (value) {
    if (value == null) {
      return "時間を入力してください";
    }
    if (value.inMinutes < 30) {
      return "30分以上の時間を設定してください";
    }
    if (value.inHours > 8) {
      return "8時間以内の時間を設定してください";
    }
    return null;
  },
);
```

## カスタムデザインの適用

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    backgroundColor: Colors.grey[200],
  ),
);
```

## カスタムフォーマットの利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  format: "HH時間mm分ss秒",  // カスタムフォーマット
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## 読み取り専用の利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  readOnly: true,  // ピッカーが開かない
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## カスタムピッカーの利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  picker: const FormDurationFieldPicker(
    begin: Duration(minutes: 5),
    end: Duration(hours: 2),
    hourSuffix: "時間",
    minuteSuffix: "分",
    secondSuffix: "秒",
    confirmText: "決定",
    cancelText: "キャンセル",
  ),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  prefix: FormAffixStyle(
    icon: Icon(Icons.timer),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormDurationField(
  form: formController,
  initialValue: Duration(milliseconds: formController.value.duration),
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(duration: value.inMilliseconds),
);
```

## パラメータ

### 必須パラメータ
なし

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された時間長の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。時間長が変更された時の処理を定義します。
- `onSubmitted`: 送信時のコールバック。Enterキーなどが押された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された時間長の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、時間長フィールドが無効化されます。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、ピッカーが開かなくなります。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期時間長を設定します（`Duration`型）。
- `controller`: テキストコントローラー。テキスト入力のコントロールを外部から制御します。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も入力されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `picker`: 時間長選択ピッカー。選択可能な範囲や接尾辞を設定できます。デフォルトは`FormDurationFieldPicker()`です。
- `format`: 時間長のフォーマット。表示する時間長のフォーマットを指定します。デフォルトは`"HH:mm:ss"`です。
  - 利用可能なフォーマット記号:
    - `d`: 日数を表示
    - `H`: 時間を表示
    - `m`: 分を表示
    - `s`: 秒を表示
    - `HH`: 時間を2桁で表示
    - `mm`: 分を2桁で表示
    - `ss`: 秒を2桁で表示
    - `S`: ミリ秒を表示
    - `M`: マイクロ秒を表示
- `emptyErrorText`: 空のエラーメッセージ。時間長が選択されていない場合に表示するエラーメッセージを設定します。
- `keyboardType`: キーボードのタイプ。テキスト入力のキーボードのタイプを設定します。デフォルトは`TextInputType.text`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormDurationFieldPicker`で設定可能なプロパティ
- `begin`: 選択可能な最短時間長。未指定の場合は0秒から選択可能です。
- `end`: 選択可能な最長時間長。未指定の場合は23時間59分59秒まで選択可能です。
- `defaultDuration`: 選択されていない場合のデフォルト値。
- `daySuffix`: 日の接尾辞（例: "日"）。デフォルトは空文字です。
- `hourSuffix`: 時間の接尾辞（例: "時間"）。デフォルトは空文字です。
- `minuteSuffix`: 分の接尾辞（例: "分"）。デフォルトは空文字です。
- `secondSuffix`: 秒の接尾辞（例: "秒"）。デフォルトは空文字です。
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
- 時間長は`Duration`型で取り扱いますが、`Model`ではミリ秒（`inMilliseconds`）や秒（`inSeconds`）で取り扱うため変換に注意が必要です。
- `format`は時間長の表示フォーマットを指定します。デフォルトは`"HH:mm:ss"`（時:分:秒）です。
- `readOnly`が`true`の場合、フィールドをタップしてもピッカーは開きません。
- `emptyErrorText`を設定すると、時間長が選択されていない場合にバリデーションエラーとして表示されます。
- `showDropdownIcon`を`false`にすると、ドロップダウンアイコンが非表示になります。
- `begin`と`end`で選択可能な時間長の範囲を制限できます。未指定の場合は0秒〜23時間59分59秒の範囲になります。
- `begin`は`end`より短い時間長である必要があります。
- ピッカーは`begin`と`end`の範囲に応じて、日、時間、分、秒の選択肢を動的に表示します。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 最小時間チェック、最大時間チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. 時間長は`Duration`型で取り扱うが、`Model`では`inMilliseconds`や`inSeconds`を使ってミリ秒や秒に変換して保存する
8. `begin`と`end`を設定して、選択可能な時間長の範囲を適切に制限する
9. `format`パラメータを使用して、用途に合わせた時間長表示フォーマットを設定する（例: "HH:mm"、"mm:ss"など）
10. `picker`の接尾辞（`hourSuffix`、`minuteSuffix`、`secondSuffix`）を使用して、地域に合わせた表示を行う
11. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- タスクの所要時間設定（作業見積もり時間）
- タイマーの時間設定（ポモドーロタイマー、料理タイマーなど）
- 作業時間の入力（日報、タイムトラッキング）
- 予約時間の長さ設定（サービス提供時間、会議時間など）
- 制限時間の設定（試験時間、ゲームの制限時間など）
- 休憩時間の設定（勤務管理）
- 動画・音声の長さ設定（メディアコンテンツの再生時間）
- 配達予定時間の設定（配送所要時間）
- リマインダーのスヌーズ時間設定
