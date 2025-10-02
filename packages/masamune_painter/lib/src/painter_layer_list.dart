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

    // Build flat list with groups and their children
    final flatList = _buildFlatList(items);

    return ReorderableListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: widget.shrinkWrap,
      itemCount: flatList.length,
      onReorder: (oldIndex, newIndex) {
        final oldItem = flatList[oldIndex];
        final newItem = flatList[newIndex];

        // Find actual indices in the main list
        final actualOldIndex = items.indexWhere((v) => v.id == oldItem.item.id);
        final actualNewIndex = items.indexWhere((v) => v.id == newItem.item.id);

        if (actualOldIndex >= 0 && actualNewIndex >= 0) {
          widget.controller.reorder(actualOldIndex, actualNewIndex);
        }
      },
      itemBuilder: (context, index) {
        final flatItem = flatList[index];
        final item = flatItem.item;
        final depth = flatItem.depth;
        final isGroupChild = flatItem.isGroupChild;

        final builder = widget.builder;
        final selected =
            widget.controller.currentValues.any((v) => v.id == item.id);

        // Custom builder
        if (builder != null) {
          return _buildReorderableItem(
            key: ValueKey(item.id),
            child: builder(context, item, selected),
          );
        }

        // Default builder
        return _buildLayerItem(
          context: context,
          theme: theme,
          locale: locale,
          item: item,
          index: index,
          depth: depth,
          isGroupChild: isGroupChild,
          selected: selected,
        );
      },
    );
  }

  /// Build flat list from hierarchical structure
  ///
  /// 階層構造からフラットリストを構築
  List<_FlatLayerItem> _buildFlatList(List<PaintingValue> items) {
    final result = <_FlatLayerItem>[];

    for (final item in items) {
      result.add(_FlatLayerItem(item: item, depth: 0, isGroupChild: false));

      if (item is GroupPaintingValue && item.isExpanded) {
        // Add children from childValues
        for (final child in item.childValues) {
          result.add(_FlatLayerItem(item: child, depth: 1, isGroupChild: true));
        }
      }
    }

    return result;
  }

  /// Build a single layer item
  ///
  /// 単一のレイヤーアイテムを構築
  Widget _buildLayerItem({
    required BuildContext context,
    required ThemeData theme,
    required Locale locale,
    required PaintingValue item,
    required int index,
    required int depth,
    required bool isGroupChild,
    required bool selected,
  }) {
    final tool =
        PainterMasamuneAdapter.findTool(toolId: item.type, recursive: true);
    final isGroup = item is GroupPaintingValue;

    return _buildReorderableItem(
      key: ValueKey(item.id),
      child: Container(
        margin: EdgeInsets.only(left: depth * 24.0),
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isGroup) ...[
                // Expand/collapse icon for groups
                InkWell(
                  onTap: () {
                    widget.controller.toggleGroupExpansion(item.id);
                  },
                  child: Icon(
                    item.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              item.icon,
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isGroup) ...[
                // Ungroup button
                InkWell(
                  onTap: () {
                    widget.controller.ungroup(item.id);
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
                    child: const Icon(Icons.unfold_more, size: 12),
                  ),
                ),
                const SizedBox(width: 8),
              ],
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
                child: Text(
                  item.name ?? tool?.config.title.value(locale) ?? "",
                ),
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
            // When selecting a group, all children are also selected (multiple selection behavior)
            // When selecting a child directly, only that child is selected
            // グループを選択すると、すべての子要素も選択されます（複数選択の動作）
            // 子要素を直接選択すると、その子要素のみが選択されます
            if (selected) {
              widget.controller.unselect(item);
            } else {
              widget.controller.select(item);
            }
          },
        ),
      ),
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

/// Helper class for flat layer list representation.
///
/// フラットレイヤーリスト表現のためのヘルパークラス。
class _FlatLayerItem {
  /// Helper class for flat layer list representation.
  ///
  /// フラットレイヤーリスト表現のためのヘルパークラス。
  const _FlatLayerItem({
    required this.item,
    required this.depth,
    required this.isGroupChild,
  });

  /// The painting value item.
  ///
  /// 描画値アイテム。
  final PaintingValue item;

  /// The depth in the hierarchy (0 for root items).
  ///
  /// 階層の深さ（ルートアイテムの場合は0）。
  final int depth;

  /// Whether this item is a child of a group.
  ///
  /// このアイテムがグループの子かどうか。
  final bool isGroupChild;
}
