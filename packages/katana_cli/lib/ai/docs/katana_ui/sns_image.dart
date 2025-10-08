// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of sns_image.md.
///
/// sns_image.mdの中身。
class KatanaUISnsImageMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of sns_image.md.
  ///
  /// sns_image.mdの中身。
  const KatanaUISnsImageMdCliAiCode();

  @override
  String get name => "`SnsImage`の利用方法";

  @override
  String get description =>
      "SNSスタイルのレイアウトで複数の画像を表示するウィジェットである`SnsImage`の利用方法。1〜4枚の画像を自動的にグリッドレイアウトで配置し、ソーシャルメディアの投稿表示に最適化。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "SNSスタイルのレイアウトで複数の画像を表示するウィジェット。画像枚数に応じて自動的に最適なグリッドレイアウトを適用し、タップイベントにも対応。";

  @override
  String body(String baseName, String className) {
    return """
# SnsImage

## 概要

$excerpt

## 特徴

- 画像枚数に基づく自動レイアウト（1〜4枚）
  - 1枚: 全幅表示
  - 2枚: 横並びレイアウト（1:1）
  - 3枚: 1枚大 + 2枚積み重ねレイアウト（左側1枚、右側2枚）
  - 4枚以上: 2x2グリッドレイアウト（最初の4枚のみ表示）
- カスタマイズ可能な画像フィッティング（fit）
- 画像間のスペース調整が可能（space）
- 各画像のタップコールバック（onTap）
- 設定可能なボーダー半径（borderRadius）
- 高さの調整が可能（height）
- 画像がない場合は自動的に非表示（SizedBox.shrink()）

## 基本的な使い方

### 単一画像の表示

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo.jpg'),
  ],
  height: 300,
);
```

### 複数画像の表示（2枚）

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo1.jpg'),
    NetworkImage('https://example.com/photo2.jpg'),
  ],
  height: 250,
);
```

### 3枚の画像表示

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo1.jpg'),
    NetworkImage('https://example.com/photo2.jpg'),
    NetworkImage('https://example.com/photo3.jpg'),
  ],
  height: 300,
);
```

### 4枚の画像表示（グリッド）

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo1.jpg'),
    NetworkImage('https://example.com/photo2.jpg'),
    NetworkImage('https://example.com/photo3.jpg'),
    NetworkImage('https://example.com/photo4.jpg'),
  ],
  height: 350,
);
```

## カスタマイズ例

### カスタムフィッティングとスペース

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo1.jpg'),
    NetworkImage('https://example.com/photo2.jpg'),
    NetworkImage('https://example.com/photo3.jpg'),
  ],
  fit: BoxFit.contain,
  space: 4.0,
  height: 300,
);
```

### 角丸の設定

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo1.jpg'),
    NetworkImage('https://example.com/photo2.jpg'),
  ],
  borderRadius: BorderRadius.circular(16),
  height: 280,
);
```

### タップイベントの処理

```dart
SnsImage(
  images: [
    NetworkImage('https://example.com/photo1.jpg'),
    NetworkImage('https://example.com/photo2.jpg'),
    NetworkImage('https://example.com/photo3.jpg'),
  ],
  onTap: (image) {
    // タップされた画像を拡大表示するなどの処理
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image(image: image),
      ),
    );
  },
  height: 300,
);
```

### アセット画像の使用

```dart
SnsImage(
  images: [
    AssetImage('assets/images/photo1.jpg'),
    AssetImage('assets/images/photo2.jpg'),
    AssetImage('assets/images/photo3.jpg'),
  ],
  height: 300,
  space: 3.0,
  borderRadius: BorderRadius.circular(12),
);
```

## 注意点

- `images`は必須パラメータ
- 画像が0枚の場合は`SizedBox.shrink()`が返される
- 5枚以上の画像を渡した場合、最初の4枚のみが表示される（2x2グリッド）
- デフォルトの`fit`は`BoxFit.cover`
- デフォルトの`space`（画像間のスペース）は2.0
- デフォルトの`height`は240.0
- `borderRadius`のデフォルトは`BorderRadius.zero`（角丸なし）
- 各画像は`InkWell`でラップされており、タップ時のリップルエフェクトが表示される
- 内部では`ClipRRect`を使用してborderRadiusを適用
- 画像の配置:
  - 1枚: SizedBox > ClipRRect > InkWell > Image
  - 2枚: SizedBox > ClipRRect > Row > [Expanded(Image), Expanded(Image)]
  - 3枚: SizedBox > ClipRRect > Row > [Expanded(Image), Expanded(Column > [Expanded(Image), Expanded(Image)])]
  - 4枚以上: SizedBox > ClipRRect > Row > [Expanded(Column > 2画像), Expanded(Column > 2画像)]

## 利用シーン

- SNSの投稿画像表示
- フォトギャラリー
- ソーシャルメディアフィード
- 複数画像を含むブログ記事
- 商品画像の複数表示
- ユーザー生成コンテンツの画像表示
""";
  }
}
