part of "/masamune_painter.dart";

/// Display the menu to grouping blocks [PainterTools].
///
/// グループ化するメニューを表示する[PainterTools]。
@immutable
class GroupingGroupPainterBlockTools extends PainterBlockTools {
  /// Display the menu to grouping blocks [PainterTools].
  ///
  /// グループ化するメニューを表示する[PainterTools]。
  const GroupingGroupPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "グループ化",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Grouping",
        ),
      ]),
      icon: Icons.group,
    ),
  });

  @override
  String get id => "__painter_block_group_grouping__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.controller.ungroupedValues.length > 1;
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
    // Create a group from selected values
    ref.controller.createGroupFromSelection();
    ref.deleteMode();
  }
}
