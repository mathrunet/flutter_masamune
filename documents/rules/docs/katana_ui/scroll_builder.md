# `ScrollBuilder`の利用方法

# ScrollBuilder

## 概要

ListViewやSingleChildScrollViewに簡単にRefreshIndicatorやScrollbarを追加できるウィジェット。デスクトップやWeb向けの機能も提供。

## 特徴

- Pull to Refresh機能の簡単な追加
- デスクトップ/Web向けのインタラクティブなスクロールバー
- カスタム`ScrollController`のサポート
- プラットフォームに応じた適切な動作
- シンプルなビルダーパターン

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
          title: Text("アイテム $index"),
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
          title: Text("アイテム $index"),
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
                  title: Text("カード $index"),
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
- `builder`には`ScrollController`が自動的に提供される
- `onRefresh`を指定すると自動的に`RefreshIndicator`が追加される
- デスクトップ/Webでは`showScrollbarWhenDesktopOrWeb`が`true`の場合、インタラクティブなスクロールバーが表示される
- カスタム`ScrollController`を使用する場合は`controller`パラメータで指定
- `builder`内では必ず提供された`controller`をスクロール可能なウィジェットに設定する必要がある
- スクロールバーはデスクトップ/Webプラットフォームでのみ表示される（`showScrollbarWhenDesktopOrWeb`が`true`の場合）

## 利用シーン

- 通常のListViewの上に`RefreshIndicator`を追加
- `ScrollController`を使用してスクロール位置を制御
- デスクトップ/Webでのみインタラクティブなスクロールバーを表示
