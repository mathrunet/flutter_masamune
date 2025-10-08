# `KatanaUI`の一覧とその利用方法

様々な場所で利用可能な`Widget`である`KatanaUI`の一覧とその利用方法を下記に記載する。

## `KatanaUI`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
| `AvatarTile` | プロフィールなどの概要を表示するためのタイル。アバター画像、タイトル、サブタイトル、説明文を含むカスタマイズ可能なプロフィールカード。 | Usage(`documents/rules/katana_ui/avatar_tile.md`) |
| `CardTile` | カードウィジェットの上に画像やテキストを重ねて表示するためのウィジェット。ListTileと組み合わせて使用する高機能なカードコンポーネント。 | Usage(`documents/rules/katana_ui/card_tile.md`) |
| `ChatTile` | チャットの吹き出しを作成するためのウィジェット。メッセージの配置や見た目をカスタマイズ可能で、自分と相手のメッセージを視覚的に区別できる。 | Usage(`documents/rules/katana_ui/chat_tile.md`) |
| `Indent` | ColumnやListViewの中で、要素間にパディングを設定しながら複数の要素を縦に配置するためのウィジェット。 | Usage(`documents/rules/katana_ui/indent.md`) |
| `Label` | 項目のタイトルなどで使うラベルを表示するためのウィジェット。アイコンやテキストを組み合わせて使用可能。 | Usage(`documents/rules/katana_ui/label.md`) |
| `LineTile` | `ListTile`に`text`プロパティを追加したもの、textプロパティにWidgetを設定するとtitleの右側に表示される。 | Usage(`documents/rules/katana_ui/line_tile.md`) |
| `ListTileGroup` | `ListTile`や`LineTile`をグループ化して表示するためのウィジェット。タイル間の区切り線やスタイリングをカスタマイズ可能。 | Usage(`documents/rules/katana_ui/list_tile_group.md`) |
| `LoadingBuilder` | 複数の`Future`を待機し、完了するまでローディング表示を行うビルダー。カスタマイズ可能なローディングインジケータを提供。 | Usage(`documents/rules/katana_ui/loading_builder.md`) |
| `MessageBox` | ユーザーに伝えるメッセージを表示するためのボックスウィジェット。アイコン、メッセージ、アクションを含むカスタマイズ可能なメッセージボックス。 | Usage(`documents/rules/katana_ui/message_box.md`) |
| `PeriodicScope` | 一定時間ごとに自動的に再描画を行うウィジェット。タイマーやカウントダウン、定期的な更新が必要なUIに最適。 | Usage(`documents/rules/katana_ui/periodic_scope.md`) |
| `ScrollBuilder` | ListViewやSingleChildScrollViewに簡単にRefreshIndicatorやScrollbarを追加できるウィジェット。デスクトップやWeb向けの機能も提供。 | Usage(`documents/rules/katana_ui/scroll_builder.md`) |
| `Shimmer` | ローディング状態を表現するためのシマーエフェクトを提供するウィジェット。単一行と複数行のシマーエフェクトに対応。 | Usage(`documents/rules/katana_ui/shimmer.md`) |
| `SquareAvatar` | `CircleAvatar`の四角版として使用可能なウィジェット。角丸調整可能な四角形・角丸四角形のアバター表示を提供し、背景色と背景画像をレイヤーシステムでサポート。 | Usage(`documents/rules/katana_ui/square_avatar.md`) |
| `SnsContentTile` | SNSのコンテンツを表示するウィジェット。プロフィールアバター、ユーザー名、ハンドル/タイムスタンプ、投稿内容、アクションボタンを含むソーシャルメディアスタイルの投稿レイアウトを提供。 | Usage(`documents/rules/katana_ui/sns_content_tile.md`) |
| `SnsImage` | SNSスタイルのレイアウトで複数の画像を表示するウィジェット。画像枚数に応じて自動的に最適なグリッドレイアウトを適用し、タップイベントにも対応。 | Usage(`documents/rules/katana_ui/sns_image.md`) |
