part of masamune.list;

class ReorderableListBuilder<T> extends StatefulWidget {
  const ReorderableListBuilder({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.top,
    this.insert,
    this.insertPosition = 0,
    this.bottom,
    this.itemExtent,
    required this.source,
    required this.builder,
    required this.onReorder,
    this.cacheExtent,
    this.keyBuilder,
    this.listenWhenListenable = true,
    this.loading,
    this.loadingOpacity = 0.25,
    this.indicatorColor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : _topLength = top.length,
        _length = top.length + source.length + bottom.length + insert.length,
        _topSourcelength = top.length + source.length + insert.length,
        super(key: key);

  static Future<M> setOrderForDynamicMap<M extends DynamicMap>(
    M map,
    int oldPosition,
    int newPosition,
    List<M> reordered, {
    FutureOr<void> Function(M data)? onSave,
    String key = "order",
    double? defaultOrder,
  }) async {
    if (reordered.length <= 1) {
      return map;
    }
    if (oldPosition < newPosition) {
      if (reordered.length <= newPosition) {
        map[key] =
            defaultOrder ?? DateTime.now().millisecondsSinceEpoch.toDouble();
      } else {
        map[key] = (reordered[newPosition].get(key, 0.0) +
                reordered[newPosition - 2].get(key, 0.0)) /
            2.0;
      }
    } else {
      if (newPosition <= 0) {
        map[key] = reordered[1].get(key, 0.0) / 2.0;
      } else if (reordered.length - 1 <= newPosition) {
        map[key] =
            defaultOrder ?? DateTime.now().millisecondsSinceEpoch.toDouble();
      } else {
        map[key] = (reordered[newPosition + 1].get(key, 0.0) +
                reordered[newPosition - 1].get(key, 0.0)) /
            2.0;
      }
    }
    await onSave?.call(map);
    return map;
  }

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final int insertPosition;
  final bool listenWhenListenable;
  final List<Widget>? insert;
  final List<Widget>? top;
  final List<Widget>? bottom;
  final Object Function(T item)? keyBuilder;
  final List<Widget>? Function(BuildContext context, T item, int index) builder;
  final List<T> source;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final bool Function(T item)? loading;
  final Color? indicatorColor;
  final double loadingOpacity;
  final void Function(
      int oldPosition, int newPosition, T item, List<T> reordered) onReorder;

  final int _topLength;
  final int _length;
  final int _topSourcelength;

  @override
  State<StatefulWidget> createState() => _ReorderableListBuilderState<T>();
}

class _ReorderableListBuilderState<T> extends State<ReorderableListBuilder<T>> {
  late List<T> _source;

  @override
  void initState() {
    super.initState();
    _source = List.from(widget.source);
  }

  @override
  void didUpdateWidget(ReorderableListBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source != oldWidget.source ||
        widget.source.length != oldWidget.source.length ||
        widget.source.length != _source.length) {
      _source = List.from(widget.source);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      onReorder: _reorder,
      // controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding?.resolve(TextDirection.ltr),
      itemExtent: widget.itemExtent,
      itemBuilder: _builder,
      itemCount: widget._length,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
    );
  }

  void _exchange(int oldPosition, int newPosition) {
    if (oldPosition >= newPosition) {
      _source.insert(newPosition, _source.removeAt(oldPosition));
    } else {
      _source.insert(newPosition - 1, _source.removeAt(oldPosition));
    }
  }

  void _reorder(int oldPosition, int newPosition) {
    if (oldPosition < widget._topLength || newPosition < widget._topLength) {
      return;
    } else if (oldPosition < widget._topSourcelength &&
        newPosition <= widget._topSourcelength) {
      if (_source.isEmpty) {
        return;
      } else if (_source.length <= widget.insertPosition) {
        final pos = oldPosition - widget._topLength;
        if (pos < _source.length) {
          final item = _source[pos];
          final npos = newPosition - widget._topLength;
          if (npos < _source.length) {
            setState(() {
              _exchange(pos, npos);
              widget.onReorder.call(pos, npos, item, _source);
            });
          }
        }
      } else {
        final pos = oldPosition - widget._topLength;
        if (pos >= widget.insertPosition &&
            pos < widget.insertPosition + widget.insert.length) {
          return;
        } else if (pos < widget.insertPosition) {
          final item = _source[pos];
          final npos = newPosition - widget._topLength;
          if (npos >= widget.insertPosition &&
              npos < widget.insertPosition + widget.insert.length) {
            return;
          } else if (npos < widget.insertPosition) {
            setState(() {
              _exchange(pos, npos);
              widget.onReorder.call(pos, npos, item, _source);
            });
          } else {
            setState(() {
              _exchange(pos, npos - widget.insert.length);
              widget.onReorder
                  .call(pos, npos - widget.insert.length, item, _source);
            });
          }
        } else {
          final item = _source[pos - widget.insert.length];
          final npos = newPosition - widget._topLength;
          if (npos >= widget.insertPosition &&
              npos < widget.insertPosition + widget.insert.length) {
            return;
          } else if (npos < widget.insertPosition) {
            setState(() {
              _exchange(pos - widget.insert.length, npos);
              widget.onReorder
                  .call(pos - widget.insert.length, npos, item, _source);
            });
          } else {
            setState(() {
              _exchange(
                  pos - widget.insert.length, npos - widget.insert.length);
              widget.onReorder.call(pos - widget.insert.length,
                  npos - widget.insert.length, item, _source);
            });
          }
        }
      }
    }
  }

  Widget _builder(BuildContext context, int i) {
    if (i < widget._topLength) {
      return widget.top![i];
    } else if (i < widget._topSourcelength) {
      if (_source.isEmpty) {
        return widget.insert![i - widget._topLength];
      } else if (_source.length <= widget.insertPosition) {
        final pos = i - widget._topLength;
        if (pos < _source.length) {
          return _listenableBuilder(context, pos);
        } else {
          return widget.insert![i - _source.length - widget._topLength];
        }
      } else {
        final pos = i - widget._topLength;
        if (pos >= widget.insertPosition &&
            pos < widget.insertPosition + widget.insert.length) {
          return widget.insert![pos - widget.insertPosition];
        } else if (pos < widget.insertPosition) {
          return _listenableBuilder(context, pos);
        } else {
          return _listenableBuilder(context, pos - widget.insert.length);
        }
      }
    } else {
      return widget.bottom![i - widget._topSourcelength];
    }
  }

  Widget _sourceBuilder(BuildContext context, T item, int pos, Key? key) {
    final children = widget.builder.call(context, item, pos);
    if (children.isEmpty) {
      return _loadingBuilder(
        key: key,
        context: context,
        item: item,
        child: const Empty(),
      );
    } else if (children.length <= 1) {
      return _loadingBuilder(
        key: key,
        context: context,
        item: item,
        child: children!.firstOrNull ?? const Empty(),
      );
    } else {
      return _loadingBuilder(
        key: key,
        context: context,
        item: item,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children!,
        ),
      );
    }
  }

  Widget _listenableBuilder(
    BuildContext context,
    int pos,
  ) {
    final item = _source[pos];
    final keyObject = widget.keyBuilder?.call(item) ?? item;
    final key = ValueKey(keyObject);
    if (!widget.listenWhenListenable || item is! Listenable) {
      return _sourceBuilder(context, item, pos, key);
    }
    return ListenableListener<Listenable>(
      key: key,
      listenable: item,
      builder: (context, listenable) {
        return _sourceBuilder(context, item, pos, key);
      },
    );
  }

  Widget _loadingBuilder({
    required BuildContext context,
    required T item,
    required Widget child,
    Key? key,
  }) {
    if (widget.loading == null || !widget.loading!.call(item)) {
      return Container(key: key, child: child);
    }
    return Stack(
      key: key,
      children: [
        Opacity(opacity: widget.loadingOpacity, child: child),
        Positioned.fill(
          child: Center(
            child: context.widgetTheme.loadingIndicator?.call(
                  context,
                  widget.indicatorColor ?? context.theme.disabledColor,
                ) ??
                LoadingBouncingGrid.square(
                  backgroundColor:
                      widget.indicatorColor ?? context.theme.disabledColor,
                ),
          ),
        ),
      ],
    );
  }
}
