// Project imports:
import "package:katana_cli/ai/docs/universal_ui/responsive_edge_insets.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_app_bar.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_column.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_container.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_grid_view.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_header_tile.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_list_view.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_padding.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_scaffold.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_search_bar.dart";
import "package:katana_cli/ai/docs/universal_ui/universal_side_bar.dart";
import "package:katana_cli/katana_cli.dart";

/// List of UniversalUI types.
///
/// UniversalUIタイプのリスト。
const kUniversalUiList = {
  "UniversalAppBar": UniversalAppBarMdCliAiCode(),
  "UniversalListView": UniversalListViewMdCliAiCode(),
  "UniversalColumn": UniversalColumnMdCliAiCode(),
  "UniversalContainer": UniversalContainerMdCliAiCode(),
  "UniversalScaffold": UniversalScaffoldMdCliAiCode(),
  "UniversalGridView": UniversalGridViewMdCliAiCode(),
  "UniversalPadding": UniversalPaddingMdCliAiCode(),
  "UniversalSearchBar": UniversalSearchBarMdCliAiCode(),
  "UniversalSideBar": UniversalSideBarMdCliAiCode(),
  "UniversalHeaderTile": UniversalHeaderTileMdCliAiCode(),
  "UniversalEdgeInsets": UniversalEdgeInsetsMdCliAiCode(),
};

/// Contents of universal_ui_usage.md.
///
/// universal_ui_usage.mdの中身。
abstract class UniversalUiUsageCliAiCode extends CliAiCode {
  /// Contents of universal_ui_usage.md.
  ///
  /// universal_ui_usage.mdの中身。
  const UniversalUiUsageCliAiCode();

  /// Excerpt of the universal ui.
  ///
  /// UniversalUIの概要。
  String get excerpt;
}

/// Contents of universal_ui_usage.md.
///
/// universal_ui_usage.mdの中身。
class UniversalUiUsageMdCliAiCode extends CliAiCode {
  /// Contents of universal_ui_usage.md.
  ///
  /// universal_ui_usage.mdの中身。
  const UniversalUiUsageMdCliAiCode();

  @override
  String get name => "`UniversalUI`の一覧とその利用方法";

  @override
  String get description => "様々な場所で利用可能な`Widget`である`UniversalUI`の一覧とその利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
様々な場所で利用可能な`Widget`である`UniversalUI`の一覧とその利用方法を下記に記載する。

## `UniversalUI`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
""";
    for (final entry in kUniversalUiList.entries) {
      header +=
          "| `${entry.key}` | ${entry.value.excerpt} | Usage(`documents/rules/universal_ui/${entry.key.toSnakeCase()}.md`) |\n";
    }
    return header;
  }
}
