part of masamune.form;

/// Form item for uploading an image.
class FormItemImage extends FormField<String> {
  /// Form item for uploading an image.
  ///
  /// [key]: Key.
  /// [onTap]: Processing when tapped.
  /// Finally save the file using onUpdate.
  /// [controller]: Text ediging controller.
  /// [color]: The overall color if you have not uploaded an image.
  /// [icon]: Icon if you have not uploaded an image.
  /// [onSaved]: Processing when saved.
  /// [validator]: Processing when validated.
  /// [enabled]: True to enable.
  /// [dense]: True for dense.
  FormItemImage({
    Key? key,
    this.controller,
    required this.onTap,
    this.color,
    this.dense = false,
    this.icon = Icons.add_a_photo,
    void Function(String? value)? onSaved,
    String Function(String? value)? validator,
    String? initialURI,
    bool enabled = true,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: initialURI,
          enabled: enabled,
        );

  /// Processing when tapped.
  /// Finally save the file using onUpdate.
  final void Function(void Function(dynamic fileOrUrl) onUpdate) onTap;

  /// The overall color if you have not uploaded an image.
  final Color? color;

  /// Icon if you have not uploaded an image.
  final IconData icon;

  /// True for dense.
  final bool dense;

  /// Text ediging controller.
  final TextEditingController? controller;

  @override
  _FormItemImageState createState() => _FormItemImageState();
}

class _FormItemImageState extends FormFieldState<String> {
  TextEditingController? _controller;
  File? _data;
  File? _local;
  String? _path;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemImage get widget => super.widget as FormItemImage;

  void _onUpdate(dynamic fileOrUrl) {
    if (fileOrUrl is String) {
      if (fileOrUrl.isEmpty) {
        return;
      }
      setState(() {
        setValue(fileOrUrl);
        _path = fileOrUrl;
        _data = null;
      });
    } else if (fileOrUrl is File) {
      if (fileOrUrl.path.isEmpty) {
        return;
      }
      setState(() {
        setValue(fileOrUrl.path);
        _data = fileOrUrl;
        _path = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(FormItemImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(widget.controller?.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: () {
        if (!widget.enabled) {
          return;
        }
        widget.onTap.call(_onUpdate);
      },
      child: _buildImage(context),
    );
  }

  Widget _buildImage(BuildContext context) {
    final value = widget.initialValue.isNotEmpty
        ? widget.initialValue
        : _effectiveController?.text;
    if (_data != null) {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        constraints: const BoxConstraints.expand(height: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
          child: Image.file(_data!, fit: BoxFit.cover),
        ),
      );
    } else if (_path != null) {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        constraints: const BoxConstraints.expand(height: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
          child: Image(image: NetworkOrAsset.image(_path!), fit: BoxFit.cover),
        ),
      );
    } else if (value.isNotEmpty) {
      if (value!.startsWith("http")) {
        return Container(
          padding: widget.dense
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 10),
          constraints: const BoxConstraints.expand(height: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
            child: Image(image: NetworkOrAsset.image(value), fit: BoxFit.cover),
          ),
        );
      } else {
        _local ??= File(value);
        return Container(
            padding: widget.dense
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(vertical: 10),
            constraints: const BoxConstraints.expand(height: 200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
              child: Image.file(_local!, fit: BoxFit.cover),
            ));
      }
    } else {
      return Container(
          padding: widget.dense
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            constraints: const BoxConstraints.expand(height: 160),
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.color ?? Theme.of(context).disabledColor,
                    style: widget.dense ? BorderStyle.none : BorderStyle.solid),
                borderRadius: BorderRadius.circular(8.0)),
            child: Icon(widget.icon,
                size: 56,
                color: widget.color ?? Theme.of(context).disabledColor),
          ));
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController?.text != value) {
      _effectiveController?.text = value ?? "";
    }
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
