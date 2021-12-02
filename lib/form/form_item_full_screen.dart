part of masamune.form;

class FormItemFullScreen<T extends Object> extends FormField<T> {
  FormItemFullScreen({
    this.controller,
    required this.path,
    this.dense = false,
    this.counterText = "",
    this.parseFromString,
    this.parseToString,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.allowEmpty = false,
    this.border,
    this.disabledBorder,
    this.color,
    this.subColor,
    this.hintText,
    this.errorText,
    this.labelText,
    Key? key,
    void Function(T? value)? onSaved,
    String? Function(T? value)? validator,
    T? initialValue,
    bool enabled = true,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          enabled: enabled,
        );

  final TextEditingController? controller;
  final String path;
  final String? hintText;
  final String? errorText;
  final bool dense;
  final String? labelText;
  final String? counterText;
  final T Function(String value)? parseFromString;
  final String Function(T? value)? parseToString;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool allowEmpty;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final Color? color;
  final Color? subColor;

  @override
  _FormItemFullScreenState<T> createState() => _FormItemFullScreenState<T>();
}

class _FormItemFullScreenState<T extends Object> extends FormFieldState<T> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemFullScreen<T> get widget => super.widget as FormItemFullScreen<T>;

  @override
  void didUpdateWidget(FormItemFullScreen<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        if (T == String) {
          setValue(widget.controller?.text as T?);
        } else if (widget.parseFromString != null) {
          setValue(widget.parseFromString!.call(widget.controller?.text ?? ""));
        }
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
    if (T == String) {
      setValue(_effectiveController?.text as T?);
    } else if (widget.parseFromString != null) {
      setValue(widget.parseFromString!.call(_effectiveController?.text ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        enabled: widget.enabled,
        controller: _effectiveController,
        decoration: InputDecoration(
          border: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          enabledBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          disabledBorder: widget.disabledBorder ??
              widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          errorBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          focusedBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          focusedErrorBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          hintText: widget.hintText,
          labelText: widget.labelText,
          counterText: widget.counterText,
          prefix: widget.prefix,
          suffix: widget.suffix,
          labelStyle: TextStyle(color: widget.color),
          hintStyle: TextStyle(color: widget.subColor),
          suffixStyle: TextStyle(color: widget.subColor),
          prefixStyle: TextStyle(color: widget.subColor),
          counterStyle: TextStyle(color: widget.subColor),
          helperStyle: TextStyle(color: widget.subColor),
        ),
        style: TextStyle(color: widget.color),
        obscureText: widget.obscureText,
        readOnly: true,
        onTap: widget.enabled && widget.path.isNotEmpty
            ? () async {
                final res = await context.navigator
                    .pushNamed(widget.path, arguments: RouteQuery.fullscreen);
                if (res == null || res is! T) {
                  return;
                }
                if (widget.parseToString != null) {
                  _effectiveController?.text =
                      widget.parseToString?.call(res) ?? "";
                } else {
                  _effectiveController?.text = res.toString();
                }
                setValue(res);
                setState(() {});
              }
            : null,
        validator: (value) {
          if (!widget.allowEmpty &&
              widget.errorText.isNotEmpty &&
              value.isEmpty) {
            return widget.errorText;
          }
          return null;
        },
        onSaved: (value) {
          if (!widget.allowEmpty && value.isEmpty) {
            return;
          }
          widget.onSaved?.call(this.value);
        },
      ),
    );
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    if (this.value != value) {
      if (widget.parseToString != null) {
        _effectiveController?.text = widget.parseToString?.call(value) ?? "";
      } else {
        _effectiveController?.text = value?.toString() ?? "";
      }
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
    final value =
        widget.parseFromString?.call(_effectiveController?.text ?? "");
    if (this.value != value) {
      didChange(value);
    }
  }
}
