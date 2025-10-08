# `ChatTile`の利用方法

# ChatTile

## 概要

チャットの吹き出しを作成するためのウィジェット。メッセージの配置や見た目をカスタマイズ可能で、自分と相手のメッセージを視覚的に区別できる。

## 特徴

- メッセージの左右配置が可能（mainAxisAlignment、reverse）
- アバターやアイコンの配置が可能（leading/trailing）
- タイトルの追加が可能（送信者名など）
- アクションボタンの追加が可能（actions）
- カスタマイズ可能なスタイリング（backgroundColor、foregroundColor、elevation、borderRadius）
- テーマに基づいたデフォルトスタイル
- リバースモードでメッセージ方向を反転可能
- IconThemeとDefaultTextStyleによる色の一括適用

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

- `label`は必須パラメータ（メッセージ本文）
- `reverse`を`true`にすると、メッセージの向き（leading/trailing、Row方向）が反転する
- デフォルトの`mainAxisAlignment`は`MainAxisAlignment.start`
- デフォルトの`crossAxisAlignment`は`CrossAxisAlignment.start`
- デフォルトの`elevation`は0.0
- デフォルトの`space`（アイコンとメッセージの間隔）は4.0
- デフォルトの`padding`は上下4px（`EdgeInsets.symmetric(vertical: 4)`）
- デフォルトの`contentPadding`は全方向16px（`EdgeInsets.all(16)`）
- デフォルトの`borderRadius`は8.0（`BorderRadius.circular(8)`）
- `backgroundColor`を指定しない場合は`Theme.of(context).colorScheme.surface`が使用される
- `foregroundColor`を指定しない場合は`Theme.of(context).colorScheme.onSurface`が使用される
- `foregroundColor`はIconThemeとDefaultTextStyleに適用される
- reverseがtrueの場合、leading/trailingとRowの順序が逆になる
- 内部構造: Padding > Row > [leading/trailing, Flexible(Container(label) + actions)]

## 利用シーン

- チャットアプリのメッセージ表示
- AIとのやりとりの表示
