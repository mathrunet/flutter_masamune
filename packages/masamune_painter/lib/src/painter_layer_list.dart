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

    // Build lists using drag_and_drop_lists
    final lists = _buildDragAndDropLists(items, locale, theme);

    return DragAndDropLists(
      children: lists,
      onItemReorder: _onItemReorder,
      onListReorder: _onListReorder,
      listDivider: const SizedBox(height: 0),
      itemDivider: const SizedBox(height: 0),
      listPadding: EdgeInsets.zero,
      removeTopPadding: true,
      lastListTargetSize: 48,
      lastItemTargetHeight: 0,
      listGhost: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const SizedBox(height: 48),
      ),
      itemGhost: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const SizedBox(height: 48),
      ),
      contentsWhenEmpty: const SizedBox.shrink(),
    );
  }

  /// Build DragAndDropLists from PaintingValues
  ///
  /// PaintingValueからDragAndDropListsを構築
  List<DragAndDropList> _buildDragAndDropLists(
    List<PaintingValue> items,
    Locale locale,
    ThemeData theme,
  ) {
    final lists = <DragAndDropList>[];
    final groupedItems = <PaintingValue>[];

    for (final item in items) {
      if (item is! GroupPaintingValue) {
        continue;
      }
      groupedItems.addAll(item.childValues);
    }

    for (final item in items) {
      if (item is GroupPaintingValue) {
        // Create a list for the group with its children
        // Only show children when expanded
        final children = item.expanded
            ? item.childValues.asMap().entries.map((entry) {
                final child = entry.value;
                return DragAndDropItem(
                  child: KeyedSubtree(
                    key: ValueKey(child.id),
                    child: _buildLayerItem(
                      item: child,
                      locale: locale,
                      theme: theme,
                      depth: 1,
                      isGroupChild: true,
                    ),
                  ),
                );
              }).toList()
            : <DragAndDropItem>[];

        lists.add(
          DragAndDropList(
            key: ValueKey(item.id),
            header: _buildGroupHeader(
              item: item,
              locale: locale,
              theme: theme,
            ),
            children: children,
            canDrag: true,
            contentsWhenEmpty: const SizedBox.shrink(),
          ),
        );
      } else {
        if (groupedItems.any((v) => v.id == item.id)) {
          continue;
        }
        // Single item as a list
        lists.add(
          DragAndDropList(
            key: ValueKey(item.id),
            children: [
              DragAndDropItem(
                child: KeyedSubtree(
                  key: ValueKey(item.id),
                  child: _buildLayerItem(
                    item: item,
                    locale: locale,
                    theme: theme,
                    depth: 0,
                    isGroupChild: false,
                  ),
                ),
              ),
            ],
            canDrag: true,
          ),
        );
      }
    }

    return lists;
  }

  /// Build group header
  ///
  /// グループヘッダーを構築
  Widget _buildGroupHeader({
    required GroupPaintingValue item,
    required Locale locale,
    required ThemeData theme,
    int depth = 0,
  }) {
    final tool =
        PainterMasamuneAdapter.findTool(toolId: item.type, recursive: true);
    final selected =
        widget.controller.currentValues.any((v) => v.id == item.id);

    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(depth * 16.0 + 16.0, 0, 16.0, 0),
      selected: selected,
      tileColor: selected ? theme.colorScheme.primary : Colors.transparent,
      selectedTileColor:
          selected ? theme.colorScheme.primary : Colors.transparent,
      iconColor: selected
          ? theme.colorScheme.onPrimary
          : theme.colorTheme?.onBackground,
      leading: InkWell(
        onTap: () {
          widget.controller.toggleGroupExpansion(item.id);
        },
        child: IconTheme(
          data: IconThemeData(
            color:
                selected ? theme.colorScheme.onPrimary : theme.iconTheme.color,
          ),
          child: item.expanded
              ? const Icon(Icons.folder_open)
              : const Icon(Icons.folder),
        ),
      ),
      title: Text(
        item.name ?? tool?.config.title.value(locale) ?? "",
        overflow: TextOverflow.ellipsis,
        style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.textTheme.bodyMedium?.color,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minHeight: 28, minWidth: 28),
            color:
                selected ? theme.colorScheme.onPrimary : theme.iconTheme.color,
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
            icon: const Icon(Icons.edit, size: 16),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.drag_handle,
            color:
                selected ? theme.colorScheme.onPrimary : theme.iconTheme.color,
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
    );
  }

  /// Build layer item
  ///
  /// レイヤーアイテムを構築
  Widget _buildLayerItem({
    required PaintingValue item,
    required Locale locale,
    required ThemeData theme,
    required bool isGroupChild,
    int depth = 0,
  }) {
    final tool =
        PainterMasamuneAdapter.findTool(toolId: item.type, recursive: true);
    final selected =
        widget.controller.currentValues.any((v) => v.id == item.id);

    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(depth * 16.0 + 16.0, 0, 16.0, 0),
      selected: selected,
      tileColor: selected ? theme.colorScheme.primary : Colors.transparent,
      selectedTileColor:
          selected ? theme.colorScheme.primary : Colors.transparent,
      iconColor: selected
          ? theme.colorScheme.onPrimary
          : theme.colorTheme?.onBackground,
      textColor: selected
          ? theme.colorScheme.onPrimary
          : theme.colorTheme?.onBackground,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorTheme?.onBackground,
            ),
            child: item.icon,
          ),
        ],
      ),
      title: Text(
        item.name ?? tool?.config.title.value(locale) ?? "",
        overflow: TextOverflow.ellipsis,
        style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorTheme?.onBackground,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minHeight: 28, minWidth: 28),
            color:
                selected ? theme.colorScheme.onPrimary : theme.iconTheme.color,
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
            icon: const Icon(Icons.edit, size: 16),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.drag_handle,
            color:
                selected ? theme.colorScheme.onPrimary : theme.iconTheme.color,
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
    );
  }

  /// Handle item reorder within a list or between lists
  ///
  /// リスト内またはリスト間でのアイテムの並び替えを処理
  void _onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    final items = widget.controller.value;

    // Same list reordering
    if (oldListIndex == newListIndex) {
      final listItem = items[oldListIndex];

      if (listItem is GroupPaintingValue) {
        // Reorder within group
        widget.controller.reorderInGroup(
          listItem.id,
          oldItemIndex,
          newItemIndex,
        );
      }
      return;
    }

    // Moving between lists
    final oldListItem = items[oldListIndex];
    final newListItem = items[newListIndex];

    if (oldListItem is GroupPaintingValue &&
        newListItem is GroupPaintingValue) {
      // Move from one group to another
      final child = oldListItem.childValues[oldItemIndex];
      widget.controller.moveToGroup(
        child.id,
        oldListItem.id,
        newListItem.id,
        newItemIndex,
      );
    } else if (oldListItem is GroupPaintingValue) {
      // Move from group to top level
      final child = oldListItem.childValues[oldItemIndex];
      widget.controller.removeFromGroup(child.id, insertIndex: newListIndex);
    } else if (newListItem is GroupPaintingValue) {
      // Move from top level to group
      widget.controller.addToGroup(
        oldListItem.id,
        newListItem.id,
        insertIndex: newItemIndex,
      );
    }
  }

  /// Handle list reorder (top-level items including groups)
  ///
  /// リストの並び替えを処理（グループを含むトップレベルアイテム）
  void _onListReorder(int oldListIndex, int newListIndex) {
    widget.controller.reorder(oldListIndex, newListIndex);
  }
}
