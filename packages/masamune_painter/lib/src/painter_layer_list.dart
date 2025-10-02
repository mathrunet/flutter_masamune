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
    final items = widget.controller.value;

    return ReorderableListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: widget.shrinkWrap,
      itemCount: items.length,
      onReorder: (oldIndex, newIndex) {
        widget.controller.reorder(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final item = items[index];
        final builder = widget.builder;
        final selected = widget.controller.currentValues.contains(item);

        // Custom builder
        if (builder != null) {
          return _buildReorderableItem(
            key: ValueKey(item.id),
            child: builder(context, item, selected),
          );
        }

        // Default builder
        final tool =
            PainterMasamuneAdapter.findTool(toolId: item.type, recursive: true);

        return _buildReorderableItem(
          key: ValueKey(item.id),
          child: ListTile(
            leading: item.icon,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(
                    Icons.drag_handle,
                    size: 24,
                  ),
                ),
              ],
            ),
            tileColor: Colors.transparent,
            selected: selected,
            selectedTileColor: theme.colorScheme.primary,
            selectedColor: selected
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child:
                      Text(item.name ?? tool?.config.title.value(locale) ?? ""),
                ),
                16.sx,
                InkWell(
                  onTap: () {
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
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.edit, size: 12),
                  ),
                ),
              ],
            ),
            onTap: () {
              if (selected) {
                widget.controller.unselect(item);
              } else {
                widget.controller.select(item);
              }
            },
          ),
        );
      },
    );
  }

  /// Builds a reorderable item with proper key.
  ///
  /// This wrapper is designed to support future group functionality
  /// where items can be nested.
  ///
  /// 適切なキーを持つ並べ替え可能なアイテムを構築します。
  ///
  /// このラッパーは、将来的なグループ機能をサポートするために設計されており、
  /// アイテムをネストすることができます。
  Widget _buildReorderableItem({
    required Key key,
    required Widget child,
  }) {
    return Container(
      key: key,
      child: child,
    );
  }
}
