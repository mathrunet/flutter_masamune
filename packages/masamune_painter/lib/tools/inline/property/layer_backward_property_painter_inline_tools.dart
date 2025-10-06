part of "/masamune_painter.dart";

const _kLayerBackwardPropertyPainterInlineToolsId =
    "__painter_property_layer_backward__";

/// Display layer backward property [PainterTools].
///
/// Move selected layers one step backward (towards back).
///
/// レイヤーを奥に移動するプロパティを表示する[PainterTools]。
///
/// 選択したレイヤーを1つ奥に移動します。
@immutable
class LayerBackwardPropertyPainterInlineTools
    extends PainterInlinePrimaryTools {
  /// Display layer backward property [PainterTools].
  ///
  /// Move selected layers one step backward (towards back).
  ///
  /// レイヤーを奥に移動するプロパティを表示する[PainterTools]。
  ///
  /// 選択したレイヤーを1つ奥に移動します。
  const LayerBackwardPropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "背面へ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Send Backward",
        ),
      ]),
      icon: Icons.flip_to_back,
    ),
    this.blockTools = const [],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => _kLayerBackwardPropertyPainterInlineToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentValues.isNotEmpty;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) {
    // Check if any selected layer can move backward
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

    // Can move backward if the backmost selected item is not already at the back
    selectedIndices.sort();
    final backmostIndex = selectedIndices.first;
    return backmostIndex > 0;
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
    ref.controller.moveSelectedLayersBackward();
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
