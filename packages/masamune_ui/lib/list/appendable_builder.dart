part of masamune_ui.list;

class AppendableBuilder extends StatefulWidget {
  const AppendableBuilder({
    this.child,
    this.dense = false,
    required this.builder,
    this.label,
    this.backgroundColor,
    this.initialValues = const [],
  });

  final String? label;
  final bool dense;
  final Color? backgroundColor;
  final Widget Function(
    BuildContext context,
    List<Widget> children,
    Function onAdd,
    void Function(String id) onRemove,
  )? child;
  final Widget Function(
    BuildContext context,
    String id,
    Function onAdd,
    void Function(String id) onRemove,
  ) builder;
  final Iterable<String> initialValues;

  @override
  State<StatefulWidget> createState() => _AppendableBuilderState();
}

class _AppendableBuilderState extends State<AppendableBuilder> {
  final _children = <String, Widget>{};
  @override
  void initState() {
    super.initState();
    for (final id in widget.initialValues) {
      if (id.isEmpty) {
        continue;
      }
      _children[id] = widget.builder(context, id, _onAdd, _onRemove);
    }
  }

  @override
  void didUpdateWidget(AppendableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValues == widget.initialValues) {
      return;
    }
    widget.initialValues.forEach((id) {
      if (id.isEmpty || _children.containsKey(id)) {
        return;
      }
      _children[id] = widget.builder(context, id, _onAdd, _onRemove);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return Column(
        children: [
          Container(
            margin:
                widget.dense ? null : const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.only(left: 15),
            constraints: const BoxConstraints.expand(height: 60),
            decoration: widget.dense
                ? null
                : BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).disabledColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    widget.label ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    color: widget.backgroundColor,
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: const EdgeInsets.all(10),
                      icon: const Icon(Icons.add),
                      onPressed: _onAdd,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.dense && _children.values.isNotEmpty)
            Divid(color: context.theme.dividerColor.withOpacity(0.25)),
          ..._children.values
        ],
      );
    } else {
      return widget.child!
          .call(context, _children.values.toList(), _onAdd, _onRemove);
    }
  }

  void _onAdd() {
    setState(() {
      final id = uuid;
      _children[id] = widget.builder(context, id, _onAdd, _onRemove);
    });
  }

  void _onRemove(String id) {
    setState(() {
      _children.remove(id);
    });
  }
}

/// Item widget for AppendableBuilder.
class AppendableBuilderItem extends StatelessWidget {
  /// Item widget for AppendableBuilder.
  ///
  /// [icon]: Icon data.
  /// [child]: Child widget.
  /// [onPressed]: What happens when a button is pressed.
  /// [height]: Height of the element.
  const AppendableBuilderItem({
    this.onPressed,
    required this.child,
    this.icon,
    this.height,
  });

  /// Icon data.
  final Icon? icon;

  /// Child widget.
  final Widget child;

  /// What happens when a button is pressed.
  final VoidCallback? onPressed;

  /// Height of the element.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: child),
        Flexible(
          flex: 1,
          child: Container(
            height: height,
            alignment: Alignment.center,
            child: IconButton(
              onPressed: onPressed,
              icon: icon ?? const Icon(Icons.close),
            ),
          ),
        )
      ],
    );
  }
}
