# `LineTile`の利用方法

# LineTile

## 概要

`ListTile`に`text`プロパティを追加したもの、textプロパティにWidgetを設定するとtitleの右側に表示される。

## 特徴

- `ListTile`を継承し、すべてのListTile機能を利用可能
- タイトルとテキストを横並びに配置可能（Row + Expanded/Flexible構造）
- タイトルとテキストの比率を`titleFlex`と`textFlex`で調整可能
- 間隔を`space`で調整可能（デフォルト8.0）
- シマーエフェクトに対応（`shimmer`プロパティ、`shimmer`パッケージを使用）
- `ListTileGroup`（`_LineTileGroupScope`）と組み合わせることで、グループ化されたデザインを実現
- VisualDensity自動調整（ListTileGroup内ではVisualDensity.compact）

## 基本的な使い方

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
);
```

## カスタマイズ例

### フレックス比率の調整

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
  titleFlex: 2,  // タイトルの比率を2に
  textFlex: 1,   // テキストの比率を1に
);
```

### 間隔の調整

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
  space: 16.0,  // タイトルとテキストの間隔を16.0に
);
```

### シマーエフェクトの利用

```dart
LineTile(
  title: const Text("タイトル"),
  text: const Text("テキスト"),
  shimmer: true,  // シマーエフェクトを有効化
  shimmerBaseColor: Colors.grey[300],
  shimmerHighlightColor: Colors.grey[100],
);
```

## 注意点

- `text`プロパティは省略可能（titleのみでも使用可能）
- `ListTile`の機能をすべて継承しているため、`leading`や`trailing`なども利用可能
- シマーエフェクトを使用する場合は、ベースカラーとハイライトカラーを適切に設定することを推奨
- `shimmer: true`の場合、titleとtextは実際のウィジェットの代わりにシマー用のContainerが表示される
- `titleFlex`のデフォルトは1、`textFlex`のデフォルトは1
- titleは`Expanded`、textは`Flexible`で配置される
- `ListTileGroup`内で使用する場合、`tileColor`と`selectedTileColor`は自動的に`Colors.transparent`に設定される
- シマー時のsubtitleの高さは`Theme.of(context).listTileTheme.subtitleTextStyle?.fontSize`または12pxが使用される
- 内部では`Material`でラップされており、`color: Colors.transparent`が設定されている

## 利用シーン

- メニューの項目
- リストの項目
- `ListTile`の代替
