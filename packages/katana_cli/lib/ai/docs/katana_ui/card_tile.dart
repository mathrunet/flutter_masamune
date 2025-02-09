// Project imports:
import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of card_tile.mdc.
///
/// card_tile.mdcの中身。
class KatanaUICardTileMdcCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of card_tile.mdc.
  ///
  /// card_tile.mdcの中身。
  const KatanaUICardTileMdcCliAiCode();

  @override
  String get name => "`CardTile`の利用方法";

  @override
  String get description =>
      "カードウィジェットの上に画像やテキストを重ねて表示するためのウィジェットである`CardTile`の利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "カードウィジェットの上に画像やテキストを重ねて表示するためのウィジェット。ListTileと組み合わせて使用する高機能なカードコンポーネント。";

  @override
  String body(String baseName, String className) {
    return """
# CardTile

## 概要

$excerpt

## 特徴

- フィーチャー画像/ウィジェットの表示
- カスタマイズ可能なカードデザイン
- タップ可能なインタラクション
- 柔軟なレイアウトオプション
- テーマに基づいたデフォルトスタイル
- 追加のボトムコンテンツのサポート

## 基本的な使い方

### シンプルなカードタイル

```dart
CardTile(
  title: Text("カードのタイトル"),
  subtitle: Text("カードの説明文"),
  onTap: () {
    // タップ時の処理
  },
);
```

## カスタマイズ例

### フィーチャー画像付きカード

```dart
CardTile(
  feature: Image.network(
    'https://example.com/image.jpg',
    fit: BoxFit.cover,
  ),
  title: Text("画像付きカード"),
  subtitle: Text("美しい画像と説明文"),
  height: 300,
);
```

### カスタムスタイリング

```dart
CardTile(
  backgroundColor: Colors.blue[50],
  shadowColor: Colors.blue[200],
  elevation: 4.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  margin: EdgeInsets.all(16),
  title: Text("スタイリングカード"),
  iconColor: Colors.blue,
  textColor: Colors.blue[900],
);
```

### アイコンとアクション付きカード

```dart
CardTile(
  leading: Icon(Icons.star),
  title: Text("アイコン付きカード"),
  trailing: IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {
      // アクションボタンの処理
    },
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
);
```

### 複合的なレイアウト

```dart
CardTile(
  feature: Stack(
    children: [
      Image.network(
        'https://example.com/background.jpg',
        fit: BoxFit.cover,
      ),
      Positioned(
        top: 16,
        right: 16,
        child: Icon(
          Icons.favorite,
          color: Colors.white,
        ),
      ),
    ],
  ),
  title: Text("複合レイアウトカード"),
  subtitle: Text("複数の要素を組み合わせたカード"),
  bottom: Container(
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Text("アクション1"),
        ),
        TextButton(
          onPressed: () {},
          child: Text("アクション2"),
        ),
      ],
    ),
  ),
);
```

### カスタムサイズ指定

```dart
CardTile(
  width: 300,
  height: 400,
  feature: Image.network(
    'https://example.com/image.jpg',
    fit: BoxFit.cover,
  ),
  title: Text("固定サイズカード"),
  featureColor: Colors.grey[200],
);
```

## 注意点

- `feature`を指定する場合、`height`も指定することでフィーチャー部分が`Expanded`として配置される
- `backgroundColor`を指定しない場合は`Theme.of(context).colorScheme.surface`が使用される
- `textColor`を指定しない場合は`Theme.of(context).colorScheme.onSurface`が使用される
- `iconColor`を指定しない場合は`Theme.of(context).colorScheme.onSurface`が使用される
- `margin`はカード全体の外側のマージン
- `contentPadding`は`ListTile`部分の内側のパディング
- `bottom`ウィジェットは`ListTile`の下に配置される
- `borderOnForeground`は常に`true`で、境界線は前面に描画される
- `clipBehavior`は`Clip.antiAliasWithSaveLayer`で固定
""";
  }
}
