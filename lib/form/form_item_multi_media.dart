part of masamune.form;

class FormItemMultiMedia extends FormField<String> {
  FormItemMultiMedia({
    this.height = 100,
    this.color,
    this.onRemove,
    this.icon,
    this.controller,
    this.onPreSave,
    required this.items,
    Widget Function(
            BuildContext context,
            FormItemMultiMediaItem data,
            Size size,
            void Function(dynamic fileOrURL, AssetType type) onUpdate,
            Function onRemove)
        builder = _defaultBuilder,
    this.onPressed,
    Key? key,
    void Function(String? value)? onSaved,
    String Function(String? value)? validator,
    String? initialJson,
    bool enabled = true,
  })  : size = Size(height - 20, height - 20),
        _builder = builder,
        super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: initialJson,
          enabled: enabled,
        );

  final double height;
  final Color? color;
  final IconData? icon;
  final List<FormItemMultiMediaItem> items;
  final void Function(FormItemMultiMediaItem data)? onRemove;
  final TextEditingController? controller;
  final String Function(List<FormItemMultiMediaItem> data)? onPreSave;
  final Widget Function(
      BuildContext context,
      FormItemMultiMediaItem data,
      Size size,
      void Function(dynamic fileOrURL, AssetType type) onUpdate,
      Function onRemove) _builder;
  final Size size;
  final void Function(
      void Function(dynamic fileOrURL, AssetType type) onUpdate)? onPressed;

  static Widget _defaultBuilder(
      BuildContext context,
      FormItemMultiMediaItem data,
      Size size,
      void Function(dynamic fileOrURL, AssetType type) onUpdate,
      Function onRemove) {
    if (data.type == AssetType.video) {
      if (data.file != null) {
        return InkWell(
          onLongPress: () {
            onRemove();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Video.file(
              data.file,
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
              controllable: true,
            ),
          ),
        );
      } else if (data.url.isNotEmpty) {
        return InkWell(
          onLongPress: () {
            onRemove();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Video.network(
              data.url!,
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
              controllable: true,
            ),
          ),
        );
      }
    } else {
      if (data.file != null) {
        return InkWell(
            onLongPress: () {
              onRemove();
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.file(data.file!,
                    fit: BoxFit.cover,
                    height: size.height,
                    width: size.width)));
      } else if (data.url.isNotEmpty) {
        return InkWell(
          onLongPress: () {
            onRemove();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              data.url!,
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
            ),
          ),
        );
      }
    }
    return const Empty();
  }

  @override
  _FormItemMultiMediaState createState() => _FormItemMultiMediaState();
}

class _FormItemMultiMediaState extends FormFieldState<String> {
  late List<FormItemMultiMediaItem> _items;
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMultiMedia get widget => super.widget as FormItemMultiMedia;

  @override
  void didUpdateWidget(FormItemMultiMedia oldWidget) {
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
  void initState() {
    super.initState();
    _items = widget.items;
    if (widget.initialValue.isNotEmpty)
      _items = _decodeJson(widget.initialValue);
    if (widget.controller.isNotEmpty) {
      _items = _decodeJson(widget.controller?.text);
    }
    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  void _onUpdate(dynamic fileOrURL, AssetType type) {
    if (fileOrURL is File) {
      _items.add(FormItemMultiMediaItem(type: type, file: fileOrURL));
    } else if (fileOrURL is String) {
      _items.add(FormItemMultiMediaItem(type: type, url: fileOrURL));
    }
    setValue(_encodeJson(_items));
    setState(() {});
  }

  void _onRemove(dynamic dataOrIndex) {
    if (dataOrIndex is FormItemMultiMediaItem) {
      widget.onRemove?.call(dataOrIndex);
      _items.remove(dataOrIndex);
    } else if (dataOrIndex is int) {
      if (widget.onRemove != null) {
        widget.onRemove?.call(_items.removeAt(dataOrIndex));
      } else {
        _items.removeAt(dataOrIndex);
      }
    }
    setValue(_encodeJson(_items));
    setState(() {});
  }

  @override
  void save() {
    setValue(_encodeJson(_items));
    super.save();
  }

  @override
  bool validate() {
    setValue(_encodeJson(_items));
    return super.validate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: widget.size.width,
              height: widget.size.height,
              margin: const EdgeInsets.only(right: 10),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: widget.color ?? context.theme.disabledColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  widget.icon ?? Icons.photo,
                  color: widget.color ?? context.theme.disabledColor,
                  size: widget.height / 3.0,
                ),
                onPressed: () {
                  if (widget.onPressed != null) {
                    widget.onPressed?.call(_onUpdate);
                  }
                },
              ),
            ),
            ..._items.mapAndRemoveEmpty(
              (item) {
                final widget = this.widget._builder(
                      context,
                      item,
                      this.widget.size,
                      _onUpdate,
                      () => _onRemove(item),
                    );
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: widget,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController?.text != value) {
      _effectiveController?.text = value ?? "";
    }
    final res = _decodeJson(_effectiveController?.text);
    if (res.length != _items.length) {
      _items = res;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  String _encodeJson(List<FormItemMultiMediaItem> items) {
    final res = <Map<String, dynamic>>[];
    for (final tmp in items) {
      if (tmp.url.isNotEmpty) {
        res.add({
          "type": _getTypeString(tmp.type),
          "url": tmp.url,
        });
      } else {
        res.add({
          "type": _getTypeString(tmp.type),
          "file": tmp.file?.path,
        });
      }
    }
    return jsonEncode(res);
  }

  List<FormItemMultiMediaItem> _decodeJson(String? value) {
    if (value.isEmpty) {
      return <FormItemMultiMediaItem>[];
    }
    final res = <FormItemMultiMediaItem>[];
    final list = jsonDecodeAsList(value!);
    for (final tmp in list) {
      if (tmp is Map<String, dynamic>) {
        if (tmp.containsKey("file")) {
          res.add(
            FormItemMultiMediaItem(
              file: File(tmp["file"]),
              type: tmp.containsKey("type")
                  ? _getType(tmp["type"])
                  : AssetType.image,
            ),
          );
        } else if (tmp.containsKey("url")) {
          res.add(
            FormItemMultiMediaItem(
              url: tmp["url"],
              type: tmp.containsKey("type")
                  ? _getType(tmp["type"])
                  : AssetType.image,
            ),
          );
        }
      }
    }
    return res;
  }

  AssetType _getType(String type) {
    switch (type) {
      case "video":
        return AssetType.video;
      default:
        return AssetType.image;
    }
  }

  String _getTypeString(AssetType type) {
    switch (type) {
      case AssetType.video:
        return "video";
      default:
        return "image";
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text = widget.initialValue ?? "";
      _items = _decodeJson(_effectiveController?.text);
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value) {
      didChange(_effectiveController?.text);
    }
  }
}

class FormItemMultiMediaItem {
  const FormItemMultiMediaItem({
    this.type = AssetType.image,
    this.file,
    this.url,
  });
  final AssetType type;
  final File? file;
  final String? url;
}
