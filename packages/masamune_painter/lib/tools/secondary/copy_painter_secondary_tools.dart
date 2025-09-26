part of "/masamune_painter.dart";

/// Display the menu to copy drawing data [PainterTools].
///
/// 描画データをコピーするメニューを表示する[PainterTools]。
@immutable
class CopyPainterSecondaryTools extends PainterSecondaryTools {
  /// Display the menu to copy drawing data [PainterTools].
  ///
  /// 描画データをコピーするメニューを表示する[PainterTools]。
  const CopyPainterSecondaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "コピー",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Copy",
        ),
      ]),
      icon: Icons.copy,
    ),
  });

  @override
  String get id => "__painter_copy__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.currentValues.isNotEmpty;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

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
  void onTap(BuildContext context, PainterToolRef ref) {}
}
