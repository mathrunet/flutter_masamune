part of masamune.form;

class FormItemMultipleFullScreen extends FormField<List<DynamicMap>> {
  FormItemMultipleFullScreen({
    this.controller,
    required this.path,
    required Widget Function(
      BuildContext context,
      DynamicMap item,
      int index,
      void Function() onEdit,
      void Function()? onRemove,
    )
        builder,
    this.addLabel = "Add",
    this.color,
    Key? key,
    this.minItems,
    this.errorText,
    this.hintText,
    void Function(List<DynamicMap>? value)? onSaved,
    String? Function(List<DynamicMap>? value)? validator,
    List<DynamicMap>? initialValue,
    bool enabled = true,
  })  : _builder = builder,
        assert(minItems == null || (minItems != null && hintText.isNotEmpty),
            "When specifying [minItems], please write [hintText]."),
        super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: (value) {
            if (errorText.isNotEmpty && minItems != null) {
              final filtered =
                  value?.where((element) => element.isNotEmpty) ?? [];
              if (minItems > filtered.length) {
                return errorText!;
              }
            }
            return validator?.call(value);
          },
          initialValue: initialValue,
          enabled: enabled,
        );

  final TextEditingController? controller;
  final String path;
  final String addLabel;
  final int? minItems;
  final String? errorText;
  final Color? color;
  final String? hintText;

  final Widget Function(
    BuildContext context,
    DynamicMap item,
    int index,
    void Function() onEdit,
    void Function()? onRemove,
  ) _builder;

  @override
  _FormItemMultipleFullScreenState createState() =>
      _FormItemMultipleFullScreenState();
}

class _FormItemMultipleFullScreenState
    extends FormFieldState<List<DynamicMap>> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMultipleFullScreen get widget =>
      super.widget as FormItemMultipleFullScreen;

  String _encodeJson(List<DynamicMap> items) {
    return jsonEncode(items);
  }

  List<DynamicMap> _decodeJson(String? value) {
    if (value.isEmpty) {
      return [];
    }
    return jsonDecodeAsList(value!);
  }

  @override
  void didUpdateWidget(FormItemMultipleFullScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_decodeJson(widget.controller?.text ?? ""));
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    final list = _decodeJson(_effectiveController?.text ?? "");
    if (widget.minItems != null && widget.minItems! > list.length) {
      list.add({});
    }
    setValue(list);
  }

  Future<void> _onAdd() async {
    final res = await context.rootNavigator.pushNamed(widget.path);
    if (res is! DynamicMap || res.isEmpty) {
      return;
    }
    didChange(List.from(value ?? [])..add(res));
    setState(() {});
  }

  Future<void> _onEdit(int index, DynamicMap origin) async {
    assert(index >= 0 && index < value.length, "The value of Index is wrong.");
    final data = Map<String, dynamic>.from(origin);
    final res = await context.rootNavigator.pushNamed(
      widget.path,
      arguments: RouteQuery(parameters: data),
    );
    if (res is! DynamicMap || res.isEmpty) {
      return;
    }
    value?[index] = res;
    didChange(List.from(value ?? []));
    setState(() {});
  }

  void _onRemove(int index) {
    assert(index >= 0 && index < value.length, "The value of Index is wrong.");
    if (widget.minItems != null && widget.minItems! >= value.length) {
      return;
    }
    value?.removeAt(index);
    didChange(List.from(value ?? []));
    setState(() {});
  }

  Widget _builder(BuildContext context, DynamicMap item, int index) {
    return widget._builder.call(
      context,
      item,
      index,
      () => _onEdit(index, item),
      widget.minItems == null || index >= widget.minItems!
          ? () => _onRemove(index)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReorderableListBuilder<DynamicMap>(
            source: value ?? [],
            builder: (context, item, index) {
              if (item.isEmpty) {
                return [
                  ListTile(
                    title: Text(
                      widget.hintText ?? "",
                      style: TextStyle(
                          color: widget.color?.withOpacity(0.5) ??
                              context.theme.disabledColor),
                    ),
                    onTap: () {
                      _onEdit(index, item);
                    },
                  ),
                ];
              }
              return [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _builder(context, item, index),
                ),
              ];
            },
            onReorder: (o, n, item, reordered) {
              didChange(reordered);
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          ListTile(
            onTap: () {
              _onAdd();
            },
            title: Text(
              widget.addLabel.localize(),
              textAlign: TextAlign.right,
              style: TextStyle(color: widget.color),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: widget.color ?? context.theme.textColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChange(List<DynamicMap>? value) {
    super.didChange(value);
    if (this.value != value) {
      value ??= [];
      _effectiveController?.text = _encodeJson(value);
      setValue(value);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text =
          widget.initialValue?.toString().toLowerCase() ?? "";
    });
  }

  void _handleControllerChanged() {
    final value = _decodeJson(_effectiveController?.text ?? "");
    if (this.value != value) {
      didChange(value);
    }
  }
}
