part of masamune_ui.form.others;

/// Form widget for uploading image for avatar.
///
/// ```
/// FormItemAvatarImage(
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
class FormItemAvatarImage extends FormField<String> {
  /// Form widget for uploading image for avatar.
  ///
  /// ```
  /// FormItemAvatarImage(
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
  FormItemAvatarImage({
    Key? key,
    this.label = "",
    this.onTap,
    this.textColor,
    this.backgroundColor,
    this.controller,
    bool enabled = true,
    this.hintText = "",
    this.errorText = "",
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.allowEmpty = false,
    this.icon = Icons.add_a_photo,
    this.showOverlayIcon = true,
    this.overlayColor = Colors.black38,
    this.overlayIconColor = Colors.white70,
    void Function(String? value)? onSaved,
    String Function(String? value)? validator,
    String? initialURI,
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

  /// Button label.
  final String label;

  /// Button label text color.
  final Color? textColor;

  /// Background color of the button.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Hint label.
  final String hintText;

  /// Error label.
  final String errorText;

  /// Text ediging controller.
  final TextEditingController? controller;

  /// `True` if the data should be empty.
  final bool allowEmpty;

  /// Processing when tapped.
  ///
  /// Finally save the file using [onUpdate].
  final void Function(void Function(dynamic fileOrUrl) onUpdate)? onTap;

  /// Displays the settings icon in an overlay.
  final bool showOverlayIcon;

  /// Color of the overlay.
  final Color overlayColor;

  /// Color of the overlay icon.
  final Color overlayIconColor;

  /// Icon if you have not uploaded an image and video.
  final IconData icon;

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
  _FormItemAvatarImageState createState() => _FormItemAvatarImageState();
}

class _FormItemAvatarImageState extends FormFieldState<String> {
  TextEditingController? _controller;
  String? _path;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemAvatarImage get widget => super.widget as FormItemAvatarImage;

  void _onUpdate(dynamic fileOrUrl) {
    if (fileOrUrl is String) {
      if (fileOrUrl.isEmpty) {
        return;
      }
      setState(() {
        didChange(fileOrUrl);
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
  void didUpdateWidget(FormItemAvatarImage oldWidget) {
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
    final image = _buildImageProvider(context);
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: widget.enabled && widget.onTap != null
                  ? () {
                      widget.onTap?.call(_onUpdate);
                    }
                  : null,
              child: SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  backgroundColor: context.theme.disabledColor,
                  backgroundImage: image,
                  child: image == null
                      ? Icon(
                          widget.icon,
                          color: context.theme.textColorOnPrimary,
                          size: 40,
                        )
                      : null,
                ),
              ),
            ),
            if (widget.label.isNotEmpty)
              TextButton(
                style: TextButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: widget.enabled
                      ? (widget.backgroundColor ?? context.theme.primaryColor)
                      : context.theme.disabledColor,
                ),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.textColor ?? context.theme.textColorOnPrimary,
                  ),
                ),
                onPressed: widget.enabled && widget.onTap != null
                    ? () {
                        widget.onTap?.call(_onUpdate);
                      }
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _buildImageProvider(BuildContext context) {
    final value = widget.initialValue.isNotEmpty
        ? widget.initialValue
        : _effectiveController?.text;
    if (_path != null) {
      return Asset.image(_path!);
    } else if (value.isNotEmpty) {
      return Asset.image(value!);
    } else {
      return null;
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
