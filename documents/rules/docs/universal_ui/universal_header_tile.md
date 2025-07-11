# `UniversalHeaderTile`の利用方法

`UniversalHeaderTile`は下記のように利用する。

## 概要

プロフィールなどのヘッダーに用いることのできるタイル。中身としては`ListTile`に同じように利用可能だがリストの上部に配置するようにデザインされている。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。ヘッダーとして使用することを想定したタイル。`leading`、`title`、`trailing`などの基本的なListTileの機能に加え、`onTap`を設定可能。

## 利用方法

```dart
UniversalHeaderTile(
  leading: const Icon(Icons.person),
  title: const Text("ユーザー名"),
  trailing: [
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
          // TODO: Implement the settings action.
      },
    ),
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
          // TODO: Implement the logout action.
      },
    ),
  ],
  onTap: () {
      // TODO: Implement the tap action.
  },
);
```

## プロパティ

- `leading`: タイルの左側に表示するウィジェットを設定する。
- `title`: タイルのタイトルを設定する。
- `trailing`: タイルの右側に表示するウィジェットのリストを設定する。
- `onTap`: タイルをタップした時のコールバックを設定する。
- `backgroundColor`: タイルの背景色を設定する。
- `padding`: タイルの内側の余白を設定する。
- `height`: タイルの高さを設定する。
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。

## 注意点

- デスクトップモードでは、`trailing`のウィジェットが横に並んで表示される。
- モバイルモードでは、標準的なListTileのレイアウトが適用される。
- `UniversalScaffold`と組み合わせることで、より柔軟なレイアウトが可能。
- ヘッダーとして使用することを想定しているため、`subtitle`は設定できない。
