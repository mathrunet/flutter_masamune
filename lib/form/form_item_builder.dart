part of masamune.form;

class FormItemBuilder<TController extends Object> extends FormField<String> {
  FormItemBuilder({
    Key? key,
    this.future,
    this.indicatorColor,
    required this.onInitController,
    required Widget Function(
      BuildContext context,
      TController? controller,
      FocusNode? focusNode,
    )
        builder,
    this.onUpdated,
    this.onDisposeController,
    this.onPreSave,
    this.controller,
    void Function(String? value)? onSaved,
    String? Function(String? value)? validator,
    String? initialURI,
    bool enabled = true,
  })  : _builder = builder,
        super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: initialURI,
          enabled: enabled,
        );

  final TController Function(String text)? onInitController;
  final void Function(TController? controller)? onDisposeController;
  final String Function(TController? controller)? onPreSave;
  final TController Function(TController? controller, String text)? onUpdated;
  final TextEditingController? controller;
  final Future? future;
  final Colors? indicatorColor;
  final Widget Function(
    BuildContext context,
    TController? controller,
    FocusNode? focusNode,
  ) _builder;

  @override
  _FormItemBuilderState<TController> createState() =>
      _FormItemBuilderState<TController>();
}

class _FormItemBuilderState<TController extends Object>
    extends FormFieldState<String> {
  TextEditingController? _textEditingController;
  TController? _controller;
  FocusNode? _focusNode;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _textEditingController;

  @override
  FormItemBuilder<TController> get widget =>
      super.widget as FormItemBuilder<TController>;

  @override
  void didUpdateWidget(FormItemBuilder<TController> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _textEditingController =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(widget.controller?.text);
        if (oldWidget.controller == null) {
          _textEditingController = null;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.controller == null) {
      _textEditingController = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    if (widget.onInitController != null) {
      _controller =
          widget.onInitController?.call(_effectiveController?.text ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.future != null) {
      return FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _controller == null || _focusNode == null
                ? const Empty()
                : widget._builder(context, _controller, _focusNode);
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: (widget.indicatorColor ??
                    context.theme.primaryColor) as Color,
              ),
            );
          }
        },
      );
    } else {
      return _controller == null || _focusNode == null
          ? const Empty()
          : widget._builder(context, _controller, _focusNode);
    }
  }

  @override
  void save() {
    if (widget.onPreSave != null) {
      setValue(widget.onPreSave!(_controller));
    }
    super.save();
  }

  @override
  bool validate() {
    if (widget.onPreSave != null) {
      setValue(widget.onPreSave!(_controller));
    }
    return super.validate();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController?.text != value) {
      _effectiveController?.text = value ?? "";
    }
    if (widget.onUpdated != null) {
      _controller = widget.onUpdated!(
        _controller,
        _effectiveController?.text ?? "",
      );
    } else if (widget.onInitController != null) {
      _controller = widget.onInitController!(
        _effectiveController?.text ?? "",
      );
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    if (widget.onDisposeController != null) {
      widget.onDisposeController!(_controller);
    }
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text = widget.initialValue ?? "";
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value) {
      didChange(_effectiveController?.text);
    }
  }
}
