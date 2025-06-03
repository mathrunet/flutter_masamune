// Project imports:
import "package:katana_cli/ai/docs/universal_ui_usage.dart";

/// Contents of universal_avatar_sliver_app_bar.md.
///
/// universal_avatar_sliver_app_bar.mdの中身。
class UniversalAvatarSliverAppBarMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_avatar_sliver_app_bar.md.
  ///
  /// universal_avatar_sliver_app_bar.mdの中身。
  const UniversalAvatarSliverAppBarMdCliAiCode();

  @override
  String get name => "`UniversalAvatarSliverAppBar`の利用方法";

  @override
  String get description =>
      "アバター画像付きの`UniversalSliverAppBar`である`UniversalAvatarSliverAppBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`UniversalSliverAppBar`にアバター画像を追加できるAppBar。プロフィールページなどに適している。アバター画像とアクションボタンを配置可能で、背景画像やフィルターも設定可能。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalAvatarSliverAppBar`は下記のように利用する。

## 概要

$excerpt

## 利用方法

```dart
UniversalAvatarSliverAppBar(
  title: const Text("プロフィール"),
  subtitle: const Text("サブタイトル"),
  actions: [
    IconButton(
      icon: const Icon(Icons.share),
      onPressed: () {
          // TODO: Implement the share action.
      },
    ),
  ],
  avatarIcon: const CircleAvatar(
    backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
    radius: 40,
  ),
  avatarBorderWidth: 2.0,
  underBottomActions: [
    TextButton(
      onPressed: () {
          // TODO: Implement the follow action.
      },
      child: const Text("フォロー"),
    ),
    TextButton(
      onPressed: () {
          // TODO: Implement the message action.
      },
      child: const Text("メッセージ"),
    ),
  ],
  background: UniversalAppBarBackground(
    image: const NetworkImage("https://example.com/background.jpg"),
    filterColor: Colors.black54,
  ),
);
```

## プロパティ

- `title`: AppBarのタイトルを設定する。
- `subtitle`: タイトルの下に表示するサブタイトルを設定する。
- `actions`: AppBarの右側に表示するウィジェットのリストを設定する。
- `avatarIcon`: AppBarの下に表示するアバター画像ウィジェットを設定する。
- `avatarBorderWidth`: アバター画像の周りのボーダーの幅を設定する。
- `underBottomActions`: アバター画像の右側に表示するアクションボタンのリストを設定する。
- `underBottomHeight`: アバター画像より下の高さを設定する（デフォルト: 40.0）。
- `background`: AppBarの背景ウィジェットを設定する。
- `expandedHeight`: 展開時のAppBarの高さを設定する（デフォルト: 240.0）。
- `scrollStyle`: スクロール時の動作を設定する（デフォルト: pinned）。
- `titlePosition`: タイトルの位置を設定する（flexible/top/bottom）。
- `backgroundColor`: AppBarの背景色を設定する。
- `foregroundColor`: AppBarの前景色を設定する。
- `expandedForegroundColor`: 展開時の前景色を設定する。

## 注意点

- プロフィールページなどのユーザー情報を表示するページに適している。
- `UniversalScaffold`と組み合わせて使用することで、自動的にSliverWidgetとして動作する。
- `avatarIcon`は通常`CircleAvatar`やカスタムウィジェットを使用する。
- `underBottomActions`はアバター画像の右側に配置されるため、短いテキストのボタンが適している。
- 背景画像を設定する場合は`UniversalAppBarBackground`を使用することを推奨する。
- アバター画像のサイズは展開・縮小に応じて自動的に調整される。
""";
  }
}
