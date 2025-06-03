// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of avatar_tile.md.
///
/// avatar_tile.mdの中身。
class KatanaUIAvatarTileMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of avatar_tile.md.
  ///
  /// avatar_tile.mdの中身。
  const KatanaUIAvatarTileMdCliAiCode();

  @override
  String get name => "`AvatarTile`の利用方法";

  @override
  String get description => "プロフィールなどの概要を表示するためのタイルである`AvatarTile`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "プロフィールなどの概要を表示するためのタイル。アバター画像、タイトル、サブタイトル、説明文を含むカスタマイズ可能なプロフィールカード。";

  @override
  String body(String baseName, String className) {
    return """
# AvatarTile

## 概要

$excerpt

## 特徴

- 大きなアバター画像の表示
- タイトル、サブタイトル、説明文の3段階の情報表示
- カスタマイズ可能なテキストスタイル
- 柔軟なスタイリングオプション
- テーマに基づいたデフォルトスタイル
- 固定高さのレイアウト

## 基本的な使い方

### シンプルなプロフィールカード

```dart
AvatarTile(
  avatar: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@username"),
  description: Text("プロフィール説明文をここに記載します。"),
);
```

## カスタマイズ例

### カスタムスタイリング

```dart
AvatarTile(
  height: 150.0,
  backgroundColor: Colors.blue[50],
  foregroundColor: Colors.blue[900],
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: Colors.blue),
  padding: EdgeInsets.all(16),
  avatar: CircleAvatar(
    radius: 60,
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@username"),
  description: Text("プロフィール説明文"),
);
```

### カスタムテキストスタイル

```dart
AvatarTile(
  titleTextStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
  ),
  subtitleTextStyle: TextStyle(
    fontSize: 14,
    color: Colors.grey,
  ),
  descriptionTextStyle: TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@username"),
  description: Text("プロフィール説明文"),
);
```

### タグ付きサブタイトル

```dart
AvatarTile(
  title: Text("ユーザー名"),
  subtitle: Wrap(
    spacing: 8,
    children: [
      Chip(label: Text("デザイナー")),
      Chip(label: Text("エンジニア")),
      Chip(label: Text("PM")),
    ],
  ),
  description: Text("プロフィール説明文"),
);
```

## 注意点

- デフォルトの高さは`kAvatarTileHeight`（128.0）
- デフォルトのパディングは水平方向に16px
- アバター画像の幅と高さはタイルの高さと同じ
- アバター画像と内容の間のスペースは32px
- テキストスタイルのデフォルト値：
  - タイトル: `Theme.of(context).textTheme.displaySmall`または36px
  - サブタイトル: `Theme.of(context).textTheme.labelSmall`または11px
  - 説明文: `Theme.of(context).textTheme.bodyMedium`または14px
- 背景色のデフォルトは`Theme.of(context).colorScheme.surface`
- 前景色のデフォルトは`Theme.of(context).colorScheme.onSurface`

## 利用シーン 

- ユーザーのプロフィール情報の表示
- チャットアプリのユーザー情報の表示
- メディアアプリの投稿者情報の表示
- ブログやニュースサイトの記事の著者情報の表示
- ソーシャルメディアのプロフィール情報の表示
""";
  }
}
