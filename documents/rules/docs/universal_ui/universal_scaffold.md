# `UniversalScaffold`の利用方法

`UniversalScaffold`は下記のように利用する。

## 概要

`Scaffold`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに自動変換。サイドバー、ローディング、ヘッダー・フッター機能を内蔵し、Sliver対応も自動判定。モーダル表示も可能。

## 基本的な利用方法

```dart
UniversalScaffold(
  appBar: UniversalAppBar(
    title: const Text("アプリタイトル"),
  ),
  body: const Center(
    child: Text("コンテンツ"),
  ),
  bottomNavigationBar: BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "ホーム",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: "設定",
      ),
    ],
    onTap: (index) {
      // TODO: Implement the navigation action.
    },
  ),
);
```

## サイドバー付きの例

```dart
UniversalScaffold(
  appBar: UniversalAppBar(
    title: const Text("サイドバー付きアプリ"),
  ),
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
      const ListTile(
        leading: Icon(Icons.info),
        title: Text("情報"),
      ),
    ],
  ),
  body: const Center(
    child: Text("メインコンテンツ"),
  ),
);
```

## カスタムサイドバーの例

```dart
UniversalScaffold(
  appBar: UniversalAppBar(
    title: const Text("カスタムサイドバー"),
  ),
  sideBar: UniversalSideBar(
    width: 300,
    decoration: BoxDecoration(
      color: Colors.blue[50],
      border: Border(
        right: BorderSide(color: Colors.grey[300]!),
      ),
    ),
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
      Card(
        child: ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text("ダッシュボード"),
          onTap: () {
            // TODO: Implement navigation
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text("分析"),
          onTap: () {
            // TODO: Implement navigation
          },
        ),
      ),
    ],
  ),
  body: const Center(
    child: Text("メインコンテンツ"),
  ),
);
```

## ローディング機能付きの例

```dart
UniversalScaffold(
  appBar: UniversalAppBar(
    title: const Text("ローディング付きアプリ"),
  ),
  loadingFutures: [
    Future.delayed(const Duration(seconds: 2)),
    apiCall(),
  ],
  loadingWidget: const CircularProgressIndicator(),
  body: const Text("データ読み込み完了"),
);
```

## ヘッダー・フッター付きの例

```dart
UniversalScaffold(
  appBar: UniversalAppBar(
    title: const Text("ヘッダー・フッター付き"),
  ),
  header: Container(
    height: 60,
    color: Colors.blue[50],
    child: const Center(
      child: Text("ヘッダー領域"),
    ),
  ),
  body: const Center(
    child: Text("メインコンテンツ"),
  ),
  footer: Container(
    height: 40,
    color: Colors.grey[100],
    child: const Center(
      child: Text("フッター領域"),
    ),
  ),
);
```

## モーダル表示の例

```dart
/// Page widget for Modal.
@immutable
@PagePath("modal", transition: TransitionQuery.centerModal)
class ModalPage extends PageScopedWidget {
  const ModalPage({
    super.key,
  });

  @pageRouteQuery
  static const query = _$ModalPageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    return UniversalScaffold(
      width: 600,
      height: 400,
      borderRadius: BorderRadius.circular(12),
      alignment: Alignment.center,
      appBar: UniversalAppBar(
        title: const Text("モーダル"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("モーダルコンテンツ"),
            SizedBox(height: 16),
            Text("ページとして作成されたモーダル"),
          ],
        ),
      ),
    );
  }
}
```

## Sliverスクロール対応の例

```dart
UniversalScaffold(
  appBar: UniversalSliverAppBar(
    title: const Text("Sliverアプリ"),
    expandedHeight: 200.0,
    background: Container(color: Colors.blue),
  ),
  body: UniversalListView(
    children: [
      ...List.generate(50, (index) => 
        ListTile(title: Text("アイテム ${index + 1}"))
      ),
    ],
  ),
);
```

## トランジション待機の例

```dart
UniversalScaffold(
  appBar: UniversalAppBar(
    title: const Text("スムーズアニメーション"),
  ),
  waitTransition: true,
  body: const ExpensiveWidget(),
);
```

## プロパティ

### 基本プロパティ
- `appBar`: アプリケーションバーを設定する（UniversalAppBar、SliverAppBar、AppBar対応）。
- `body`: メインコンテンツを設定する。
- `drawer`: ドロワーメニューを設定する。
- `endDrawer`: 右側のドロワーメニューを設定する。
- `bottomNavigationBar`: 下部のナビゲーションバーを設定する。
- `floatingActionButton`: フローティングアクションボタンを設定する。
- `backgroundColor`: 背景色を設定する。

### レスポンシブ・レイアウト関連
- `breakpoint`: レスポンシブ対応のブレークポイントを設定する。
- `sideBar`: サイドバーを設定する（UniversalSideBarを推奨）。
- `sideBarOnDrawerAlways`: サイドバーを常にドロワーに配置するかどうかを設定する。

### 拡張レイアウト機能
- `header`: bodyの上部に表示するウィジェットを設定する。
- `footer`: bodyの下部に表示するウィジェットを設定する。

### ローディング機能
- `loadingFutures`: 完了を待つFutureのリストを設定する。
- `loadingWidget`: ローディング中に表示するウィジェットを設定する。

### パフォーマンス・アニメーション
- `waitTransition`: トランジションアニメーション中にbodyの表示を待機するかどうかを設定する。

### モーダル表示機能
- `width`: UniversalScaffold自体の幅を設定する（モーダル表示用）。
- `height`: UniversalScaffold自体の高さを設定する（モーダル表示用）。
- `alignment`: UniversalScaffold自体の配置を設定する（モーダル表示用）。
- `borderRadius`: 四隅の角丸を設定する（モーダル表示用）。

### その他のScaffoldプロパティ
- `resizeToAvoidBottomInset`: キーボード表示時の自動リサイズを設定する。
- `persistentFooterButtons`: 永続的なフッターボタンを設定する。
- `bottomSheet`: 下部シートを設定する。
- `drawerScrimColor`: ドロワーのスクリム色を設定する。

## UniversalSideBarのプロパティ

`sideBar`に設定する`UniversalSideBar`の主要プロパティ：

- `children`: サイドバーに表示するウィジェットのリストを設定する。
- `width`: サイドバーの幅を設定する（デフォルト: 240.0）。
- `decoration`: サイドバーの装飾（背景色、ボーダーなど）を設定する。
- `padding`: サイドバー内のパディングを設定する。
- `breakpoint`: レスポンシブパディングのブレークポイントを設定する。

## サイドバーの自動配置

ブレークポイントに応じてサイドバーが自動配置されます：
- `デスクトップ`: サイドバーが左側に固定表示
- `モバイル`: サイドバーがドロワーに移動

```dart
// デスクトップでは左側に固定、モバイルではドロワーに自動配置
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
  body: const MainContent(),
);
```

## Sliver自動判定

AppBarのタイプに応じてSliver対応が自動判定されます：
- `UniversalSliverAppBar`や`SliverAppBar`: Sliverスクロール
- `UniversalAppBar`や`AppBar`: 通常のスクロール

## 注意点

- `sideBar`はレスポンシブ対応により、画面サイズに応じて自動配置される。
- `loadingFutures`指定時は、すべてのFutureが完了するまでローディング表示される。
- `waitTransition`を有効にすると、画面遷移がスムーズになるが初期表示が少し遅れる。
- モーダル表示時は`width`、`height`、`borderRadius`を適切に設定する。
- Sliver対応は`appBar`のタイプにより自動判定される。
- `header`と`footer`は`body`を囲むように配置される。
- デスクトップでは`bottomNavigationBar`が非表示になる場合がある。
