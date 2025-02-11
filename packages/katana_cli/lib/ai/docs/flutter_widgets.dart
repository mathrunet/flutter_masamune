// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of flutter_widgets.mdc.
///
/// flutter_widgets.mdcの中身。
class FlutterWidgetsMdcCliAiCode extends CliAiCode {
  /// Contents of flutter_widgets.mdc.
  ///
  /// flutter_widgets.mdcの中身。
  const FlutterWidgetsMdcCliAiCode();

  @override
  String get name => "主要なFlutterのWidget一覧";

  @override
  String get description => "優先的に利用するFlutterのWidget一覧";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
優先的に利用するFlutterのWidget一覧を下記に記載する。

## 優先的に利用するFlutterのWidget一覧

| Widget | Summary |
| --- | --- |
| `Container` | コンテンツを配置するためのWidget。コンテンツの周りのデコレーションやサイズ、内部の配置や余白を設定することが可能。 |
| `Padding` | コンテンツの周りに余白を設定することが可能。 |
| `SizedBox` | コンテンツのサイズを設定することが可能。 |
| `DecoratedBox` | コンテンツの周りにデコレーションを設定することが可能。 |
| `Align` | コンテンツを配置する位置を設定することが可能。 |
| `Row` | 水平方向にコンテンツを配置することが可能。 |
| `Column` | 垂直方向にコンテンツを配置することが可能。 |
| `Expanded` | `Column`や`Row`の`children`に配置されたコンテンツを拡張して配置することが可能。 |
| `Flexible` | `Column`や`Row`の`children`に配置されたコンテンツを柔軟に配置することが可能。 |
| `Stack` | コンテンツを重ねて配置することが可能。 |
| `Positioned` | `Stack`の`children`に配置されたコンテンツを位置を指定して配置することが可能。 |
| `Wrap` | `Row`のように利用可能であるがコンテンツを折り返して配置することが可能。 |
| `Text` | テキストを表示することが可能。 |
| `Image` | 画像を表示することが可能。 |
| `Icon` | アイコンを表示することが可能。 |
| `IconButton` | アイコンをクリック可能にすることが可能。 |
| `TextButton` | テキストをクリック可能にすることが可能。 |
| `ElevatedButton` | ボタンを表示することが可能。 |
| `OutlinedButton` | ボタンを表示することが可能。 |
| `TextButton` | テキストをクリック可能にすることが可能。 |
| `Chip` | 小さなコンテンツを表示することが可能。 |
| `AspectRatio` | コンテンツのアスペクト比を設定することが可能。 |
| `CircleAvatar` | 円形のコンテンツを表示することが可能。 |
| `ListTile` | リストのアイテムを表示することが可能。 |
| `Card` | カードを表示することが可能。 |
| `BottomNavigationBar` | `Page`の下部に設置しナビゲーション用のボタンを表示することが可能。 |
| `BottomSheet` | モーダルのように利用可能であるがコンテンツを下から表示することが可能。 |
| `TabBar` | タブを表示することが可能。 |
| `TabBarView` | タブの内容を表示することが可能。 |
| `DefaultTextStyle` | テキストのスタイルを設定することが可能。 |
| `IconTheme` | アイコンのスタイルを設定することが可能。 |
| `Theme` | アプリケーション全体のスタイルを設定することが可能。 |
""";
  }
}
