part of masamune.form.others;

/// Form widget for uploading media (Image and Video).
///
/// ```
/// FormItemMedia(
///   constroller: useMemoizedTextEditingController(),
///   onTap: (onUpdate){
///     final media = await UIMediaDialog();
///     onUpdate(media.path);
///   },
///   onSaved: (value){
///     context["url"] = value;
///   }
/// )
/// ```
class FormItemMedia extends FormField<String> {
  /// Form widget for uploading media (Image and Video).
  ///
  /// ```
  /// FormItemMedia(
  ///   constroller: useMemoizedTextEditingController(),
  ///   onTap: (onUpdate){
  ///     final media = await UIMediaDialog();
  ///     onUpdate(media.path);
  ///   },
  ///   onSaved: (value){
  ///     context["url"] = value;
  ///   }
  /// )
  /// ```
  FormItemMedia({
    Key? key,
    this.controller,
    required this.onTap,
    this.color,
    this.hintText = "",
    this.errorText = "",
    this.allowEmpty = false,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.dense = false,
    this.height = 200,
    this.videoExtensionList = const [
      "mp4",
      "ogv",
      "webm",
      "avi",
      "mpeg",
    ],
    this.showOverlayIcon = true,
    this.overlayColor = Colors.black38,
    this.overlayIconColor = Colors.white70,
    this.icon = Icons.add_a_photo,
    void Function(String? value)? onSaved,
    String Function(String? value)? validator,
    String? initialURI,
    bool enabled = true,
    this.type = PlatformMediaType.all,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: (value) {
            if (!allowEmpty && errorText.isNotEmpty && value.isEmpty) {
              return errorText;
            }
            return validator?.call(value);
          },
          initialValue: initialURI,
          enabled: enabled,
        );

  /// The height of the text display when an error occurs.
  static const double errorTextHeight = 20;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Processing when tapped.
  ///
  /// Finally save the file using [onUpdate].
  final void Function(void Function(dynamic fileOrUrl) onUpdate) onTap;

  /// The overall color if you have not uploaded an image and video.
  final Color? color;

  /// Icon if you have not uploaded an image and video.
  final IconData icon;

  /// Displays the settings icon in an overlay.
  final bool showOverlayIcon;

  /// Color of the overlay.
  final Color overlayColor;

  /// Color of the overlay icon.
  final Color overlayIconColor;

  /// `True` for dense.
  final bool dense;

  /// Height of form.
  final double height;

  /// `True` if the data should be empty.
  final bool allowEmpty;

  /// Hint label.
  final String hintText;

  /// Error label.
  final String errorText;

  /// Video extension list.
  final List<String> videoExtensionList;

  /// Media type.
  final PlatformMediaType type;

  /// Text ediging controller.
  final TextEditingController? controller;

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
  _FormItemMediaState createState() => _FormItemMediaState();
}

class _FormItemMediaState extends FormFieldState<String> {
  TextEditingController? _controller;
  String? _path;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMedia get widget => super.widget as FormItemMedia;

  void _onUpdate(dynamic fileOrUrl) {
    if (fileOrUrl is String) {
      if (fileOrUrl.isEmpty) {
        return;
      }
      setState(() {
        setValue(fileOrUrl);
        _path = fileOrUrl;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      setValue(widget.controller?.text ?? value);
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(FormItemMedia oldWidget) {
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
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (!widget.enabled) {
                return;
              }
              widget.onTap.call(_onUpdate);
            },
            child: _buildMedia(context),
          ),
          if (errorText.isNotEmpty)
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Text(errorText ?? "",
                    style: Theme.of(context).inputDecorationTheme.errorStyle),
                height:
                    errorText.isNotEmpty ? FormItemMedia.errorTextHeight : 0)
        ],
      ),
    );
  }

  PlatformMediaType _platformMediaType(String path) {
    if (widget.type != PlatformMediaType.all) {
      return widget.type;
    }
    final uri = Uri.tryParse(path);
    if (uri == null) {
      return PlatformMediaType.image;
    }
    final ext = uri.path.split(".").lastOrNull;
    if (ext == null) {
      return PlatformMediaType.image;
    }
    return widget.videoExtensionList.contains(ext)
        ? PlatformMediaType.video
        : PlatformMediaType.image;
  }

  Widget _showMediaFromPath(String path) {
    final type = _platformMediaType(path);
    switch (type) {
      case PlatformMediaType.video:
        return _buiildCover(
          context,
          Video(
            NetworkOrAsset.video(path),
            fit: BoxFit.cover,
            autoplay: true,
            mute: true,
            mixWithOthers: true,
          ),
        );
      default:
        return _buiildCover(
          context,
          Image(
            image: NetworkOrAsset.image(path),
            fit: BoxFit.cover,
          ),
        );
    }
  }

  Widget _buiildCover(BuildContext context, Widget child) {
    if (!widget.showOverlayIcon) {
      return child;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ColoredBox(
          color: widget.overlayColor,
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.overlayIconColor,
              size: 48,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    final value = widget.initialValue.isNotEmpty
        ? widget.initialValue
        : _effectiveController?.text;
    if (_path != null) {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints.expand(
            height: errorText.isNotEmpty
                ? (widget.height - FormItemMedia.errorTextHeight)
                : widget.height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
          child: _showMediaFromPath(_path!),
        ),
      );
    } else if (value.isNotEmpty) {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints.expand(
            height: errorText.isNotEmpty
                ? (widget.height - FormItemMedia.errorTextHeight)
                : widget.height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
          child: _showMediaFromPath(value!),
        ),
      );
    } else {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          constraints: BoxConstraints.expand(
              height: errorText.isNotEmpty
                  ? (widget.height - FormItemMedia.errorTextHeight)
                  : widget.height),
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.color ?? Theme.of(context).disabledColor,
                  style: widget.dense ? BorderStyle.none : BorderStyle.solid),
              borderRadius: BorderRadius.circular(8.0)),
          child: Icon(widget.icon,
              size: 56, color: widget.color ?? Theme.of(context).disabledColor),
        ),
      );
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
