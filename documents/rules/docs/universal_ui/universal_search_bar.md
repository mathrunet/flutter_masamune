# `UniversalSearchBar`の利用方法

`UniversalSearchBar`は下記のように利用する。

## 概要

`SearchBar`の`UniversalUI`版。検索機能を提供し、検索モードの切り替えやアクションボタンの追加が可能。`FormTextField`を内部で使用し統一されたスタイリングを提供。

## 基本的な利用方法

```dart
UniversalSearchBar(
  hintText: "検索キーワードを入力",
  onSearch: (text, mode) {
    // TODO: Implement the search action.
    print("検索テキスト: $text");
  },
  onChanged: (text) {
    // TODO: Implement the text changed action.
    print("入力中: $text");
  },
  searchIcon: const Icon(Icons.search),
  actions: [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        // TODO: Implement the clear action.
      },
    ),
  ],
);
```

## 検索モード付きの例

```dart
enum SearchMode { all, title, content }

UniversalSearchBar<SearchMode>(
  hintText: "検索",
  defaultSearchMode: SearchMode.all,
  searchModeList: SearchMode.values,
  searchModeLabelBuilder: (mode) {
    switch (mode) {
      case SearchMode.all:
        return const Text("すべて");
      case SearchMode.title:
        return const Text("タイトル");
      case SearchMode.content:
        return const Text("内容");
    }
  },
  onSearch: (text, mode) {
    // TODO: Implement the search action with mode.
    print("検索: $text, モード: $mode");
  },
);
```

## カスタムスタイリングの例

```dart
UniversalSearchBar(
  hintText: "検索",
  backgroundColor: Colors.grey[100],
  foregroundColor: Colors.black87,
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.symmetric(horizontal: 12),
  contentPadding: const EdgeInsets.symmetric(vertical: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  onSearch: (text, mode) {
    // TODO: Implement the search action.
  },
);
```

## コントローラー使用の例

```dart
final searchController = TextEditingController();

UniversalSearchBar(
  controller: searchController,
  initialValue: "初期検索値",
  autofocus: true,
  hintText: "検索",
  onSearch: (text, mode) {
    // TODO: Implement the search action.
  },
  actions: [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        searchController.clear();
      },
    ),
    IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        // TODO: Implement filter action.
      },
    ),
  ],
);
```

## プロパティ

### 基本プロパティ
- `hintText`: 検索バーのプレースホルダーテキストを設定する。
- `initialValue`: 初期値を設定する。
- `controller`: テキストコントローラーを設定する。
- `autofocus`: オートフォーカスするかどうかを設定する（デフォルト: false）。

### コールバック
- `onSearch`: 検索実行時のコールバック。テキストと選択中の検索モードが渡される。
- `onChanged`: テキスト変更時のコールバック。

### 検索モード関連
- `defaultSearchMode`: デフォルトの検索モードを設定する。
- `searchModeList`: 検索モードのリストを設定する。
- `searchModeLabelBuilder`: 検索モードのラベルを生成するビルダーを設定する。

### UIカスタマイズ
- `searchIcon`: 検索アイコンを設定する（デフォルト: Icon(Icons.search)）。
- `actions`: 検索バーの右側に表示するアクションボタンのリストを設定する。
- `backgroundColor`: 背景色を設定する。
- `foregroundColor`: 前景色（テキストやアイコンの色）を設定する。

### レイアウト・スタイリング
- `margin`: 検索バー全体のマージンを設定する。
- `padding`: 検索バー内のパディングを設定する。
- `contentPadding`: テキストフィールドのコンテンツパディングを設定する。
- `decoration`: 検索バーの装飾を設定する。
- `textStyle`: テキストスタイルを設定する。

## 注意点

- `searchModeList`を設定する場合は、必ず`searchModeLabelBuilder`も設定する必要がある。
- `onSearch`コールバックには検索テキストと現在の検索モードの両方が渡される。
- 検索は検索アイコンをタップするか、Enterキーを押すことで実行される。
- `onChanged`は文字が入力される度に呼び出される。
- 内部で`FormTextField`を使用しているため、Masamuneの統一されたフォームスタイルが適用される。
- 複数の`actions`を設定することで、検索以外の機能を追加できる。
- 検索モードが設定されている場合、モード選択用のチェックボックスが検索バーの下に表示される。
