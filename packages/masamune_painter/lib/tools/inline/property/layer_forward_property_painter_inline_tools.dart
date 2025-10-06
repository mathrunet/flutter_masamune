part of "/masamune_painter.dart";

const _kLayerForwardPropertyPainterInlineToolsId =
    "__painter_property_layer_forward__";

/// Display layer forward property [PainterTools].
///
/// Move selected layers one step forward (towards front).
///
/// レイヤーを手前に移動するプロパティを表示する[PainterTools]。
///
/// 選択したレイヤーを1つ手前に移動します。
@immutable
class LayerForwardPropertyPainterInlineTools extends PainterInlinePrimaryTools {
  /// Display layer forward property [PainterTools].
  ///
  /// Move selected layers one step forward (towards front).
  ///
  /// レイヤーを手前に移動するプロパティを表示する[PainterTools]。
  ///
  /// 選択したレイヤーを1つ手前に移動します。
  const LayerForwardPropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "前面へ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Bring Forward",
        ),
      ]),
      icon: Icons.flip_to_front,
    ),
    this.blockTools = const [],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => _kLayerForwardPropertyPainterInlineToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentValues.isNotEmpty;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) {
    // Check if any selected layer can move forward
    final selectedIndices = <int>[];
    for (final currentValue in ref.controller.currentValues) {
      final index =
          ref.controller.value.indexWhere((v) => v.id == currentValue.id);
      if (index >= 0) {
        selectedIndices.add(index);
      }
    }

    if (selectedIndices.isEmpty) {
      return false;
    }

    // Can move forward if the frontmost selected item is not already at the front
    selectedIndices.sort((a, b) => b.compareTo(a));
    final frontmostIndex = selectedIndices.first;
    return frontmostIndex < ref.controller.value.length - 1;
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
    ref.controller.moveSelectedLayersForward();
  }

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    // Execute the action
    onTap(context, ref);
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    // Do nothing
  }
}
