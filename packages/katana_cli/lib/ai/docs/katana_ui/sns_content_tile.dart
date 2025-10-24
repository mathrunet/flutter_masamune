// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of sns_content_tile.md.
///
/// sns_content_tile.mdの中身。
class KatanaUISnsContentTileMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of sns_content_tile.md.
  ///
  /// sns_content_tile.mdの中身。
  const KatanaUISnsContentTileMdCliAiCode();

  @override
  String get name => "`SnsContentTile`の利用方法";

  @override
  String get description =>
      "SNSのコンテンツを表示するウィジェットである`SnsContentTile`の利用方法。Twitter/Xスタイルの投稿レイアウトを提供し、リーディングアバター、タイトル、サブタイトル、メインコンテンツ、ボトムアクションを含む。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "SNSのコンテンツを表示するウィジェット。プロフィールアバター、ユーザー名、ハンドル/タイムスタンプ、投稿内容、アクションボタンを含むソーシャルメディアスタイルの投稿レイアウトを提供。";

  @override
  String body(String baseName, String className) {
    return """
# SnsContentTile

## 概要

$excerpt

## 特徴

- リーディングウィジェットエリア（通常はプロフィールアバター用）
- ヘッダー行のタイトルとサブタイトル（ユーザー名とハンドル/タイムスタンプ）
- カスタマイズ可能なパディングを持つメインコンテンツエリア
- オプションのボトムアクションエリア（いいね、シェア、コメントボタン）
- 要素間のカスタマイズ可能なスペーシング（space）
- テーマベースのテキストとアイコンのスタイリング（IconTheme、DefaultTextStyle）
- タップインタラクションのサポート（onTap）
- Twitter/Xスタイルのレイアウト構造
- カスタマイズ可能な背景色とマージン

## 基本的な使い方

### シンプルな投稿表示

```dart
SnsContentTile(
  leading: CircleAvatar(
    child: Icon(Icons.person),
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@handle · 2時間前"),
  content: Text("投稿内容がここに入ります。"),
);
```

## カスタマイズ例

### プロフィール画像付き投稿

```dart
SnsContentTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: Text(
    "田中太郎",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  subtitle: Text(
    "@tanaka · 3時間前",
    style: TextStyle(color: Colors.grey),
  ),
  content: Text(
    "今日はとても良い天気ですね！散歩に最適です。",
  ),
);
```

### アクションボタン付き投稿

```dart
SnsContentTile(
  leading: CircleAvatar(
    child: Icon(Icons.person),
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@username · 1時間前"),
  content: Text("投稿内容"),
  bottom: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {
          // いいねアクション
        },
      ),
      IconButton(
        icon: Icon(Icons.chat_bubble_outline),
        onPressed: () {
          // コメントアクション
        },
      ),
      IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          // シェアアクション
        },
      ),
    ],
  ),
);
```

### カスタムスタイリング

```dart
SnsContentTile(
  backgroundColor: Colors.grey[50],
  margin: EdgeInsets.symmetric(vertical: 8),
  padding: EdgeInsets.all(20),
  space: 12.0,
  textColor: Colors.black87,
  iconColor: Colors.blue,
  leading: CircleAvatar(
    backgroundColor: Colors.blue,
    child: Icon(Icons.person, color: Colors.white),
  ),
  title: Text("カスタムスタイル"),
  subtitle: Text("@custom · 30分前"),
  content: Text("カスタマイズされた投稿です。"),
);
```

### 画像付き投稿

```dart
SnsContentTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: Text("フォトグラファー"),
  subtitle: Text("@photographer · 5時間前"),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("美しい風景を撮影しました。"),
      SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://example.com/photo.jpg',
          fit: BoxFit.cover,
        ),
      ),
    ],
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 12),
  bottom: Row(
    children: [
      IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {},
      ),
      Text("24"),
      SizedBox(width: 16),
      IconButton(
        icon: Icon(Icons.chat_bubble_outline),
        onPressed: () {},
      ),
      Text("5"),
    ],
  ),
);
```

### タップイベントの処理

```dart
SnsContentTile(
  onTap: () {
    // 投稿全体がタップされた時の処理
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(),
      ),
    );
  },
  leading: CircleAvatar(
    child: Icon(Icons.person),
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@username · 10分前"),
  content: Text("タップ可能な投稿です。"),
);
```

### コンテンツパディングのカスタマイズ

```dart
SnsContentTile(
  leading: CircleAvatar(
    child: Icon(Icons.person),
  ),
  title: Text("ユーザー名"),
  subtitle: Text("@username"),
  content: Text("コンテンツ"),
  contentPadding: EdgeInsets.only(
    top: 8,
    bottom: 16,
  ),
  padding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 12,
  ),
);
```

## 注意点

- leadingエリアの幅は自動調整される（通常はCircleAvatarのサイズに依存）
- デフォルトの`space`（leadingとコンテンツの間隔）は8.0
- デフォルトの`contentPadding`（content周りのパディング）は`EdgeInsets.symmetric(vertical: 16)`
- デフォルトの`padding`（ウィジェット全体のパディング）は`EdgeInsets.symmetric(vertical: 16)`
- `textColor`を指定すると、`DefaultTextStyle`により内部のテキストの色が一括変更される
- `iconColor`を指定すると、`IconTheme`により内部のアイコンの色が一括変更される
- タイトルとサブタイトルは同じ行（Row）に横並びで配置される
- 内部構造: InkWell > Container > Row > [leading, Expanded(Column > [Row(title, subtitle), content, bottom])]
- `InkWell`でラップされており、タップ時のリップルエフェクトが表示される
- bottomエリアはcontentの直下に配置される
- title、subtitle、content、bottomはすべてオプショナル

## 利用シーン

- ソーシャルメディアフィード
- Twitter/Xスタイルの投稿表示
- コメントセクション
- ユーザー生成コンテンツの表示
- フォーラムやディスカッションの投稿
- レビューやフィードバックの表示
- チャット履歴の表示（より詳細な情報が必要な場合）
""";
  }
}
