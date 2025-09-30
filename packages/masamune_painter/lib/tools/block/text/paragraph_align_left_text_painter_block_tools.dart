part of "/masamune_painter.dart";

/// Display the menu to draw a left align [PainterTools].
///
/// 左寄せを描画するメニューを表示する[PainterTools]。
@immutable
class ParagraphAlignLeftTextPainterBlockTools
    extends PainterParagraphAlignBlockTools {
  /// Display the menu to draw a left align [PainterTools].
  ///
  /// 左寄せを描画するメニューを表示する[PainterTools]。
  const ParagraphAlignLeftTextPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "左寄せ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Left Align",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_text_paragraph_align_left__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueLine == this;
    } else {
      return ref.controller.property.currentToolLine == this;
    }
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    // TODO: implement icon
    throw UnimplementedError();
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  ui.TextAlign get paragraphAlign => ui.TextAlign.left;
}
