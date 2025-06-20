# `UniversalUI`の一覧とその利用方法

様々な場所で利用可能な`Widget`である`UniversalUI`の一覧とその利用方法を下記に記載する。

## `UniversalUI`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
| `UniversalAppBar` | `AppBar`の`UniversalUI`版。UniversalScaffold`と連携しSliverWidgetへの変換。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`leading`、`title`、`actions`などの基本的なAppBarの機能に加え、`bottom`にウィジェットを追加可能。 | Usage(`documents/rules/universal_ui/universal_app_bar.md`) |
| `UniversalListView` | `ListView`の`UniversalUI`版。UniversalScaffold`と連携しSliverWidgetへの変換。`onRefresh`を設定可能でリストの更新を可能にする。`onLoadNext`を設定可能でリストの追加読み込みを可能にする。`padding`や`decoration`を設定可能でリストの外側に余白やボーダーを設定可能。 | Usage(`documents/rules/universal_ui/universal_list_view.md`) |
| `UniversalColumn` | `Column`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`mainAxisAlignment`、`crossAxisAlignment`などの基本的なColumnの機能に加え、`padding`や`decoration`を設定可能。 | Usage(`documents/rules/universal_ui/universal_column.md`) |
| `UniversalContainer` | `Container`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。`padding`、`margin`、`decoration`などの基本的なContainerの機能に加え、レスポンシブ対応のサイズ設定が可能。 | Usage(`documents/rules/universal_ui/universal_container.md`) |
| `UniversalScaffold` | `Scaffold`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに自動変換。サイドバー、ローディング、ヘッダー・フッター機能を内蔵し、Sliver対応も自動判定。モーダル表示も可能。 | Usage(`documents/rules/universal_ui/universal_scaffold.md`) |
| `UniversalGridView` | `GridView`の`UniversalUI`版。UniversalScaffold`と連携しSliverWidgetへの変換。`onRefresh`を設定可能でグリッドの更新を可能にする。`onLoadNext`を設定可能でグリッドの追加読み込みを可能にする。`padding`や`decoration`を設定可能でグリッドの外側に余白やボーダーを設定可能。 | Usage(`documents/rules/universal_ui/universal_grid_view.md`) |
| `UniversalPadding` | `Padding`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なパディングを自動計算。ブレークポイントに応じてパディングを調整し、中央寄せレイアウトを実現。 | Usage(`documents/rules/universal_ui/universal_padding.md`) |
| `UniversalSearchBar` | `SearchBar`の`UniversalUI`版。検索機能を提供し、検索モードの切り替えやアクションボタンの追加が可能。`FormTextField`を内部で使用し統一されたスタイリングを提供。 | Usage(`documents/rules/universal_ui/universal_search_bar.md`) |
| `UniversalSideBar` | `UniversalScaffold`で使用するサイドバーウィジェット。レスポンシブパディングに対応し、`PreferredSizeWidget`を実装。ListView.builderで子ウィジェットを効率的に表示。 | Usage(`documents/rules/universal_ui/universal_side_bar.md`) |
| `UniversalHeaderTile` | プロフィールなどのヘッダーに用いることのできるタイル。中身としては`ListTile`に同じように利用可能だがリストの上部に配置するようにデザインされている。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。ヘッダーとして使用することを想定したタイル。`leading`、`title`、`trailing`などの基本的なListTileの機能に加え、`onTap`を設定可能。 | Usage(`documents/rules/universal_ui/universal_header_tile.md`) |
| `UniversalEdgeInsets` | `EdgeInsets`の`UniversalUI`版。レスポンシブ対応でデスクトップ・モバイルで適切なレイアウトに変換。ブレークポイントに応じて余白の値を変更可能。 | Usage(`documents/rules/universal_ui/universal_edge_insets.md`) |
