// Project imports:
import "package:katana_cli/ai/docs/katana_ui_usage.dart";

/// Contents of scroll_builder.md.
///
/// scroll_builder.mdの中身。
class KatanaUIScrollBuilderMdCliAiCode extends KatanaUiUsageCliAiCode {
  /// Contents of scroll_builder.md.
  ///
  /// scroll_builder.mdの中身。
  const KatanaUIScrollBuilderMdCliAiCode();

  @override
  String get name => "`ScrollBuilder`の利用方法";

  @override
  String get description =>
      "ListViewやSingleChildScrollViewに簡単にRefreshIndicatorやScrollbarを追加できるウィジェットである`ScrollBuilder`の利用方法。プルトゥリフレッシュとプラットフォーム別スクロールバー機能を提供。";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs/katana_ui";

  @override
  String get excerpt =>
      "ListViewやSingleChildScrollViewに簡単にRefreshIndicatorやScrollbarを追加できるウィジェット。デスクトップやWeb向けの機能も提供。";

  @override
  String body(String baseName, String className) {
    return """
# ScrollBuilder

## 概要

$excerpt

## 特徴

- Pull to Refresh機能の簡単な追加（RefreshIndicator）
- デスクトップ/Web向けのインタラクティブなスクロールバー（Scrollbar）
- カスタム`ScrollController`のサポート
- プラットフォームに応じた適切な動作（PlatformInfoを使用）
- シンプルなビルダーパターン
- 自動ScrollController管理（カスタムコントローラー未指定時）
- デスクトップ/Webでは`interactive: true`、`trackVisibility: true`、`thumbVisibility: true`のスクロールバーを表示

## 基本的な使い方

### シンプルなリストビュー

```dart
ScrollBuilder(
  builder: (context, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("アイテム \$index"),
        );
      },
    );
  },
);
```

## カスタマイズ例

### Pull to Refresh付きリスト

```dart
ScrollBuilder(
  onRefresh: () async {
    // リフレッシュ時の処理
    await Future.delayed(Duration(seconds: 1));
    await refreshData();
  },
  builder: (context, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index].title),
        );
      },
    );
  },
);
```

### カスタムScrollController

```dart
final customController = ScrollController();

ScrollBuilder(
  controller: customController,
  builder: (context, controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          // コンテンツ
        ],
      ),
    );
  },
);
```

### デスクトップ/Web向けスクロールバーの制御

```dart
ScrollBuilder(
  showScrollbarWhenDesktopOrWeb: true,  // デスクトップ/Webでスクロールバーを表示
  builder: (context, controller) {
    return ListView.separated(
      controller: controller,
      itemCount: 50,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("アイテム \$index"),
        );
      },
    );
  },
);
```

### 複雑なスクロール可能なレイアウト

```dart
ScrollBuilder(
  onRefresh: () async {
    await refreshData();
  },
  showScrollbarWhenDesktopOrWeb: true,
  builder: (context, controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.blue[100],
            child: Center(
              child: Text("ヘッダーセクション"),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text("カード \$index"),
                ),
              );
            },
          ),
        ],
      ),
    );
  },
);
```

## 注意点

- `builder`は必須パラメータ
- `builder`には`ScrollController`が自動的に提供される（`controller`未指定時は自動生成）
- `onRefresh`を指定すると自動的に`RefreshIndicator`が追加される
- `showScrollbarWhenDesktopOrWeb`のデフォルトは`true`
- デスクトップ/Webでは`showScrollbarWhenDesktopOrWeb`が`true`の場合、インタラクティブなスクロールバーが表示される
- カスタム`ScrollController`を使用する場合は`controller`パラメータで指定
- `builder`内では必ず提供された`controller`をスクロール可能なウィジェット（ListView、SingleChildScrollViewなど）に設定する必要がある
- スクロールバーはデスクトップ/Webプラットフォームでのみ表示される（`showScrollbarWhenDesktopOrWeb`が`true`の場合）
- `controller`を指定しない場合、内部で自動的に`ScrollController`が生成される（`initState`で初期化）
- ウィジェットツリーの構成は: RefreshIndicator > Scrollbar > builder の順

## 利用シーン

- 通常のListViewの上に`RefreshIndicator`を追加
- `ScrollController`を使用してスクロール位置を制御
- デスクトップ/Webでのみインタラクティブなスクロールバーを表示
""";
  }
}
