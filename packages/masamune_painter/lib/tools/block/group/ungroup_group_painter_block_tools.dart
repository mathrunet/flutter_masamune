part of "/masamune_painter.dart";

/// Display the menu to ungroup blocks [PainterTools].
///
/// グループ化を解除するメニューを表示する[PainterTools]。
@immutable
class UngroupGroupPainterBlockTools extends PainterBlockTools {
  /// Display the menu to ungroup blocks [PainterTools].
  ///
  /// グループ化を解除するメニューを表示する[PainterTools]。
  const UngroupGroupPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "グループ化解除",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Ungroup",
        ),
      ]),
      icon: Icons.workspaces_outline,
    ),
  });

  @override
  String get id => "__painter_block_group_ungroup__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    // Show when at least one selected value is a group
    return ref.controller.currentValues.any((v) => v is GroupPaintingValue);
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool actived(BuildContext context, PainterToolRef ref) => false;

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    // Ungroup all selected groups
    final groupValues =
        ref.controller.currentValues.whereType<GroupPaintingValue>().toList();

    for (final group in groupValues) {
      ref.controller.ungroup(group.id);
    }

    ref.deleteMode();
  }
}
