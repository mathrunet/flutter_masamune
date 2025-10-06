part of "/masamune_painter.dart";

/// Display the menu to create clipping group blocks [PainterTools].
///
/// クリッピンググループを作成するメニューを表示する[PainterTools]。
@immutable
class ClipplingGroupPainterBlockTools extends PainterBlockTools {
  /// Display the menu to create clipping group blocks [PainterTools].
  ///
  /// クリッピンググループを作成するメニューを表示する[PainterTools]。
  const ClipplingGroupPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "クリッピンググループ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Clipping Group",
        ),
      ]),
      icon: Icons.crop,
    ),
  });

  @override
  String get id => "__painter_block_group_clipping__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    // Show when at least 2 values are selected
    final ungroupedValues = ref.controller.currentUngroupedValues;
    if (ungroupedValues.length < 2) {
      return false;
    }

    // Find the frontmost item in layer order (not selection order)
    // _values[0] is the backmost, _values[length-1] is the frontmost
    // Check if there's at least one RectanglePaintingValue among selected items
    var hasFrontmostShape = false;
    var maxIndex = -1;

    for (final value in ungroupedValues) {
      final index = ref.controller.value.indexWhere((v) => v.id == value.id);
      if (index >= 0 && index > maxIndex && value is RectanglePaintingValue) {
        maxIndex = index;
        hasFrontmostShape = true;
      }
    }

    return hasFrontmostShape;
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
    // Create a clipping group from selected values
    ref.controller.createClippingGroupFromSelection();
    ref.deleteMode();
  }
}
