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
    this.rowHeight = 56,
    super.key,
  });

  /// Row height.
  ///
  /// 行の高さ。
  final double rowHeight;

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
  late TreeViewController _treeViewController;
  List<TreeViewNode<PaintingValue?>> _treeNodes = [];

  @override
  void initState() {
    super.initState();
    _treeViewController = TreeViewController();
    widget.controller.addListener(_handleControllerChanged);
    _rebuildTree();
  }

  @override
  void didUpdateWidget(PainterLayerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _rebuildTree();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(_rebuildTree);
  }

  // PainterControllerの値からツリー構造を再構築
  void _rebuildTree() {
    final items = widget.controller.value;
    _treeNodes = _buildTreeViewNodes(items);
  }

  // PaintingValueからTreeViewNodeリストを構築
  List<TreeViewNode<PaintingValue?>> _buildTreeViewNodes(
      List<PaintingValue> items) {
    final nodes = <TreeViewNode<PaintingValue?>>[];

    // Collect all IDs that are already inside groups
    final childIdsInGroups = <String>{};
    for (final item in items) {
      if (item is GroupPaintingValue) {
        _collectChildIds(item, childIdsInGroups);
      }
    }

    // Build nodes, but skip items that are already in groups
    for (final item in items) {
      // Skip if this item is already a child of a group
      if (!childIdsInGroups.contains(item.id)) {
        final node = _createTreeViewNode(item);
        if (node != null) {
          nodes.add(node);
        }
      }
    }

    // Reverse the list to display from front to back (top to bottom)
    final reversedNodes = nodes.reversed.toList();

    // Add null node at the end as drop target
    reversedNodes.add(TreeViewNode<PaintingValue?>(null));

    return reversedNodes;
  }

  // グループから再帰的にすべての子要素のIDを収集
  void _collectChildIds(GroupPaintingValue group, Set<String> childIds) {
    for (final child in group.children) {
      childIds.add(child.id);
      if (child is GroupPaintingValue) {
        _collectChildIds(child, childIds);
      }
    }
  }

  // PaintingValueからTreeViewNodeを作成
  TreeViewNode<PaintingValue?>? _createTreeViewNode(PaintingValue value) {
    if (value is GroupPaintingValue) {
      // Create children nodes recursively
      final childNodes = <TreeViewNode<PaintingValue?>>[];
      for (final childValue in value.children) {
        final childNode = _createTreeViewNode(childValue);
        if (childNode != null) {
          childNodes.add(childNode);
        }
      }

      // Reverse children to display from front to back (top to bottom)
      final reversedChildNodes = childNodes.reversed.toList();

      return TreeViewNode<PaintingValue?>(
        value,
        children: reversedChildNodes,
        expanded: value.expanded,
      );
    } else {
      return TreeViewNode<PaintingValue?>(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return TreeView<PaintingValue?>(
        tree: _treeNodes,
        controller: _treeViewController,
        onNodeToggle: (node) {
          // Update PainterController expansion state without triggering rebuild
          final content = node.content;
          if (content != null && content is GroupPaintingValue) {
            // Temporarily remove listener to avoid rebuild during toggle
            widget.controller.removeListener(_handleControllerChanged);
            try {
              widget.controller.toggleGroupExpansion(content.id);
            } finally {
              widget.controller.addListener(_handleControllerChanged);
            }
          }
        },
        treeNodeBuilder: (
          context,
          node,
          toggleAnimationStyle,
        ) =>
            _treeNodeBuilder(context, node, toggleAnimationStyle, constraints),
        treeRowBuilder: _treeRowBuilder,
        indentation: TreeViewIndentationType.custom(0),
        primary: false,
        cacheExtent: 500,
      );
    });
  }

  // ツリー行の設定を構築
  TreeRow _treeRowBuilder(TreeViewNode<PaintingValue?> node) {
    return TreeRow(
      extent: FixedTreeRowExtent(widget.rowHeight),
    );
  }

  // ドラッグ&ドロップ対応のツリーノードウィジェットを構築
  Widget _treeNodeBuilder(
    BuildContext context,
    TreeViewNode<PaintingValue?> node,
    AnimationStyle toggleAnimationStyle,
    BoxConstraints constraints,
  ) {
    // If content is null, this is the bottom drop target
    if (node.content == null) {
      return _BottomDropTarget(
        key: const ValueKey("bottom_drop_target"),
        controller: widget.controller,
        constraints: constraints,
        height: widget.rowHeight,
        onDropAccepted: _appendToEnd,
      );
    }

    return _DraggableTreeTile(
      key: ValueKey(node.content!.id),
      node: node,
      controller: widget.controller,
      constraints: constraints,
      hintTextOnChangeName: widget.hintTextOnChangeName,
      onDropAccepted: _handleDrop,
      height: widget.rowHeight,
      toggleAnimationStyle: toggleAnimationStyle,
      treeViewController: _treeViewController,
    );
  }

  // ドラッグした値をリストの最後に追加
  void _appendToEnd(PaintingValue dragged) {
    final items = widget.controller.value;
    final draggedIndex = items.indexWhere((v) => v.id == dragged.id);
    final draggedParent = _findParent(dragged, items);

    // Since display is reversed, dropping at the bottom (visually back)
    // means inserting at the beginning of data (index 0)
    if (draggedParent != null) {
      // Dragged is inside a group, move it to root level at the beginning
      widget.controller.removeFromGroup(
        dragged.id,
        insertIndex: 0,
      );
    } else if (draggedIndex >= 0) {
      // Dragged is at root level, reorder to beginning
      // Remove dragged from its current location
      _removeFromCurrentLocation(dragged);

      // Move to the beginning
      if (draggedIndex != 0) {
        widget.controller.reorder(draggedIndex, 0);
      }
    }

    _rebuildTree();
  }

  // ドロップ操作を処理
  void _handleDrop(
    PaintingValue dragged,
    PaintingValue target,
    _DropPosition position,
  ) {
    // Since the display order is reversed (front to back, top to bottom),
    // we need to swap above and below operations to match user's visual intention
    switch (position) {
      case _DropPosition.above:
        // Display above (front) = Insert after in data (back to front order)
        _insertAfter(dragged, target);
        break;
      case _DropPosition.inside:
        if (target is GroupPaintingValue) {
          _addToGroup(dragged, target);
        } else {
          _createGroup(dragged, target);
        }
        break;
      case _DropPosition.below:
        // Display below (back) = Insert before in data (back to front order)
        _insertBefore(dragged, target);
        break;
    }

    _rebuildTree();
  }

  // ドラッグした値をターゲットの前に挿入
  void _insertBefore(PaintingValue dragged, PaintingValue target) {
    final items = widget.controller.value;

    // Find target's parent
    final targetParent = _findParent(target, items);

    if (targetParent != null) {
      // Target is inside a group
      final targetIndex = targetParent.children.indexOf(target);

      // Remove dragged from its current location
      _removeFromCurrentLocation(dragged);

      // Insert before target
      widget.controller.addToGroup(
        dragged.id,
        targetParent.id,
        insertIndex: targetIndex,
      );
    } else {
      // Target is at root level
      final targetIndex = items.indexOf(target);
      final draggedIndex = items.indexWhere((v) => v.id == dragged.id);

      final draggedParent = _findParent(dragged, items);

      if (draggedParent != null) {
        // Dragged is inside a group, move it to root level
        // Calculate new index considering if group will be removed
        final groupIndex = items.indexWhere((v) => v.id == draggedParent.id);
        final willGroupBeRemoved = draggedParent.children.length == 1;

        final newIndex = willGroupBeRemoved && groupIndex < targetIndex
            ? targetIndex - 1
            : targetIndex;

        widget.controller.removeFromGroup(
          dragged.id,
          insertIndex: newIndex,
        );
      } else if (draggedIndex >= 0) {
        // Dragged is at root level, reorder
        // Remove dragged from its current location
        _removeFromCurrentLocation(dragged);

        // Calculate new index considering the removal
        // If dragging down (draggedIndex < targetIndex), we need to adjust
        // because the item will be removed first, shifting indices
        final newIndex =
            draggedIndex < targetIndex ? targetIndex - 1 : targetIndex;

        // Insert at root level
        widget.controller.reorder(draggedIndex, newIndex);
      }
    }
  }

  // ドラッグした値をターゲットの後に挿入
  void _insertAfter(PaintingValue dragged, PaintingValue target) {
    final items = widget.controller.value;

    // Find target's parent
    final targetParent = _findParent(target, items);

    if (targetParent != null) {
      // Target is inside a group
      final targetIndex = targetParent.children.indexOf(target);

      // Remove dragged from its current location
      _removeFromCurrentLocation(dragged);

      // Insert after target
      widget.controller.addToGroup(
        dragged.id,
        targetParent.id,
        insertIndex: targetIndex + 1,
      );
    } else {
      // Target is at root level
      final targetIndex = items.indexOf(target);
      final draggedIndex = items.indexWhere((v) => v.id == dragged.id);

      final draggedParent = _findParent(dragged, items);

      if (draggedParent != null) {
        // Dragged is inside a group, move it to root level
        // Calculate new index considering if group will be removed
        final groupIndex = items.indexWhere((v) => v.id == draggedParent.id);
        final willGroupBeRemoved = draggedParent.children.length == 1;

        final newIndex = willGroupBeRemoved && groupIndex < targetIndex
            ? targetIndex
            : targetIndex + 1;

        widget.controller.removeFromGroup(
          dragged.id,
          insertIndex: newIndex,
        );
      } else if (draggedIndex >= 0) {
        // Dragged is at root level, reorder
        // Remove dragged from its current location
        _removeFromCurrentLocation(dragged);

        // Calculate new index considering the removal
        // If dragging down (draggedIndex < targetIndex), targetIndex stays the same
        // because the item will be removed first
        final newIndex =
            draggedIndex < targetIndex ? targetIndex : targetIndex + 1;

        // Insert at root level
        widget.controller.reorder(draggedIndex, newIndex);
      }
    }
  }

  // ドラッグした値をグループに追加
  void _addToGroup(PaintingValue dragged, GroupPaintingValue targetGroup) {
    // Remove dragged from its current location
    _removeFromCurrentLocation(dragged);

    // Add to group at the end (which appears at the top in reversed display)
    // Since display is reversed, adding to the end of data means showing at the front
    widget.controller.addToGroup(
      dragged.id,
      targetGroup.id,
    );

    // Ensure target group is expanded
    if (!targetGroup.expanded) {
      widget.controller.toggleGroupExpansion(targetGroup.id);
    }
  }

  /// Create a new group with dragged and target values
  ///
  /// ドラッグした値とターゲット値で新しいグループを作成
  void _createGroup(PaintingValue dragged, PaintingValue target) {
    // Remove dragged from its current location
    _removeFromCurrentLocation(dragged);

    // Create group with [target, dragged] order (back to front in data)
    // This will display as [dragged, target] (front to back) due to reversed display
    final group = widget.controller.createGroup(
      [target, dragged],
    );

    // Ensure group is expanded
    if (group != null && !group.expanded) {
      widget.controller.toggleGroupExpansion(group.id);
    }
  }

  /// Remove value from its current location
  ///
  /// 値を現在の位置から削除
  void _removeFromCurrentLocation(PaintingValue value) {
    final items = widget.controller.value;
    final parent = _findParent(value, items);

    if (parent != null) {
      // Value is inside a group
      widget.controller.removeFromGroup(value.id);
    }
    // If not in a group, it will be moved by reorder
  }

  // 値の親グループを検索
  GroupPaintingValue? _findParent(
      PaintingValue value, List<PaintingValue> items) {
    for (final item in items) {
      if (item is GroupPaintingValue) {
        // Check direct children
        if (item.children.any((child) => child.id == value.id)) {
          return item;
        }

        // Check nested children recursively
        final nestedParent = _findParent(value, item.children);
        if (nestedParent != null) {
          return nestedParent;
        }
      }
    }
    return null;
  }
}

/// Drop position enum
///
/// ドロップ位置の列挙型
enum _DropPosition {
  above,
  inside,
  below,
}

/// Draggable tree tile with drop target support
///
/// ドロップターゲット対応のドラッグ可能ツリータイル
class _DraggableTreeTile extends StatefulWidget {
  const _DraggableTreeTile({
    required this.node,
    required this.controller,
    required this.onDropAccepted,
    required this.toggleAnimationStyle,
    required this.treeViewController,
    required this.constraints,
    required this.height,
    super.key,
    this.hintTextOnChangeName,
  });

  final double height;
  final BoxConstraints constraints;
  final TreeViewNode<PaintingValue?> node;
  final PainterController controller;
  final String? hintTextOnChangeName;
  final void Function(
    PaintingValue dragged,
    PaintingValue target,
    _DropPosition position,
  ) onDropAccepted;
  final AnimationStyle toggleAnimationStyle;
  final TreeViewController treeViewController;

  @override
  State<_DraggableTreeTile> createState() => _DraggableTreeTileState();
}

class _DraggableTreeTileState extends State<_DraggableTreeTile> {
  _DropPosition? _currentDropPosition;
  bool _isDraggingOver = false;
  final GlobalKey _tileKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.node.content!;
    final depth = widget.node.depth ?? 0;

    return LongPressDraggable<PaintingValue>(
      data: item,
      onDragEnd: (details) {
        // ドラッグ終了時に状態をリセット
        if (_isDraggingOver || _currentDropPosition != null) {
          setState(() {
            _isDraggingOver = false;
            _currentDropPosition = null;
          });
        }
      },
      feedback: Material(
        elevation: 4,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.constraints.minWidth,
            maxWidth: widget.constraints.maxWidth,
          ),
          child: _buildTileContent(context, item, theme, showIndent: false),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: DragTarget<PaintingValue>(
          onWillAcceptWithDetails: (details) => false,
          builder: (context, candidateData, rejectedData) {
            return Container(
              key: _tileKey,
              child: _buildTileContent(context, item, theme),
            );
          },
        ),
      ),
      child: DragTarget<PaintingValue>(
        onWillAcceptWithDetails: (details) {
          // Don't allow dropping on itself
          return details.data.id != item.id;
        },
        onAcceptWithDetails: (details) {
          // ドロップ位置を先に保存
          final dropPosition = _currentDropPosition ?? _DropPosition.below;

          // 状態をリセット
          setState(() {
            _isDraggingOver = false;
            _currentDropPosition = null;
          });

          // その後にドロップ処理を実行
          widget.onDropAccepted(
            details.data,
            item,
            dropPosition,
          );
        },
        onMove: (details) {
          // Calculate drop position based on vertical offset
          final renderBox =
              _tileKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox == null || !renderBox.hasSize) {
            return;
          }

          final localPosition = renderBox.globalToLocal(details.offset);
          final height = renderBox.size.height;

          final newPosition = _calculateDropPosition(localPosition.dy, height);

          if (newPosition != _currentDropPosition) {
            setState(() {
              _currentDropPosition = newPosition;
            });
          }

          if (!_isDraggingOver) {
            setState(() {
              _isDraggingOver = true;
            });
          }
        },
        onLeave: (_) {
          setState(() {
            _isDraggingOver = false;
            _currentDropPosition = null;
          });
        },
        builder: (context, candidateData, rejectedData) {
          // Always return the same widget structure
          Border? border;
          if (_isDraggingOver && _currentDropPosition != null) {
            final borderSide = BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            );

            switch (_currentDropPosition!) {
              case _DropPosition.above:
                border = Border(top: borderSide);
                break;
              case _DropPosition.inside:
                border = Border.fromBorderSide(borderSide);
                break;
              case _DropPosition.below:
                border = Border(bottom: borderSide);
                break;
            }
          }

          // ignore: use_decorated_box
          return Container(
            key: _tileKey,
            decoration: border != null ? BoxDecoration(border: border) : null,
            child: _buildTileContent(context, item, theme, depth: depth),
          );
        },
      ),
    );
  }

  // 縦方向のオフセットからドロップ位置を計算
  _DropPosition _calculateDropPosition(double dy, double height) {
    final oneThird = height * 0.3;

    if (dy < oneThird) {
      return _DropPosition.above;
    } else if (dy < oneThird * 2) {
      return _DropPosition.inside;
    } else {
      return _DropPosition.below;
    }
  }

  // タイルのコンテンツを構築
  Widget _buildTileContent(
    BuildContext context,
    PaintingValue item,
    ThemeData theme, {
    int depth = 0,
    bool showIndent = true,
  }) {
    final locale = context.locale;
    final tool =
        PainterMasamuneAdapter.findTool(toolId: item.type, recursive: true);
    final selected =
        widget.controller.currentValues.any((v) => v.id == item.id);

    // Wrap ListTile with ConstrainedBox to handle infinite width constraints
    // ClipRect prevents background color from overflowing during animations
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.height,
          minWidth: widget.constraints.minWidth,
          maxWidth: widget.constraints.maxWidth,
          maxHeight: widget.height,
        ),
        child: ListTile(
          selected: selected,
          contentPadding:
              EdgeInsets.fromLTRB(16 + (8 * depth).toDouble(), 0, 16, 0),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (item is GroupPaintingValue) ...[
                TreeView.wrapChildToToggleNode(
                  node: widget.node,
                  child: IconTheme(
                    data: IconThemeData(
                      color: selected
                          ? theme.colorScheme.onPrimary
                          : theme.iconTheme.color,
                    ),
                    child: widget.treeViewController.isExpanded(widget.node)
                        ? const Icon(Icons.folder_open)
                        : const Icon(Icons.folder),
                  ),
                )
              ] else ...[
                IconTheme(
                  data: IconThemeData(
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorTheme?.onBackground,
                  ),
                  child: item.icon,
                ),
              ],
            ],
          ),
          title: Text(item.name ?? tool?.config.title.value(locale) ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color,
              )),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minHeight: 28, minWidth: 28),
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.iconTheme.color,
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
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.iconTheme.color,
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
      ),
    );
  }
}

/// Bottom drop target widget
///
/// 最下部のドロップターゲットウィジェット
class _BottomDropTarget extends StatefulWidget {
  const _BottomDropTarget({
    required this.controller,
    required this.constraints,
    required this.height,
    required this.onDropAccepted,
    super.key,
  });

  final PainterController controller;
  final BoxConstraints constraints;
  final double height;
  final void Function(PaintingValue dragged) onDropAccepted;

  @override
  State<_BottomDropTarget> createState() => _BottomDropTargetState();
}

class _BottomDropTargetState extends State<_BottomDropTarget> {
  bool _isDraggingOver = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DragTarget<PaintingValue>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        setState(() {
          _isDraggingOver = false;
        });
        widget.onDropAccepted(details.data);
      },
      onMove: (details) {
        if (!_isDraggingOver) {
          setState(() {
            _isDraggingOver = true;
          });
        }
      },
      onLeave: (_) {
        setState(() {
          _isDraggingOver = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: widget.constraints.maxWidth,
          height: widget.height,
          decoration: _isDraggingOver
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                )
              : null,
          child: _isDraggingOver
              ? Center(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                )
              : null,
        );
      },
    );
  }
}
