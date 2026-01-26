# `FormLabel`の利用方法

`FormLabel`は下記のように利用する。

## 概要

フォームフィールドのラベルを表示するためのウィジェット。`FormStyle`で共通したデザインを適用可能。必須マーク、ヘルプテキスト、エラーメッセージなどの表示機能を備えています。

## パッケージのインポート

このコンポーネントを使用するには、以下のパッケージをインポートする必要があります：

```dart
import 'package:masamune/masamune.dart';
```

このインポートにより、Masamuneフレームワークが提供するすべてのフォームコンポーネントとユーティリティにアクセスできます。

## 基本的な利用方法

```dart
FormLabel(
  "ユーザー名",
);
```

## アイコン付きの利用方法

```dart
FormLabel(
  "ユーザー名",
  icon: Icon(Icons.person),
);
```

## ヘルプテキスト付きの利用方法

```dart
FormLabel(
  "ユーザー名",
  icon: Icon(Icons.person),
  notice: Text("8文字以上の英数字を入力してください"),
);
```

## カスタムデザインの適用

```dart
FormLabel(
  "ユーザー名",
  style: const FormStyle(
    color: Colors.blue,
    borderColor: Colors.blue,  // 分断線の色
  ),
);
```

## 色を直接指定する

```dart
FormLabel(
  "ユーザー名",
  icon: Icons.person,
  color: Colors.blue,  // ラベルとアイコンの色を直接指定
);
```

## 分断線なしの利用方法

```dart
FormLabel(
  "ユーザー名",
  icon: Icons.person,
  showDivider: false,  // 分断線を非表示
);
```

## プレフィックス・サフィックス付きの利用方法

```dart
FormLabel(
  "ユーザー名",
  icon: Icons.person,
  prefix: Icon(Icons.arrow_forward, size: 12),
  suffix: Text("必須", style: TextStyle(color: Colors.red, fontSize: 10)),
);
```

## 複数の機能を組み合わせた利用方法

```dart
FormLabel(
  "パスワード",
  icon: Icons.lock,
  color: Colors.blue,
  notice: Text(
    "8文字以上の英数字を含む必要があります",
    style: TextStyle(fontSize: 10, color: Colors.grey),
  ),
  suffix: Text("必須", style: TextStyle(color: Colors.red, fontSize: 10)),
  style: const FormStyle(
    borderColor: Colors.blue,
  ),
);
```

## パラメータ

### 必須パラメータ
- 第1パラメータ (`label`): ラベルテキスト。フィールドの説明ラベルを設定します。

### オプションパラメータ
- `icon`: アイコン（`IconData`型）。ラベルの前に表示するアイコンを設定します。サイズは12で表示されます。
- `style`: フォームのスタイル。`FormStyle`を使用してデザインをカスタマイズできます。`color`と`borderColor`が主に使用されます。
- `color`: ラベルとアイコンの色を直接指定します。`style.color`より優先されます。
- `prefix`: 分断線の前（左側）に表示するウィジェットを設定します。
- `suffix`: 分断線の後（右側）に表示するウィジェットを設定します。必須マークなどの表示に利用できます。
- `notice`: ヘルプテキストウィジェット。ラベルの後に表示されるフィールドの説明文を設定します。
- `showDivider`: 分断線を表示するかどうか。`false`の場合、分断線が非表示になります。デフォルトは`true`です。

### `FormStyle`で設定可能なプロパティ（FormLabel特有）
- `color`: ラベルテキストとアイコンの色
- `borderColor`: 分断線の色

## 注意点

- `FormLabel`は`FormController`とは連携せず、単独で使用できるウィジェットです。
- `FormStyle`を使用することで、共通したデザインを適用できます。
- `color`パラメータは`style.color`より優先されます。
- アイコンは`IconData`型で指定し、サイズは12で固定表示されます。
- ラベルテキストのフォントサイズは12で固定表示されます。
- ヘルプテキストは`notice`パラメータにウィジェットを渡すことで自由にカスタマイズできます。
- `showDivider`を`false`にすると、左右の分断線が非表示になります。
- 分断線の色は`style.borderColor`が優先され、未指定の場合は`Theme`のテキスト色の50%透明度が使用されます。
- `prefix`と`suffix`を使用して、分断線の前後に追加のウィジェットを配置できます。
- `suffix`は必須マーク（例: `Text("必須", style: TextStyle(color: Colors.red))`）の表示に便利です。

## ベストプラクティス

1. アプリ全体で統一したデザインを適用するために`FormStyle`を使用する
2. フォームのセクションを明確にするために`FormLabel`を使用する
3. アイコンを使用してラベルの意味を視覚的にわかりやすくする
4. 必須入力項目には`suffix`を使用して必須マークを表示する（例: `Text("必須", style: TextStyle(color: Colors.red))`）
5. ヘルプテキストは`notice`パラメータを使用して、フィールドの説明を明確にする
6. セクションヘッダーとして使用する場合は、`showDivider: true`で視覚的に分離する
7. シンプルなラベルのみの場合は、`showDivider: false`で分断線を非表示にする
8. `color`を使用して、重要なラベルを強調表示する
9. フォーム全体で一貫したラベルスタイルを使用する

## 利用シーン

- フォームフィールドのラベル表示（入力フィールドの説明）
- 必須入力項目の明示（必須マーク付きラベル）
- フィールドの説明表示（ヘルプテキスト付きラベル）
- フォームのセクション分け（セクションヘッダー）
- カテゴリーごとのフォーム区切り
- 重要なフィールドの強調表示
- フォームのグループ化
- 入力ルールの説明表示
- 視覚的なフォーム構造の明確化
