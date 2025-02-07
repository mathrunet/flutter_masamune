import 'package:katana_cli/ai/docs/universal_ui/universal_app_bar.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_column.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_container.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_edge_insets.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_grid_view.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_header_tile.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_list_view.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_padding.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_scaffold.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_search_bar.dart';
import 'package:katana_cli/ai/docs/universal_ui/universal_side_bar.dart';
import 'package:katana_cli/katana_cli.dart';

/// List of UniversalUI types.
///
/// UniversalUIタイプのリスト。
const kUniversalUiList = {
  "UniversalAppBar": UniversalAppBarMdcCliAiCode(),
  "UniversalListView": UniversalListViewMdcCliAiCode(),
  "UniversalColumn": UniversalColumnMdcCliAiCode(),
  "UniversalContainer": UniversalContainerMdcCliAiCode(),
  "UniversalScaffold": UniversalScaffoldMdcCliAiCode(),
  "UniversalGridView": UniversalGridViewMdcCliAiCode(),
  "UniversalPadding": UniversalPaddingMdcCliAiCode(),
  "UniversalSearchBar": UniversalSearchBarMdcCliAiCode(),
  "UniversalSideBar": UniversalSideBarMdcCliAiCode(),
  "UniversalHeaderTile": UniversalHeaderTileMdcCliAiCode(),
  "UniversalEdgeInsets": UniversalEdgeInsetsMdcCliAiCode(),
};

/// Contents of universal_ui_usage.mdc.
///
/// universal_ui_usage.mdcの中身。
abstract class UniversalUiUsageCliAiCode extends CliAiCode {
  /// Contents of universal_ui_usage.mdc.
  ///
  /// universal_ui_usage.mdcの中身。
  const UniversalUiUsageCliAiCode();

  /// Excerpt of the universal ui.
  ///
  /// UniversalUIの概要。
  String get excerpt;
}

/// Contents of universal_ui_usage.mdc.
///
/// universal_ui_usage.mdcの中身。
class UniversalUiUsageMdcCliAiCode extends CliAiCode {
  /// Contents of universal_ui_usage.mdc.
  ///
  /// universal_ui_usage.mdcの中身。
  const UniversalUiUsageMdcCliAiCode();

  @override
  String get name => "MasamuneフレームワークのUniversalUIの利用方法";

  @override
  String get description => "Masamuneフレームワーク特有のタイプであるUniversalUIの利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
Masamuneフレームワークにおいて様々な場所で利用可能なタイプである`UniversalUI`の一覧と利用方法を下記に記載する。

## `UniversalUI`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
""";
    for (final entry in kUniversalUiList.entries) {
      header +=
          "| `${entry.key}` | ${entry.value.excerpt} | [Usage](mdc:.cursor/rules/universal_ui/${entry.key.toSnakeCase()}.mdc) |\n";
    }
    return header;
  }
}
