# `ListTileGroup`の利用方法

# ListTileGroup

## 概要

`ListTile`や`LineTile`をグループ化して表示するためのウィジェット。タイル間の区切り線やスタイリングをカスタマイズ可能。

## 特徴

- 複数の`ListTile`や`LineTile`をグループ化
- タイル間に区切り線（divider）を追加可能
- グループ全体の背景色（tileColor）やボーダー（borderRadius）をカスタマイズ可能
- マージン（margin）とパディング（padding）の調整が可能
- 角丸の設定が可能（borderRadius）
- childrenが空の場合は自動的に非表示（SizedBox.shrink()）
- 内部で_LineTileGroupScopeを提供し、LineTileと連携

## 基本的な使い方

```dart
ListTileGroup(
  children: [
    ListTile(
      title: Text("タイル1"),
    ),
    ListTile(
      title: Text("タイル2"),
    ),
    ListTile(
      title: Text("タイル3"),
    ),
  ],
);
```

## カスタマイズ例

### 区切り線の追加

```dart
ListTileGroup(
  divider: const Divider(height: 1),
  children: [
    ListTile(
      title: Text("タイル1"),
    ),
    ListTile(
      title: Text("タイル2"),
    ),
    ListTile(
      title: Text("タイル3"),
    ),
  ],
);
```

### スタイリングのカスタマイズ

```dart
ListTileGroup(
  tileColor: Colors.grey[100],
  borderRadius: BorderRadius.circular(16),
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.symmetric(vertical: 12),
  children: [
    ListTile(
      title: Text("タイル1"),
    ),
    ListTile(
      title: Text("タイル2"),
    ),
  ],
);
```

### LineTileとの組み合わせ

```dart
ListTileGroup(
  children: [
    LineTile(
      title: Text("タイトル1"),
      text: Text("テキスト1"),
    ),
    LineTile(
      title: Text("タイトル2"),
      text: Text("テキスト2"),
    ),
  ],
);
```

## 注意点

- `children`は必須パラメータ
- `children`が空の場合は`SizedBox.shrink()`が返される
- デフォルトのマージンは上下8px（`EdgeInsets.symmetric(vertical: 8)`）
- デフォルトのパディングは上下8px（`EdgeInsets.symmetric(vertical: 8)`）
- デフォルトの角丸は12px（`BorderRadius.circular(12)`）
- デフォルトの背景色は`Theme.of(context).colorScheme.surface`
- `ListTileGroup`は`LineTileGroup`のエイリアス（typedefで定義）
- dividerが指定された場合、各タイルの間に区切り線が挿入される
- 内部では`ClipRRect`と`Container`を使用してスタイリングを実装
- LineTile使用時、グループ内のLineTileは自動的に`VisualDensity.compact`とtransparentな背景色が適用される

## 利用シーン

- メニューのグループ化
- UIのセクション化
