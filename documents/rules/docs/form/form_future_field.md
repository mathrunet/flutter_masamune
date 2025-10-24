# `FormFutureField`の利用方法

`FormFutureField`は下記のように利用する。

## 概要

非同期処理の結果を表示・入力するためのフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで非同期データの管理と表示を行えます。主に`Modal`や別`Page`にフォームフィールドを作成し、その結果を受け取るために利用することが多いです。

## 配置方法

`FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡します。

```dart
final formController = FormController();

// パターン1: Formの配下に配置
Form(
  key: formController.key,
  child: Column(
    children: [
      FormFutureField(
        initialValue: formController.value.icon.value.toString(),
        onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
        onTap: (currentValue) async {
          final result = await router.push(IconSelectPage.query());
          return result;
        },
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final result = await router.push(IconSelectPage.query());
    return result;
  },
);
```

## 基本的な利用方法

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  }
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormFutureField(
  initialValue: "https://example.com/icon.png",
  onChanged: (value) {
    print(value);
  },
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  }
);
```

## 表示テキストを変更する場合

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  parseToString: (value) => value.label,
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  }
);
```

## 表示を自由に設定する場合

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  },
  builder: (context, ref) {
    return GestureDetector(
      onTap: () {
        ref.onTap();
      },
      child: CircleAvatar(
        backgroundImage: Asset.image(ref.value),
      ),
    );
  },
);
```

## カスタムデザインの適用

```dart
FormFutureField<UserData>(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  parseToString: (value) => value.label,
  onTap: (currentValue) async {
    final selectValue = await router.push(
      IconSelectPage.query(selected: currentValue),
    );
    return selectValue;
  },
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
```

## モーダルで選択する

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.category,
  onSaved: (value) => formController.value.copyWith(category: value),
  parseToString: (value) => value?.name ?? "",
  onTap: (currentValue) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CategorySelectModal(selected: currentValue);
      },
    );
    return result;
  },
);
```

## 読み取り専用の利用方法

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  readOnly: true,  // onTapが実行されない
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final result = await router.push(IconSelectPage.query());
    return result;
  },
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  prefix: FormAffixStyle(
    icon: Icon(Icons.image),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.clear),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final result = await router.push(IconSelectPage.query());
    return result;
  },
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  showDropdownIcon: true,
  dropdownIcon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  onTap: (currentValue) async {
    final result = await router.push(IconSelectPage.query());
    return result;
  },
);
```

## バリデーション付きの利用方法

```dart
FormFutureField(
  form: formController,
  initialValue: formController.value.icon.value.toString(),
  onSaved: (value) => formController.value.copyWith(icon: ModelImageUri.parse(value)),
  validator: (value) {
    if (value == null) {
      return "アイコンを選択してください";
    }
    return null;
  },
  onTap: (currentValue) async {
    final result = await router.push(IconSelectPage.query());
    return result;
  },
);
```

## パラメータ

### 必須パラメータ
- `onTap`: フォームをタップして非同期の結果を取得するための処理を記述するコールバック。現在の値を受け取り、新しい値（または`null`）を返します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。取得された値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。値が変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。取得された値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、フィールドが無効化され`onTap`が実行されません。デフォルトは`true`です。
- `readOnly`: 読み取り専用。`true`の場合、`onTap`が実行されません。デフォルトは`false`です。
- `initialValue`: 初期値。フォーム表示時の初期値を設定します（型`T`）。
- `controller`: テキストコントローラー。テキスト表示のコントロールを外部から制御します（`builder`未使用時のみ有効）。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も選択されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。テキストフィールドの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。テキストフィールドの右側に表示する追加要素（`FormAffixStyle`）。
- `parseToString`: フォーム内で保持している値（型`T`）をテキストフィールド内で表示する文字列に変換するための関数。未指定の場合は`toString()`が使用されます。`builder`と同時に指定はできません。
- `builder`: 自由にカスタマイズしたウィジェットを表示するためのビルダー。`FormFutureFieldRef`を受け取り、カスタムUIを返します。`parseToString`と同時に指定はできません。
- `emptyErrorText`: 空のエラーメッセージ。値が取得されていない場合に表示するエラーメッセージを設定します。
- `obscureText`: 入力内容を隠すかどうか。`true`の場合、表示される値が隠されます（パスワード表示用）。デフォルトは`false`です。
- `showDropdownIcon`: ドロップダウンアイコンの表示。`true`の場合、ドロップダウンアイコンが表示されます（`builder`未使用時のみ有効）。デフォルトは`true`です。
- `dropdownIcon`: カスタムドロップダウンアイコン。`showDropdownIcon`が`true`の場合のみ有効です。

### `FormFutureFieldRef`で利用可能なプロパティとメソッド
- `value`: 現在のフォームの値を取得します（型`T?`）。
- `settings`: `FormFutureField`のウィジェット設定を取得します。
- `onTap()`: `FormFutureField.onTap`を実行し、フォームの値を更新して再描画します。
- `update(T? value)`: フォームの値を直接更新して再描画します。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `onTap`パラメータでは、別ページへの遷移、モーダルの表示、API呼び出しなどの非同期処理を記述します。
- `onTap`から`null`を返すと、値は更新されません。
- `parseToString`パラメータを使用することで、フォーム内で保持している値（型`T`）をテキストフィールド内で表示する文字列に変換できます。
- `builder`パラメータを使用すると、完全にカスタマイズしたUIを表示できます。`builder`内で`ref.onTap()`を呼び出して非同期処理を開始します。
- `parseToString`と`builder`は同時に利用することはできません。どちらか一方のみを指定してください。
- `builder`を使用する場合、`showDropdownIcon`は無効です。
- `readOnly`が`true`または`enabled`が`false`の場合、`onTap`は実行されません。
- `emptyErrorText`を設定すると、値が取得されていない場合にバリデーションエラーとして表示されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 必須チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `onTap`内で`router.push()`や`showModalBottomSheet()`を利用して非同期結果を取得する
8. シンプルなテキスト表示の場合は`parseToString`を使用し、複雑なUIが必要な場合は`builder`を使用する
9. `parseToString`と`builder`は同時に指定しない
10. `builder`内では`ref.value`で現在の値を取得し、`ref.onTap()`で選択処理を開始する
11. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）

## 利用シーン

- 別ページでのフォームフィールドの結果を受け取る（アイコン選択、カテゴリー選択など）
- モーダルでの選択結果を受け取る（ボトムシート、ダイアログ）
- 確認が必要な処理の結果を受け取る（削除確認、アップロード確認など）
- WebViewなどの外部の結果を受け取る（OAuth認証、外部サービス連携）
- APIレスポンスを元にフォームの値を更新する
- 画像・ファイル選択結果を受け取る（ギャラリー、カメラ、ファイルピッカー）
- 複雑な入力フォームを別画面で実施して結果を受け取る
- 住所検索結果を受け取る（郵便番号検索、住所検索）
- ユーザー検索結果を受け取る（ユーザー選択、メンバー選択）
- カスタムピッカーの結果を受け取る（カレンダー、地図、カラーピッカーなど）
