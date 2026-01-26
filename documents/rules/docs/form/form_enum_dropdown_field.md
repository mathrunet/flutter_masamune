# `FormEnumDropdownField`の利用方法

`FormEnumDropdownField`は下記のように利用する。

## 概要

列挙型の値をドロップダウンメニューで選択できるフォームフィールド。`FormStyle`で共通したデザインを適用可能。また`FormController`を利用することで選択状態を管理できます。カスタムラベルやバリデーションなどを備えています。

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
      FormEnumDropdownField(
        initialValue: formController.value.type,
        onSaved: (value) => formController.value.copyWith(type: value),
        picker: FormEnumDropdownFieldPicker(
          values: UserType.values,
        ),
      ),
    ],
  ),
);

// パターン2: formパラメータに直接渡す
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## 基本的な利用方法

```dart
enum UserType {
  admin,
  user,
  guest;

  String get label => switch (this) {
      admin => "管理者",
      user => "一般ユーザー",
      guest => "ゲスト",
    };
}

FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
    labelBuilder: (value) {
      return value.label;
    },
  ),
);
```

## `FormController`を使用しない場合の利用方法

```dart
FormEnumDropdownField(
  initialValue: UserType.admin,
  onChanged: (value) {
    print(value);
  },
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
    labelBuilder: (value) {
      return value.label;
    },
  ),
);
```

## カスタムラベルの利用方法

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
    labelBuilder: (value) {
      return value.label;
    },
  ),
);
```

## バリデーション付きの利用方法

```dart
FormEnumDropdownField<UserType>(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  validator: (value) {
    if (value == null) {
      return "ユーザータイプを選択してください";
    }
    if (value == UserType.guest) {
      return "ゲストユーザーは選択できません";
    }
    return null;
  },
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## カスタムデザインの適用

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  style: const FormStyle(
    padding: EdgeInsets.all(16.0),
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## 選択肢を絞り込む

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    // guestを除外
    values: UserType.values.where((e) => e != UserType.guest).toList(),
    labelBuilder: (value) => value.label,
  ),
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  prefix: FormAffixStyle(
    icon: Icon(Icons.person),
    iconColor: Colors.blue,
  ),
  suffix: FormAffixStyle(
    icon: Icon(Icons.arrow_forward),
    iconColor: Colors.grey,
  ),
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## ドロップダウンアイコンのカスタマイズ

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  icon: Icon(Icons.expand_more),
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## フォームを横幅いっぱいに拡張

```dart
FormEnumDropdownField(
  form: formController,
  initialValue: formController.value.type,
  expanded: true,  // 横幅いっぱいに拡張
  onSaved: (value) => formController.value.copyWith(type: value),
  picker: FormEnumDropdownFieldPicker(
    values: UserType.values,
  ),
);
```

## パラメータ

### 必須パラメータ
- `picker`: ピッカー（`FormEnumDropdownFieldPicker`）。選択肢の列挙型の値とラベルを定義します。

### オプションパラメータ
- `form`: フォームコントローラー。フォームの状態管理を行います。定義する場合は`onSaved`パラメータも定義する必要があります。
- `onSaved`: 保存時のコールバック。選択された列挙型の値の保存処理を定義します。定義する場合は`form`パラメータも定義する必要があります。
- `onChanged`: 変更時のコールバック。列挙型の値が変更された時の処理を定義します。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。
- `validator`: バリデーション関数。選択された列挙型の値の検証ルールを定義します。
- `enabled`: 入力可否。`false`の場合、ドロップダウンが無効化されます。デフォルトは`true`です。
- `initialValue`: 初期値。フォーム表示時の初期選択値を設定します（列挙型の値）。
- `focusNode`: フォーカスノード。フォームのフォーカスを制御します。
- `keepAlive`: リストに配置された場合、スクロール時に破棄されないようにするかどうか。`true`の場合、破棄されず保持され続けます。デフォルトは`true`です。
- `labelText`: ラベルテキスト。テキストフィールド外に表示するラベルを設定します。
- `hintText`: 何も選択されていないときに表示するヒントテキストを設定します。
- `prefix`: プレフィックス。ドロップダウンの左側に表示する追加要素（`FormAffixStyle`）。
- `suffix`: サフィックス。ドロップダウンの右側に表示する追加要素（`FormAffixStyle`）。
- `emptyErrorText`: 空のエラーメッセージ。値が選択されていない場合に表示するエラーメッセージを設定します。
- `icon`: ドロップダウンの右側に表示されるアイコン。未指定の場合はデフォルトのドロップダウンアイコンが使用されます。
- `expanded`: フォームを横幅いっぱいに拡張するかどうか。`true`の場合、親ウィジェットの幅いっぱいに拡張されます。デフォルトは`false`です。

### `FormEnumDropdownFieldPicker`で設定可能なプロパティ
- `values`: 選択肢となる列挙型の値のリスト（必須）。通常は`YourEnum.values`を渡します。
- `labelBuilder`: 各列挙型の値を表示用のラベル文字列に変換するビルダー関数。未指定の場合は`enum.name`が使用されます。

### `FormStyle`で設定可能なプロパティ（ドロップダウン特有）
- `activeBackgroundColor`: 選択時のドロップダウンの背景色
- `activeColor`: 選択時のテキスト色
- `activeTextStyle`: 選択時のテキストスタイル
- `elevation`: ドロップダウンメニューの影の高さ。デフォルトは`8`です。
- `alignedDropdown`: ドロップダウンメニューを左右に揃えるかどうか。デフォルトは`true`です。

## 注意点

- `FormController`を使用する場合は、`FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡す必要があります。
- `FormController`と組み合わせて使用することで、フォームの状態管理を行えます。
- `FormController`を使用する場合は`onSaved`メソッドも合わせて定義してください。
- `form`と`onSaved`はセットで使用する必要があります。どちらか一方だけを定義するとエラーになります。
- `FormStyle`を使用することで、共通のデザインを適用できます。
- ラベルテキストは`labelText`パラメータを使用して設定できます。
- `picker`の`values`には列挙型の`values`をそのまま渡すと、列挙型のすべての値が選択肢に追加されます。
- `values.where()`などで絞り込むことで、特定の値のみを選択肢として表示できます。
- `labelBuilder`を指定しない場合、列挙型の`name`プロパティ（例: `UserType.admin`の場合は`"admin"`）が表示されます。
- ユーザーフレンドリーな表示にするため、`labelBuilder`で適切なラベルを返すことを推奨します。
- `emptyErrorText`を設定すると、値が選択されていない場合にバリデーションエラーとして表示されます。
- `expanded`を`true`にすると、ドロップダウンが親ウィジェットの幅いっぱいに拡張されます。
- リスト内で使用する場合、`keepAlive`を`true`にすることで、スクロール時にフォームの状態が保持されます。
- `FormMapDropdownField`と違い、コンパイル時に固定で定義されている列挙型を選択肢として利用する場合に使用します。

## ベストプラクティス

1. フォームの状態管理には`FormController`を使用する
2. `FormController`を使用する場合は、必ず`form`と`onSaved`をセットで定義する
3. `FormController.key`を与えた`Form`配下に配置するか、`form`パラメータに`FormController`を渡すことで配置する
4. `FormController`を使用せず、`onChanged`メソッドを使用して変更の都度処理を行う方法も利用可能
5. バリデーションは`validator`パラメータを使用して定義する（例: 特定の値の禁止、必須チェック）
6. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
7. `picker`の`values`には列挙型の`values`をそのまま渡すか、`where()`で絞り込んだリストを渡す
8. `labelBuilder`を使用して、ユーザーフレンドリーなラベルを表示する（列挙型に`label`getterを定義するのが推奨）
9. `expanded`を使用して、レイアウトに合わせてドロップダウンの幅を調整する
10. リスト内で使用する場合は`keepAlive`を`true`に設定して状態を保持する（デフォルトで`true`）
11. 動的な選択肢が必要な場合は`FormMapDropdownField`を使用し、固定の列挙型を使用する場合は`FormEnumDropdownField`を使用する

## 利用シーン

- ユーザータイプの選択（管理者、一般ユーザー、ゲストなど）
- 権限レベルの設定（読み取り専用、編集可能、管理者など）
- ステータスの選択（下書き、公開済み、非公開など）
- カテゴリーの選択（ニュース、ブログ、商品など）
- 優先度の選択（高、中、低など）
- 設定オプションの選択（テーマ、言語、通知設定など）
- 性別の選択（男性、女性、その他など）
- 並び順の選択（昇順、降順など）
- フィルター条件の選択（すべて、有効、無効など）
