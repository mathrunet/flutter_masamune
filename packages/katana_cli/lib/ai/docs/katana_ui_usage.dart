import 'package:katana_cli/ai/docs/katana_ui/avatar_tile.dart';
import 'package:katana_cli/ai/docs/katana_ui/card_tile.dart';
import 'package:katana_cli/ai/docs/katana_ui/chat_tile.dart';
import 'package:katana_cli/ai/docs/katana_ui/indent.dart';
import 'package:katana_cli/ai/docs/katana_ui/label.dart';
import 'package:katana_cli/ai/docs/katana_ui/line_tile.dart';
import 'package:katana_cli/ai/docs/katana_ui/list_tile_group.dart';
import 'package:katana_cli/ai/docs/katana_ui/loading_builder.dart';
import 'package:katana_cli/ai/docs/katana_ui/message_box.dart';
import 'package:katana_cli/ai/docs/katana_ui/periodic_scope.dart';
import 'package:katana_cli/ai/docs/katana_ui/scroll_builder.dart';
import 'package:katana_cli/ai/docs/katana_ui/shimmer.dart';
import 'package:katana_cli/ai/docs/katana_ui/square_avatar.dart';
import 'package:katana_cli/katana_cli.dart';

/// List of KatanaUI types.
///
/// KatanaUIタイプのリスト。
const kKatanaUiList = {
  "AvatarTile": KatanaUIAvatarTileMdcCliAiCode(),
  "CardTile": KatanaUICardTileMdcCliAiCode(),
  "ChatTile": KatanaUIChatTileMdcCliAiCode(),
  "Indent": KatanaUIIndentMdcCliAiCode(),
  "Label": KatanaUILabelMdcCliAiCode(),
  "LineTile": KatanaUILineTileMdcCliAiCode(),
  "ListTileGroup": KatanaUIListTileGroupMdcCliAiCode(),
  "LoadingBuilder": KatanaUILoadingBuilderMdcCliAiCode(),
  "MessageBox": KatanaUIMessageBoxMdcCliAiCode(),
  "PeriodicScope": KatanaUIPeriodicScopeMdcCliAiCode(),
  "ScrollBuilder": KatanaUIScrollBuilderMdcCliAiCode(),
  "Shimmer": KatanaUIShimmerMdcCliAiCode(),
  "SquareAvatar": KatanaUISquareAvatarMdcCliAiCode(),
};

/// Contents of katana_ui_usage.mdc.
///
/// katana_ui_usage.mdcの中身。
abstract class KatanaUiUsageCliAiCode extends CliAiCode {
  /// Contents of katana_ui_usage.mdc.
  ///
  /// katana_ui_usage.mdcの中身。
  const KatanaUiUsageCliAiCode();

  /// Excerpt of the katana ui.
  ///
  /// KatanaUIの概要。
  String get excerpt;
}

/// Contents of katana_ui_usage.mdc.
///
/// katana_ui_usage.mdcの中身。
class KatanaUiUsageMdcCliAiCode extends CliAiCode {
  /// Contents of katana_ui_usage.mdc.
  ///
  /// katana_ui_usage.mdcの中身。
  const KatanaUiUsageMdcCliAiCode();

  @override
  String get name => "MasamuneフレームワークのKatanaUIの利用方法";

  @override
  String get description => "Masamuneフレームワーク特有のタイプであるKatanaUIの利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
Masamuneフレームワークにおいて様々な場所で利用可能なタイプである`KatanaUI`の一覧と利用方法を下記に記載する。

## `KatanaUI`の一覧

| Class | Summary | Usage |
| --- | --- | --- |""";
    for (final entry in kKatanaUiList.entries) {
      header +=
          "| ${entry.key} | ${entry.value.excerpt} | [Usage](mdc:.cursor/rules/katana_ui/${entry.key.toSnakeCase()}.mdc) |\n";
    }
    return header;
  }
}
