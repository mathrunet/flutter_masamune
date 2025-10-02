part of "/masamune_painter.dart";

/// Show the layer list of painted objects.
///
/// ペイントされているオブジェクトのレイヤーリストを表示します。
class PainterLayerList extends StatefulWidget {
  /// Show the layer list of painted objects.
  ///
  /// ペイントされているオブジェクトのレイヤーリストを表示します。
  const PainterLayerList({
    required this.controller,
    this.shrinkWrap = false,
    this.builder,
    this.hintTextOnChangeName,
    super.key,
  });

  /// Controller for [FormPainterField].
  ///
  /// [FormPainterField]用のコントローラー。
  final PainterController controller;

  /// If this is `true`, the area for scrolling is reduced to only where the content resides.
  ///
  /// これが`true`の場合、スクロールの領域がコンテンツが存在する部分に限定されます。
  final bool shrinkWrap;

  /// Hint text.
  ///
  /// ヒントテキスト。
  final String? hintTextOnChangeName;

  /// Builder to display on the list.
  ///
  /// [context] is passed as [BuildContext], [item] as each element, and [selected] as the selected state of the element.
  ///
  /// リストに表示するためのビルダー。
  ///
  /// [context]に[BuildContext]、[item]に各要素、[selected]に選択状態が渡されます。
  final Widget Function(
      BuildContext context, PaintingValue item, bool selected)? builder;

  @override
  State<PainterLayerList> createState() => _PainterLayerListState();
}

class _PainterLayerListState extends State<PainterLayerList> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(PainterLayerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context);
    return ListBuilder(
      padding: EdgeInsets.zero,
      source: widget.controller.value,
      shrinkWrap: widget.shrinkWrap,
      builder: (context, item, index) {
        final builder = widget.builder;
        final selected = widget.controller.currentValues.contains(item);
        if (builder != null) {
          return [builder(context, item, selected)];
        }
        final tool =
            PainterMasamuneAdapter.findTool(toolId: item.type, recursive: true);
        if (selected) {
          return [
            ListTile(
              leading: item.icon,
              tileColor: Colors.transparent,
              selected: selected,
              selectedTileColor: theme.colorScheme.primary,
              selectedColor: theme.colorScheme.onPrimary,
              title: Text(item.name ?? tool?.config.title.value(locale) ?? ""),
              onTap: () {
                widget.controller.unselect(item);
              },
              trailing: IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Modal.show(
                    context,
                    barrierDismissible: true,
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    modal: ChangeLayerNameModal(
                      initialValue:
                          item.name ?? tool?.config.title.value(locale) ?? "",
                      hintText: widget.hintTextOnChangeName,
                      onChanged: (value) {
                        widget.controller.rename(item, value);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            )
          ];
        } else {
          return [
            ListTile(
              leading: item.icon,
              tileColor: Colors.transparent,
              title: Text(item.name ?? tool?.config.title.value(locale) ?? ""),
              onTap: () {
                widget.controller.select(item);
              },
              trailing: IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Modal.show(
                    context,
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    barrierDismissible: true,
                    modal: ChangeLayerNameModal(
                      initialValue:
                          item.name ?? tool?.config.title.value(locale) ?? "",
                      hintText: widget.hintTextOnChangeName,
                      onChanged: (value) {
                        widget.controller.rename(item, value);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            )
          ];
        }
      },
    );
  }
}
