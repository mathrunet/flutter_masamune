# `MessageBox`の利用方法

# MessageBox

## 概要

ユーザーに伝えるメッセージを表示するためのボックスウィジェット。アイコン、メッセージ、アクションを含むカスタマイズ可能なメッセージボックス。

## 特徴

- アイコン + メッセージ + アクションの横並びレイアウト
- カスタマイズ可能なスタイリング（色、背景色、ボーダー、角丸など）
- アクションボタンの追加が可能（複数可）
- デフォルトのアイコンとして`Icons.info_outline`を使用
- 自動背景色生成（メインカラーの10%不透明度）
- IconThemeとDefaultTextStyleによる色の一括適用
- デフォルトのパディング16px、デフォルトの角丸16px

## 基本的な使い方

```dart
MessageBox(
  label: const Text("メッセージ内容をここに記載します"),
);
```

## カスタマイズ例

### カスタムアイコンとカラーの設定

```dart
MessageBox(
  label: const Text("カスタムアイコンとカラーを設定したメッセージ"),
  icon: const Icon(Icons.warning),
  color: Colors.orange,
  backgroundColor: Colors.orange.withOpacity(0.1),
);
```

### アクションボタンの追加

```dart
MessageBox(
  label: const Text("アクションボタン付きのメッセージ"),
  actions: [
    TextButton(
      onPressed: () {
        // アクション処理
      },
      child: const Text("OK"),
    ),
  ],
);
```

### カスタムスタイリング

```dart
MessageBox(
  label: const Text("カスタムスタイリングを適用したメッセージ"),
  padding: const EdgeInsets.all(24),
  margin: const EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(8),
  border: Border.all(
    color: Colors.blue,
    width: 2,
  ),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);
```

## 注意点

- `label`は必須パラメータ
- `icon`を指定しない場合は`Icons.info_outline`が使用される
- `color`を指定しない場合は`Theme.of(context).primaryColor`が使用される
- `backgroundColor`を指定しない場合は`color.withValues(alpha: 0.1)`が自動生成される
- `actions`は空のリストがデフォルト値
- デフォルトのパディングは`EdgeInsets.all(16)`
- デフォルトの角丸は`BorderRadius.circular(16)`
- デフォルトのボーダーは`Border.all(color: color, width: 1)`
- アイコンのサイズは固定で48px、色は`color`で指定
- `IconTheme`と`DefaultTextStyle`により、内部のアイコンとテキストの色が`color`に設定される
- アクションボタン間のスペースは16px
- `textStyle`パラメータは現在の実装では使用されていない（DefaultTextStyleが優先される）

## 利用シーン

- ユーザーに伝えるメッセージの表示
- ユーザーへの注意
- エラー表示
