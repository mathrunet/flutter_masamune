// Project imports:
import 'package:katana_cli/ai/docs/universal_ui_usage.dart';

/// Contents of universal_side_bar.md.
///
/// universal_side_bar.mdの中身。
class UniversalSideBarMdCliAiCode extends UniversalUiUsageCliAiCode {
  /// Contents of universal_side_bar.md.
  ///
  /// universal_side_bar.mdの中身。
  const UniversalSideBarMdCliAiCode();

  @override
  String get name => "`UniversalSideBar`の利用方法";

  @override
  String get description =>
      "`SideBar`の`UniversalUI`版である`UniversalSideBar`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/universal_ui";

  @override
  String get excerpt =>
      "`UniversalScaffold`で使用するサイドバーウィジェット。レスポンシブパディングに対応し、`PreferredSizeWidget`を実装。ListView.builderで子ウィジェットを効率的に表示。";

  @override
  String body(String baseName, String className) {
    return """
`UniversalSideBar`は下記のように利用する。

## 概要

$excerpt

## 基本的な利用方法

```dart
UniversalSideBar(
  children: [
    const ListTile(
      leading: Icon(Icons.home),
      title: Text("ホーム"),
    ),
    const ListTile(
      leading: Icon(Icons.settings),
      title: Text("設定"),
    ),
    const ListTile(
      leading: Icon(Icons.info),
      title: Text("情報"),
    ),
  ],
);
```

## カスタム幅とパディングの例

```dart
UniversalSideBar(
  width: 300,
  padding: const EdgeInsets.all(16),
  children: [
    const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        "メニュー",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const ListTile(
      leading: Icon(Icons.dashboard),
      title: Text("ダッシュボード"),
    ),
    const ListTile(
      leading: Icon(Icons.analytics),
      title: Text("分析"),
    ),
    const Divider(),
    const ListTile(
      leading: Icon(Icons.logout),
      title: Text("ログアウト"),
    ),
  ],
);
```

## 装飾付きの例

```dart
UniversalSideBar(
  width: 280,
  decoration: BoxDecoration(
    color: Colors.blue[50],
    border: Border(
      right: BorderSide(color: Colors.grey[300]!),
    ),
  ),
  padding: const EdgeInsets.symmetric(vertical: 16),
  children: [
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Text(
        "ナビゲーション",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    ),
    Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.home),
        title: const Text("ホーム"),
        onTap: () {
          // TODO: Implement navigation
        },
      ),
    ),
    Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text("プロフィール"),
        onTap: () {
          // TODO: Implement navigation
        },
      ),
    ),
  ],
);
```

## レスポンシブパディング対応の例

```dart
UniversalSideBar(
  breakpoint: Breakpoint.mobile,
  padding: const EdgeInsets.all(12),
  children: [
    const ListTile(
      leading: Icon(Icons.menu),
      title: Text("メニュー"),
    ),
    const ListTile(
      leading: Icon(Icons.search),
      title: Text("検索"),
    ),
  ],
);
```

## UniversalScaffoldとの組み合わせ

```dart
UniversalScaffold(
  sideBar: UniversalSideBar(
    children: [
      const ListTile(
        leading: Icon(Icons.home),
        title: Text("ホーム"),
      ),
      const ListTile(
        leading: Icon(Icons.settings),
        title: Text("設定"),
      ),
    ],
  ),
  body: const Center(
    child: Text("メインコンテンツ"),
  ),
);
```

## プロパティ

### 必須プロパティ
- `children`: サイドバーに表示するウィジェットのリストを設定する（必須）。

### レイアウト設定
- `width`: サイドバーの幅を設定する（デフォルト: 240.0）。
- `padding`: サイドバー内のパディングを設定する。

### スタイリング
- `decoration`: サイドバーの装飾（背景色、ボーダーなど）を設定する。

### レスポンシブ対応
- `breakpoint`: レスポンシブパディングのブレークポイントを設定する。

## 実装詳細

- `PreferredSizeWidget`を実装し、`preferredSize`は設定された幅に基づいて決定される。
- 内部では`ListView.builder`を使用して子ウィジェットを効率的に表示する。
- `ResponsiveEdgeInsets._responsive`によりレスポンシブパディングが適用される。
- デフォルト幅は`kSideBarWidth`（240.0）で定義される。

## 注意点

- `UniversalScaffold.sideBar`に設定して使用することを想定している。
- `breakpoint`を設定すると、そのブレークポイントの幅に合わせてパディングが自動調整される。
- `children`は必須プロパティで、空のリストでも設定する必要がある。
- レスポンシブ対応により、画面サイズに応じてパディングが自動調整される。
- `decoration`でボーダーや背景色をカスタマイズできる。
- サイドバーの表示/非表示制御は`UniversalScaffold`が自動で行う。
""";
  }
}
