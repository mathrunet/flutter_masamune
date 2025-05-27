// Project imports:
import 'package:katana_cli/ai/docs/katana_ui_usage.dart';

/// Contents of chat_tile.md.
///
/// chat_tile.mdの中身。
class KatanaUIChatTileMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of chat_tile.md.
  ///
  /// chat_tile.mdの中身。
  const KatanaUIChatTileMdCliAiCode();

  @override
  String get name => "`ChatTile`の利用方法";

  @override
  String get description => "チャットの吹き出しを作成するためのウィジェットである`ChatTile`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "チャットの吹き出しを作成するためのウィジェット。メッセージの配置や見た目をカスタマイズ可能で、自分と相手のメッセージを視覚的に区別できる。";

  @override
  String body(String baseName, String className) {
    return """
# ChatTile

## 概要

$excerpt

## 特徴

- メッセージの左右配置が可能
- アバターやアイコンの配置が可能
- タイトルの追加が可能
- アクションボタンの追加が可能
- カスタマイズ可能なスタイリング
- テーマに基づいたデフォルトスタイル

## 基本的な使い方

### 基本的なチャットメッセージ

```dart
ChatTile(
  Text("こんにちは！"),
);
```

### 自分のメッセージ（右寄せ）

```dart
ChatTile(
  Text("自分のメッセージ"),
  mainAxisAlignment: MainAxisAlignment.end,
  backgroundColor: Colors.blue[100],
  reverse: true,
);
```

### 相手のメッセージ（左寄せ）

```dart
ChatTile(
  Text("相手のメッセージ"),
  leading: CircleAvatar(
    child: Icon(Icons.person),
  ),
  backgroundColor: Colors.grey[100],
);
```

## カスタマイズ例

### アバターとタイトル付きメッセージ

```dart
ChatTile(
  Text("メッセージ本文"),
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: Text(
    "ユーザー名",
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
);
```

### アクション付きメッセージ

```dart
ChatTile(
  Text("アクション付きメッセージ"),
  actions: [
    TextButton(
      onPressed: () {
        // コピーアクション
      },
      child: Text("コピー"),
    ),
    TextButton(
      onPressed: () {
        // 返信アクション
      },
      child: Text("返信"),
    ),
  ],
);
```

### カスタムスタイリング

```dart
ChatTile(
  Text("カスタムスタイルのメッセージ"),
  backgroundColor: Colors.purple[50],
  foregroundColor: Colors.purple[900],
  elevation: 2.0,
  borderRadius: BorderRadius.circular(16),
  padding: EdgeInsets.all(12),
  contentPadding: EdgeInsets.all(16),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
);
```

## 注意点

- `label`は必須パラメータ
- `reverse`を`true`にすると、メッセージの向きが反転する
- デフォルトの`mainAxisAlignment`は`MainAxisAlignment.start`
- デフォルトの`crossAxisAlignment`は`CrossAxisAlignment.start`
- デフォルトの`elevation`は0.0
- デフォルトの`space`（アイコンとメッセージの間隔）は4.0
- デフォルトの`padding`は上下4px
- デフォルトの`contentPadding`は全方向16px
- デフォルトの`borderRadius`は8.0
- `backgroundColor`と`foregroundColor`を指定しない場合は、テーマの色が使用される
""";
  }
}
