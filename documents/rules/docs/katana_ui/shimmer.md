# `Shimmer`の利用方法

# Shimmer

## 概要

ローディング状態を表現するためのシマーエフェクトを提供するウィジェット。単一行と複数行のシマーエフェクトに対応。

## 特徴

- 単一行（ShimmerBox）と複数行（ShimmerMultiLine）のシマーエフェクトに対応
- カスタマイズ可能な色とスタイリング（baseColor、highlightColor）
- テーマに基づいたデフォルトカラー
- 柔軟なサイズ調整（width、height）
- 角丸や形状のカスタマイズが可能（borderRadius、shape）
- 円形（BoxShape.circle）と矩形（BoxShape.rectangle）をサポート
- エフェクトの有効/無効化オプション（enabled）
- カスタムchildウィジェットのサポート

## 基本的な使い方

### 単一行のシマーエフェクト（ShimmerBox）

```dart
ShimmerBox(
  width: 200,
  height: 20,
);
```

### 複数行のシマーエフェクト（ShimmerMultiLine）

```dart
ShimmerMultiLine(
  lineCount: 3,
  lineSpace: 8,
);
```

## カスタマイズ例

### カスタムカラーの設定

```dart
ShimmerBox(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  width: 150,
  height: 24,
);
```

### カスタム形状の設定

```dart
ShimmerBox(
  borderRadius: BorderRadius.circular(12),
  shape: BoxShape.rectangle,
  width: 100,
  height: 100,
);
```

### 円形のシマーエフェクト

```dart
ShimmerBox(
  shape: BoxShape.circle,
  width: 50,
  height: 50,
);
```

### カスタマイズされた複数行

```dart
ShimmerMultiLine(
  lineCount: 4,
  lineSpace: 12,
  baseColor: Colors.blue[100],
  highlightColor: Colors.blue[50],
  padding: const EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(8),
);
```

### カスタムコンテンツを含むシマー

```dart
ShimmerBox(
  child: Container(
    width: 200,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.grey[300],
    ),
    child: const Center(
      child: Icon(Icons.image, size: 40),
    ),
  ),
);
```

## 注意点

### ShimmerBox
- `height`を指定しない場合は、テーマのbodyMediumフォントサイズまたは12pxが使用される
- `width`のデフォルトは`double.infinity`
- `baseColor`のデフォルトは`Theme.of(context).colorScheme.surface`
- `highlightColor`のデフォルトは`Theme.of(context).scaffoldBackgroundColor`
- `borderRadius`のデフォルトは高さの1/4の角丸（`BorderRadius.circular(h / 4)`）
- `shape`が`BoxShape.circle`の場合、borderRadiusは無視される
- `enabled`が`false`の場合、シマーエフェクトなしで`child`または通常のContainerが表示される
- `padding`は実際には`margin`として適用される（Containerのmarginパラメータに使用）
- 内部では`shimmer`パッケージの`Shimmer.fromColors`を使用している

### ShimmerMultiLine
- 各行の設定は`ShimmerBox`と同じ
- `lineCount`で行数を指定（デフォルト3行）
- `lineSpace`で行間を指定（デフォルト8px）
- パディングはデフォルトで`EdgeInsets.all(0)`
- 内部ではColumnで複数のShimmerBoxを並べて実装

## 利用シーン

### ShimmerBox

- `ListTile`や`Card`、`LineTile`等のローディング状態の表示

### ShimmerMultiLine

- 投稿など複数行テキストのローディング状態の表示
