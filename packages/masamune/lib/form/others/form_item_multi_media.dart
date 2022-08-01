part of masamune.form.others;

enum FormItemMultiMediaType {
  form,
  list,
}

/// Form widget for uploading multiple media files (images and videos) at once.
///
/// The value passed by [controller] and [onSaved] becomes a Json data of [DynamicMap].
///
/// ```
/// FormItemMultiMedia(
///   constroller: useMemoizedTextEditingController(),
///   onTap: (onUpdate){
///     final media = await UIMediaDialog();
///     onUpdate(media.path);
///   },
///   onSaved: (value){
///     context["image"] = value;
///   }
/// )
/// ```
class FormItemMultiMedia extends FormField<String> {
  /// Form widget for uploading multiple media files (images and videos) at once.
  ///
  /// The value passed by [controller] and [onSaved] becomes a Json data of [DynamicMap].
  ///
  /// ```
  /// FormItemMultiMedia(
  ///   constroller: useMemoizedTextEditingController(),
  ///   onTap: (onUpdate){
  ///     final media = await UIMediaDialog();
  ///     onUpdate(media.path);
  ///   },
  ///   onSaved: (value){
  ///     context["image"] = value;
  ///   }
  /// )
  /// ```
  FormItemMultiMedia({
    this.height = 100,
    this.color,
    this.onRemove,
    this.icon,
    this.controller,
    this.onPreSave,
    this.maxItem,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.typeKey = Const.type,
    this.pathKey = "path",
    this.items,
    this.addLabel = "Add",
    this.type = FormItemMultiMediaType.form,
    Widget Function(
      BuildContext context,
      FormItemMultiMediaItem data,
      Size size,
      void Function(dynamic fileOrURL, AssetType type) onUpdate,
      Function onRemove,
    )?
        builder,
    this.onTap,
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

  /// Additional labels when [type] is [FormItemMultiMediaType.list].
  final String addLabel;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Form type.
  final FormItemMultiMediaType type;

  /// File type.
  final String typeKey;

  /// path key.
  final String pathKey;

  /// Height of form.
  final double height;

  /// Color of the form.
  final Color? color;

  /// The form icon.
  final IconData? icon;

  /// Max item.
  final int? maxItem;

  /// Initial data list.
  final List<FormItemMultiMediaItem>? items;

  /// Callback in case of deletion.
  final void Function(FormItemMultiMediaItem data)? onRemove;

  /// Text Controller.
  final TextEditingController? controller;

  /// Callback for converting data when saving.
  final String Function(List<FormItemMultiMediaItem> data)? onPreSave;

  /// Defines the builder of the form.
  final Widget Function(
    BuildContext context,
    FormItemMultiMediaItem data,
    Size size,
    void Function(dynamic fileOrURL, AssetType type) onUpdate,
    Function onRemove,
  )? _builder;

  /// Size of each item.
  final Size size;

  /// What happens when you tap the Create New button.
  final void Function(
    void Function(dynamic fileOrURL, AssetType type) onUpdate,
  )? onTap;

  static Widget _defaultListBuilder(
    BuildContext context,
    FormItemMultiMediaItem data,
    Size size,
    void Function(dynamic fileOrURL, AssetType type) onUpdate,
    Function onRemove,
  ) {
    if (data.path.isNotEmpty) {
      if (data.type == AssetType.video) {
        return ListItem(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Video(
                NetworkVideoProvider(data.path!),
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
                controllable: true,
              ),
            ),
          ),
          title: Text(data.path!.last()),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                color: context.theme.textColor,
                onPressed: () {
                  onRemove();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      } else {
        return ListItem(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(
                data.path!,
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
              ),
            ),
          ),
          title: Text(data.path!.last()),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                color: context.theme.textColor,
                onPressed: () {
                  onRemove();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      }
    }
    return const Empty();
  }

  static Widget _defaultFormBuilder(
    BuildContext context,
    FormItemMultiMediaItem data,
    Size size,
    void Function(dynamic fileOrURL, AssetType type) onUpdate,
    Function onRemove,
  ) {
    if (data.path.isNotEmpty) {
      if (data.type == AssetType.video) {
        return InkWell(
          onLongPress: () {
            onRemove();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Video(
              NetworkVideoProvider(data.path!),
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
              controllable: true,
            ),
          ),
        );
      } else {
        return InkWell(
          onLongPress: () {
            onRemove();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              data.path!,
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

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// _MyState createState() => _MyState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
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

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      }
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
    _items = widget.items ?? [];
    if (widget.initialValue.isNotEmpty) {
      _items = _decodeJson(widget.initialValue);
    }
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
    if (widget.maxItem != null && widget.maxItem! <= _items.length) {
      return;
    }
    if (fileOrURL is String) {
      _items.add(FormItemMultiMediaItem(type: type, path: fileOrURL));
    }
    didChange(_encodeJson(_items));
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

  Widget _builder(BuildContext context, FormItemMultiMediaItem item) {
    if (widget._builder != null) {
      return widget._builder!.call(
        context,
        item,
        widget.size,
        _onUpdate,
        () => _onRemove(item),
      );
    }
    switch (widget.type) {
      case FormItemMultiMediaType.list:
        return FormItemMultiMedia._defaultListBuilder(
          context,
          item,
          widget.size,
          _onUpdate,
          () => _onRemove(item),
        );
      default:
        return FormItemMultiMedia._defaultFormBuilder(
          context,
          item,
          widget.size,
          _onUpdate,
          () => _onRemove(item),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (widget.type) {
      case FormItemMultiMediaType.list:
        return Padding(
          padding: widget.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReorderableListBuilder<FormItemMultiMediaItem>(
                source: _items,
                builder: (context, item, index) {
                  return [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _builder(context, item),
                    ),
                  ];
                },
                onReorder: (o, n, item, reordered) {
                  _items = reordered;
                  setValue(_encodeJson(_items));
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              if (widget.maxItem != null && widget.maxItem! > _items.length)
                ListTile(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap?.call(_onUpdate);
                    }
                  },
                  title: Text(
                    widget.addLabel.localize(),
                    textAlign: TextAlign.right,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: context.theme.textColor,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      default:
        return Container(
          alignment: Alignment.centerLeft,
          padding: widget.padding,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.maxItem != null && widget.maxItem! > _items.length)
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
                        if (widget.onTap != null) {
                          widget.onTap?.call(_onUpdate);
                        }
                      },
                    ),
                  ),
                ..._items.mapAndRemoveEmpty(
                  (item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _builder(context, item),
                    );
                  },
                ),
              ],
            ),
          ),
        );
    }
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
    final res = <DynamicMap>[];
    for (final tmp in items) {
      if (tmp.path.isNotEmpty) {
        res.add({
          widget.typeKey: _getTypeString(tmp.type),
          widget.pathKey: tmp.path,
        });
      } else {
        res.add({
          widget.typeKey: _getTypeString(tmp.type),
          widget.pathKey: tmp.path,
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
      if (tmp is DynamicMap) {
        if (tmp.containsKey(widget.pathKey)) {
          res.add(
            FormItemMultiMediaItem(
              path: tmp[widget.pathKey],
              type: tmp.containsKey(widget.typeKey)
                  ? _getType(tmp[widget.typeKey])
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

/// Class for storing various data to be uploaded for [FormItemMultiMedia].
@immutable
class FormItemMultiMediaItem {
  /// Class for storing various data to be uploaded for [FormItemMultiMedia].
  const FormItemMultiMediaItem({
    this.type = AssetType.image,
    this.path,
  });

  /// Specify the asset type.
  final AssetType type;

  /// File path.
  final String? path;

  /// Create a new [FormItemMultiMediaItem].
  FormItemMultiMediaItem copyWith({
    AssetType? type,
    String? path,
  }) {
    return FormItemMultiMediaItem(
      type: type ?? this.type,
      path: path ?? this.path,
    );
  }
}
