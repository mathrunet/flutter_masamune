// Project imports:
import "package:katana_cli/ai/docs/katana_ui/avatar_tile.dart";
import "package:katana_cli/ai/docs/katana_ui/cached_image_builder.dart";
import "package:katana_cli/ai/docs/katana_ui/card_tile.dart";
import "package:katana_cli/ai/docs/katana_ui/chat_tile.dart";
import "package:katana_cli/ai/docs/katana_ui/indent.dart";
import "package:katana_cli/ai/docs/katana_ui/label.dart";
import "package:katana_cli/ai/docs/katana_ui/line_tile.dart";
import "package:katana_cli/ai/docs/katana_ui/list_tile_group.dart";
import "package:katana_cli/ai/docs/katana_ui/loading_builder.dart";
import "package:katana_cli/ai/docs/katana_ui/message_box.dart";
import "package:katana_cli/ai/docs/katana_ui/periodic_scope.dart";
import "package:katana_cli/ai/docs/katana_ui/scroll_builder.dart";
import "package:katana_cli/ai/docs/katana_ui/shimmer.dart";
import "package:katana_cli/ai/docs/katana_ui/sns_content_tile.dart";
import "package:katana_cli/ai/docs/katana_ui/sns_image.dart";
import "package:katana_cli/ai/docs/katana_ui/square_avatar.dart";
import "package:katana_cli/katana_cli.dart";

/// List of KatanaUI types.
///
/// KatanaUIタイプのリスト。
const kKatanaUiList = {
  "AvatarTile": KatanaUIAvatarTileMdCliAiCode(),
  "CardTile": KatanaUICardTileMdCliAiCode(),
  "ChatTile": KatanaUIChatTileMdCliAiCode(),
  "Indent": KatanaUIIndentMdCliAiCode(),
  "Label": KatanaUILabelMdCliAiCode(),
  "LineTile": KatanaUILineTileMdCliAiCode(),
  "ListTileGroup": KatanaUIListTileGroupMdCliAiCode(),
  "LoadingBuilder": KatanaUILoadingBuilderMdCliAiCode(),
  "MessageBox": KatanaUIMessageBoxMdCliAiCode(),
  "PeriodicScope": KatanaUIPeriodicScopeMdCliAiCode(),
  "ScrollBuilder": KatanaUIScrollBuilderMdCliAiCode(),
  "Shimmer": KatanaUIShimmerMdCliAiCode(),
  "SquareAvatar": KatanaUISquareAvatarMdCliAiCode(),
  "SnsContentTile": KatanaUISnsContentTileMdCliAiCode(),
  "SnsImage": KatanaUISnsImageMdCliAiCode(),
  "CachedImageBuilder": KatanaUICachedImageBuilderMdCliAiCode(),
};

/// Contents of katana_ui_usage.md.
///
/// katana_ui_usage.mdの中身。
abstract class KatanaUiUsageCliAiCode extends CliAiCode {
  /// Contents of katana_ui_usage.md.
  ///
  /// katana_ui_usage.mdの中身。
  const KatanaUiUsageCliAiCode();

  /// Excerpt of the katana ui.
  ///
  /// KatanaUIの概要。
  String get excerpt;
}

/// Contents of katana_ui_usage.md.
///
/// katana_ui_usage.mdの中身。
class KatanaUiUsageMdCliAiCode extends CliAiCode {
  /// Contents of katana_ui_usage.md.
  ///
  /// katana_ui_usage.mdの中身。
  const KatanaUiUsageMdCliAiCode();

  @override
  String get name => "`KatanaUI`の一覧とその利用方法";

  @override
  String get description => "様々な場所で利用可能な`Widget`である`KatanaUI`の一覧とその利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
様々な場所で利用可能な`Widget`である`KatanaUI`の一覧とその利用方法を下記に記載する。

## `KatanaUI`の一覧

| Class | Summary | Usage |
| --- | --- | --- |
""";
    for (final entry in kKatanaUiList.entries) {
      header +=
          "| `${entry.key}` | ${entry.value.excerpt} | Usage(`documents/rules/katana_ui/${entry.key.toSnakeCase()}.md`) |\n";
    }
    return header;
  }
}
