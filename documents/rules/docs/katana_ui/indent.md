# `Indent`の利用方法

# Indent

## 概要

ColumnやListViewの中で、要素間にパディングを設定しながら複数の要素を縦に配置するためのウィジェット。

## 特徴

- PaddingとColumnを1つのウィジェットに統合
- 要素間のパディングを簡単に設定可能
- `Column`のような垂直方向のレイアウトを提供
- クロス軸（crossAxisAlignment）とメイン軸（mainAxisAlignment）の配置をカスタマイズ可能
- 垂直方向（verticalDirection）の配置を制御可能
- メインサイズ（mainAxisSize）の調整が可能
- ネストされたPadding + Columnよりもクリーンなコード

## 基本的な使い方

### シンプルな要素の配置

```dart
Indent(
  padding: const EdgeInsets.all(16),
  children: [
    Text("最初の要素"),
    Text("2番目の要素"),
    Text("3番目の要素"),
  ],
);
```

## カスタマイズ例

### カスタム配置とアライメント

```dart
Indent(
  padding: const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  ),
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.star),
    Text("中央揃えのテキスト"),
    ElevatedButton(
      onPressed: () {},
      child: Text("ボタン"),
    ),
  ],
);
```

### 逆方向の配置

```dart
Indent(
  padding: const EdgeInsets.all(8),
  verticalDirection: VerticalDirection.up,
  children: [
    Text("下に表示される要素"),
    Text("中央の要素"),
    Text("上に表示される要素"),
  ],
);
```

### 最大サイズでの配置

```dart
Indent(
  padding: const EdgeInsets.all(16),
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("上部の要素"),
    Text("中央の要素"),
    Text("下部の要素"),
  ],
);
```

### 異なるウィジェットの組み合わせ

```dart
Indent(
  padding: const EdgeInsets.all(16),
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text("カード内のテキスト"),
      ),
    ),
    ElevatedButton(
      onPressed: () {},
      child: Text("アクションボタン"),
    ),
    Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Text("コンテナ内のテキスト"),
    ),
  ],
);
```

## 注意点

- `padding`と`children`は必須パラメータ
- デフォルトの`crossAxisAlignment`は`CrossAxisAlignment.start`
- デフォルトの`mainAxisAlignment`は`MainAxisAlignment.start`
- デフォルトの`mainAxisSize`は`MainAxisSize.min`
- デフォルトの`verticalDirection`は`VerticalDirection.down`
- 内部的には`Padding`と`Column`を組み合わせて実装
- 水平方向のレイアウトには対応していない（垂直方向のみ）

## 利用シーン

- `Column`の中で利用することで、要素間にパディングを設定しながら複数の要素を縦に配置。
