# `Label`の利用方法

# Label

## 概要

項目のタイトルなどで使うラベルを表示するためのウィジェット。アイコンやテキストを組み合わせて使用可能。

## 特徴

- テキストとアイコンの組み合わせが可能
- カスタマイズ可能な背景色とスタイリング
- アクションボタンの追加が可能
- 柔軟なパディングとアライメントの設定
- テーマに基づいたデフォルトスタイリング

## 基本的な使い方

### シンプルなラベル

```dart
Label(
  "シンプルなラベル",
);
```

### アイコン付きラベル

```dart
Label(
  "アイコン付きラベル",
  leading: Icon(Icons.label),
);
```

### スタイル付きラベル

```dart
Label(
  "スタイル付きラベル",
  backgroundColor: Colors.blue.withOpacity(0.1),
  color: Colors.blue,
  padding: const EdgeInsets.all(8),
);
```

## カスタマイズ例

### アクション付きラベル

```dart
Label(
  "アクション付きラベル",
  leading: Icon(Icons.label),
  actions: [
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        // 編集アクション
      },
    ),
    IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        // 削除アクション
      },
    ),
  ],
);
```

### カスタムデコレーション

```dart
Label(
  "カスタムデコレーション",
  decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey),
  ),
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
);
```

### カスタムテキストスタイル

```dart
Label(
  "カスタムテキストスタイル",
  textStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.indigo,
  ),
);
```

## 注意点

- `text`は必須パラメータ
- デフォルトのテキストスタイルは`Theme.of(context).textTheme.titleMedium`をベースに太字で設定
- `actions`を追加すると、アクション間に自動的に8.0のパディングが追加される
- `leading`（アイコン）とテキストの間のデフォルトスペースは16.0
- テキストの色とアイコンの色は`color`パラメータで統一的に設定可能

## 利用シーン

- メニューのグループ項目のタイトルラベル
- UIのセクションのタイトルラベル
- フォームの項目のラベル
