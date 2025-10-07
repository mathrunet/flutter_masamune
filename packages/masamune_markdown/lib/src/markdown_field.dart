part of "/masamune_markdown.dart";

/// A field for editing Markdown content with block-based structure.
///
/// ブロックベースの構造でMarkdownコンテンツを編集するフィールド。
class MarkdownField extends StatefulWidget {
  /// Creates a [MarkdownField].
  ///
  /// [MarkdownField]を作成します。
  const MarkdownField({
    required this.controller,
    super.key,
    this.focusNode,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionControls,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.scrollController,
    this.scrollPhysics,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.enabled,
    this.rendererIgnoresPointer = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.contextMenuBuilder,
  });

  /// Controller for the markdown editor.
  ///
  /// Markdownエディタのコントローラー。
  final MarkdownController controller;

  /// Focus node for the editor.
  ///
  /// エディタのフォーカスノード。
  final FocusNode? focusNode;

  /// Whether the text field is read-only.
  ///
  /// テキストフィールドが読み取り専用かどうか。
  final bool readOnly;

  /// Whether the text field should be autofocused.
  ///
  /// テキストフィールドがオートフォーカスされるべきかどうか。
  final bool autofocus;

  /// Whether to obscure the text being edited.
  ///
  /// 編集中のテキストを隠すかどうか。
  final bool obscureText;

  /// Whether to enable autocorrect.
  ///
  /// オートコレクトを有効にするかどうか。
  final bool autocorrect;

  /// Whether to enable suggestions.
  ///
  /// サジェストを有効にするかどうか。
  final bool enableSuggestions;

  /// Maximum number of lines.
  ///
  /// 最大行数。
  final int? maxLines;

  /// Minimum number of lines.
  ///
  /// 最小行数。
  final int? minLines;

  /// Whether the field should expand to fill the parent.
  ///
  /// フィールドが親を埋めるように拡張すべきかどうか。
  final bool expands;

  /// Text alignment.
  ///
  /// テキストの配置。
  final TextAlign textAlign;

  /// Text direction.
  ///
  /// テキストの方向。
  final TextDirection? textDirection;

  /// Cursor width.
  ///
  /// カーソルの幅。
  final double cursorWidth;

  /// Cursor height.
  ///
  /// カーソルの高さ。
  final double? cursorHeight;

  /// Cursor radius.
  ///
  /// カーソルの半径。
  final Radius? cursorRadius;

  /// Cursor color.
  ///
  /// カーソルの色。
  final Color? cursorColor;

  /// Selection color.
  ///
  /// 選択色。
  final Color? selectionColor;

  /// Selection controls.
  ///
  /// 選択コントロール。
  final TextSelectionControls? selectionControls;

  /// Keyboard type.
  ///
  /// キーボードタイプ。
  final TextInputType? keyboardType;

  /// Text input action.
  ///
  /// テキスト入力アクション。
  final TextInputAction? textInputAction;

  /// Text capitalization.
  ///
  /// テキストの大文字化。
  final TextCapitalization textCapitalization;

  /// Text style.
  ///
  /// テキストスタイル。
  final TextStyle? style;

  /// Strut style.
  ///
  /// ストラットスタイル。
  final StrutStyle? strutStyle;

  /// Text width basis.
  ///
  /// テキスト幅の基準。
  final TextWidthBasis textWidthBasis;

  /// Text height behavior.
  ///
  /// テキストの高さの動作。
  final TextHeightBehavior? textHeightBehavior;

  /// Scroll controller.
  ///
  /// スクロールコントローラー。
  final ScrollController? scrollController;

  /// Scroll physics.
  ///
  /// スクロール物理演算。
  final ScrollPhysics? scrollPhysics;

  /// Called when the text changes.
  ///
  /// テキストが変更されたときに呼ばれます。
  final ValueChanged<List<MarkdownFieldValue>>? onChanged;

  /// Called when editing is complete.
  ///
  /// 編集が完了したときに呼ばれます。
  final VoidCallback? onEditingComplete;

  /// Called when the user submits.
  ///
  /// ユーザーが送信したときに呼ばれます。
  final ValueChanged<List<MarkdownFieldValue>>? onSubmitted;

  /// Called when the user taps.
  ///
  /// ユーザーがタップしたときに呼ばれます。
  final VoidCallback? onTap;

  /// Called when the user taps outside.
  ///
  /// ユーザーが外側をタップしたときに呼ばれます。
  final TapRegionCallback? onTapOutside;

  /// Whether the field is enabled.
  ///
  /// フィールドが有効かどうか。
  final bool? enabled;

  /// Whether the renderer ignores pointer events.
  ///
  /// レンダラーがポインタイベントを無視するかどうか。
  final bool rendererIgnoresPointer;

  /// Padding for scrolling to reveal the cursor.
  ///
  /// カーソルを表示するためのスクロール時のパディング。
  final EdgeInsets scrollPadding;

  /// Whether to enable interactive selection.
  ///
  /// インタラクティブ選択を有効にするかどうか。
  final bool enableInteractiveSelection;

  /// Builder for the context menu.
  ///
  /// コンテキストメニューのビルダー。
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField>
    with TickerProviderStateMixin
    implements TextInputClient, TextSelectionDelegate {
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  TextInputConnection? _textInputConnection;

  // Selection state
  TextSelection _selection = const TextSelection.collapsed(offset: 0);
  TextSelection? _composingRegion;

  // For tracking cursor blink
  bool _showCursor = true;
  late AnimationController _cursorBlinkController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? widget.controller.focusNode;
    _scrollController = widget.scrollController ?? ScrollController();
    _focusNode.addListener(_handleFocusChanged);
    widget.controller.addListener(_handleControllerChanged);

    // Setup cursor blink
    _cursorBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(_onCursorBlink);
  }

  @override
  void didUpdateWidget(MarkdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      _focusNode = widget.focusNode ?? widget.controller.focusNode;
      _focusNode.addListener(_handleFocusChanged);
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _closeInputConnectionIfNeeded();
    _cursorBlinkController.dispose();
    _focusNode.removeListener(_handleFocusChanged);
    widget.controller.removeListener(_handleControllerChanged);
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onCursorBlink() {
    setState(() {
      _showCursor = _cursorBlinkController.value < 0.5;
    });
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _openInputConnection();
      _cursorBlinkController.repeat();
    } else {
      _closeInputConnectionIfNeeded();
      _cursorBlinkController.stop();
      _showCursor = false;
    }
    setState(() {});
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  void _openInputConnection() {
    if (!_hasInputConnection) {
      final textInputConfiguration = TextInputConfiguration(
        inputType: widget.keyboardType ?? TextInputType.multiline,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        inputAction: widget.textInputAction ?? TextInputAction.newline,
        textCapitalization: widget.textCapitalization,
        keyboardAppearance: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
      );
      _textInputConnection = TextInput.attach(this, textInputConfiguration);
      _textInputConnection!.show();
      _updateRemoteEditingValue();
    }
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection!.close();
      _textInputConnection = null;
    }
  }

  bool get _hasInputConnection =>
      _textInputConnection != null && _textInputConnection!.attached;

  void _updateRemoteEditingValue() {
    if (!_hasInputConnection) {
      return;
    }

    final text = _getPlainText();
    _textInputConnection!.setEditingState(
      TextEditingValue(
        text: text,
        selection: _selection,
        composing: _composingRegion != null
            ? TextRange(
                start: _composingRegion!.start,
                end: _composingRegion!.end,
              )
            : TextRange.empty,
      ),
    );
  }

  String _getPlainText() {
    final buffer = StringBuffer();
    final fields = widget.controller.value ?? [];

    for (final field in fields) {
      for (final block in field.children) {
        if (block is MarkdownParagraphBlockValue) {
          for (var i = 0; i < block.children.length; i++) {
            final line = block.children[i];
            for (final span in line.children) {
              buffer.write(span.value);
            }
            // Add newline except for the last line
            if (i < block.children.length - 1) {
              buffer.writeln();
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  // TextInputClient implementation
  @override
  void updateEditingValue(TextEditingValue value) {
    if (widget.readOnly) {
      return;
    }

    final oldValue = currentTextEditingValue;

    // Update selection and composing region first
    _selection = value.selection;
    _composingRegion = value.composing.isValid
        ? TextSelection(
            baseOffset: value.composing.start,
            extentOffset: value.composing.end,
          )
        : null;

    if (oldValue.text != value.text) {
      // Text changed, update controller
      final oldText = oldValue.text;
      final newText = value.text;

      // Find the difference
      var start = 0;
      while (start < oldText.length &&
          start < newText.length &&
          oldText[start] == newText[start]) {
        start++;
      }

      var oldEnd = oldText.length;
      var newEnd = newText.length;
      while (oldEnd > start &&
          newEnd > start &&
          oldText[oldEnd - 1] == newText[newEnd - 1]) {
        oldEnd--;
        newEnd--;
      }

      final replacementText = newText.substring(start, newEnd);
      widget.controller.replaceText(start, oldEnd, replacementText);
      widget.onChanged?.call(widget.controller.value ?? []);

      // Trigger rebuild to reflect changes
      setState(() {});
    } else {
      // Only selection changed
      setState(() {});
    }
  }

  @override
  void didChangeInputControl(
    TextInputControl? oldControl,
    TextInputControl? newControl,
  ) {
    // Handle input control changes
  }

  @override
  void performAction(TextInputAction action) {
    switch (action) {
      case TextInputAction.newline:
        // TODO: implement newline
        break;
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.search:
      case TextInputAction.send:
        widget.onEditingComplete?.call();
        break;
      default:
        break;
    }
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {
    // Handle platform-specific commands if needed
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    // TODO: implement floating cursor for iOS
  }

  @override
  void connectionClosed() {
    if (_hasInputConnection) {
      _textInputConnection!.connectionClosedReceived();
      _textInputConnection = null;
    }
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue get currentTextEditingValue => TextEditingValue(
        text: _getPlainText(),
        selection: _selection,
        composing: _composingRegion != null
            ? TextRange(
                start: _composingRegion!.start,
                end: _composingRegion!.end,
              )
            : TextRange.empty,
      );

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // TODO: implement autocorrection prompt
  }

  @override
  void insertTextPlaceholder(Size size) {
    // TODO: implement text placeholder for iOS
  }

  @override
  void removeTextPlaceholder() {
    // TODO: implement text placeholder for iOS
  }

  @override
  void showToolbar() {
    // TODO: implement toolbar
  }

  @override
  void insertContent(KeyboardInsertedContent content) {
    // TODO: implement keyboard inserted content
  }

  @override
  void performSelector(String selectorName) {
    // Handle selector for iOS
  }

  // TextSelectionDelegate implementation
  @override
  TextEditingValue get textEditingValue => currentTextEditingValue;

  set textEditingValue(TextEditingValue value) {
    updateEditingValue(value);
  }

  @override
  void copySelection(SelectionChangedCause cause) {
    final text = _selection.textInside(_getPlainText());
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  void cutSelection(SelectionChangedCause cause) {
    if (widget.readOnly) {
      return;
    }
    final text = _selection.textInside(_getPlainText());
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      // TODO: implement actual deletion
    }
  }

  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    if (widget.readOnly) {
      return;
    }
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      // TODO: implement actual paste
    }
  }

  @override
  void selectAll(SelectionChangedCause cause) {
    final text = _getPlainText();
    _selection = TextSelection(
      baseOffset: 0,
      extentOffset: text.length,
    );
    setState(() {});
    _updateRemoteEditingValue();
  }

  @override
  void bringIntoView(TextPosition position) {
    // TODO: implement auto-scroll to cursor
  }

  @override
  void hideToolbar([bool hideHandles = true]) {
    // TODO: implement toolbar hiding
  }

  @override
  bool get cutEnabled => !widget.readOnly && _selection.isValid;

  @override
  bool get copyEnabled => _selection.isValid;

  @override
  bool get pasteEnabled => !widget.readOnly;

  @override
  bool get selectAllEnabled => true;

  @override
  bool get liveTextInputEnabled => false;

  @override
  bool get lookUpEnabled => true;

  @override
  bool get searchWebEnabled => true;

  @override
  bool get shareEnabled => true;

  @override
  void userUpdateTextEditingValue(
    TextEditingValue value,
    SelectionChangedCause cause,
  ) {
    updateEditingValue(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = widget.style ?? theme.textTheme.bodyLarge;
    final cursorColor = widget.cursorColor ?? theme.colorScheme.primary;
    final selectionColor = widget.selectionColor ??
        theme.textSelectionTheme.selectionColor ??
        theme.colorScheme.primary.withValues(alpha: 0.4);

    Widget child = _MarkdownRenderObjectWidget(
      controller: widget.controller,
      focusNode: _focusNode,
      selection: _selection,
      composingRegion: _composingRegion,
      showCursor: _focusNode.hasFocus && _showCursor,
      style: defaultStyle!,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection ?? Directionality.of(context),
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      strutStyle: widget.strutStyle,
      onSelectionChanged: (selection, cause) {
        setState(() {
          _selection = selection;
          _cursorBlinkController.reset();
          _cursorBlinkController.repeat();
        });
        _updateRemoteEditingValue();
      },
      onTap: () {
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
        widget.onTap?.call();
      },
    );

    if (widget.scrollController != null || !widget.expands) {
      child = SingleChildScrollView(
        controller: _scrollController,
        physics: widget.scrollPhysics,
        padding: widget.scrollPadding,
        child: child,
      );
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: child,
    );
  }
}

/// Internal RenderObjectWidget for markdown editing.
///
/// Markdown編集用の内部RenderObjectWidget。
class _MarkdownRenderObjectWidget extends LeafRenderObjectWidget {
  const _MarkdownRenderObjectWidget({
    required this.controller,
    required this.focusNode,
    required this.selection,
    required this.showCursor,
    required this.style,
    required this.cursorWidth,
    required this.cursorColor,
    required this.selectionColor,
    required this.textAlign,
    required this.textDirection,
    required this.textWidthBasis,
    required this.onSelectionChanged,
    required this.onTap,
    this.composingRegion,
    this.cursorHeight,
    this.cursorRadius,
    this.textHeightBehavior,
    this.strutStyle,
  });

  final MarkdownController controller;
  final FocusNode focusNode;
  final TextSelection selection;
  final TextSelection? composingRegion;
  final bool showCursor;
  final TextStyle style;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color cursorColor;
  final Color selectionColor;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final StrutStyle? strutStyle;
  final SelectionChangedCallback onSelectionChanged;
  final VoidCallback? onTap;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMarkdownEditor(
      controller: controller,
      focusNode: focusNode,
      selection: selection,
      composingRegion: composingRegion,
      showCursor: showCursor,
      style: style,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      textAlign: textAlign,
      textDirection: textDirection,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      strutStyle: strutStyle,
      onSelectionChanged: onSelectionChanged,
      onTap: onTap,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMarkdownEditor renderObject,
  ) {
    renderObject
      ..controller = controller
      ..focusNode = focusNode
      ..selection = selection
      ..composingRegion = composingRegion
      ..showCursor = showCursor
      ..style = style
      ..cursorWidth = cursorWidth
      ..cursorHeight = cursorHeight
      ..cursorRadius = cursorRadius
      ..cursorColor = cursorColor
      ..selectionColor = selectionColor
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..strutStyle = strutStyle
      .._onSelectionChanged = onSelectionChanged
      .._onTap = onTap;
  }
}

/// RenderBox for markdown editor.
///
/// Markdownエディタ用のRenderBox。
class _RenderMarkdownEditor extends RenderBox {
  _RenderMarkdownEditor({
    required MarkdownController controller,
    required FocusNode focusNode,
    required TextSelection selection,
    required bool showCursor,
    required TextStyle style,
    required double cursorWidth,
    required Color cursorColor,
    required Color selectionColor,
    required TextAlign textAlign,
    required TextDirection textDirection,
    required TextWidthBasis textWidthBasis,
    required SelectionChangedCallback onSelectionChanged,
    required VoidCallback? onTap,
    TextSelection? composingRegion,
    double? cursorHeight,
    Radius? cursorRadius,
    TextHeightBehavior? textHeightBehavior,
    StrutStyle? strutStyle,
  })  : _controller = controller,
        _focusNode = focusNode,
        _selection = selection,
        _composingRegion = composingRegion,
        _showCursor = showCursor,
        _style = style,
        _cursorWidth = cursorWidth,
        _cursorHeight = cursorHeight,
        _cursorRadius = cursorRadius,
        _cursorColor = cursorColor,
        _selectionColor = selectionColor,
        _textAlign = textAlign,
        _textDirection = textDirection,
        _textWidthBasis = textWidthBasis,
        _textHeightBehavior = textHeightBehavior,
        _strutStyle = strutStyle,
        _onSelectionChanged = onSelectionChanged,
        _onTap = onTap;

  MarkdownController _controller;
  MarkdownController get controller => _controller;
  set controller(MarkdownController value) {
    if (_controller == value) {
      return;
    }
    _controller.removeListener(_handleControllerChanged);
    _controller = value;
    _controller.addListener(_handleControllerChanged);
    markNeedsPaint();
  }

  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;
  set focusNode(FocusNode value) {
    if (_focusNode == value) {
      return;
    }
    _focusNode = value;
  }

  TextSelection _selection;
  TextSelection get selection => _selection;
  set selection(TextSelection value) {
    if (_selection == value) {
      return;
    }
    _selection = value;
    markNeedsPaint();
  }

  TextSelection? _composingRegion;
  TextSelection? get composingRegion => _composingRegion;
  set composingRegion(TextSelection? value) {
    if (_composingRegion == value) {
      return;
    }
    _composingRegion = value;
    markNeedsPaint();
  }

  bool _showCursor;
  bool get showCursor => _showCursor;
  set showCursor(bool value) {
    if (_showCursor == value) {
      return;
    }
    _showCursor = value;
    markNeedsPaint();
  }

  TextStyle _style;
  TextStyle get style => _style;
  set style(TextStyle value) {
    if (_style == value) {
      return;
    }
    _style = value;
    _textPainter = null;
    markNeedsLayout();
  }

  double _cursorWidth;
  double get cursorWidth => _cursorWidth;
  set cursorWidth(double value) {
    if (_cursorWidth == value) {
      return;
    }
    _cursorWidth = value;
    markNeedsPaint();
  }

  double? _cursorHeight;
  double? get cursorHeight => _cursorHeight;
  set cursorHeight(double? value) {
    if (_cursorHeight == value) {
      return;
    }
    _cursorHeight = value;
    markNeedsPaint();
  }

  Radius? _cursorRadius;
  Radius? get cursorRadius => _cursorRadius;
  set cursorRadius(Radius? value) {
    if (_cursorRadius == value) {
      return;
    }
    _cursorRadius = value;
    markNeedsPaint();
  }

  Color _cursorColor;
  Color get cursorColor => _cursorColor;
  set cursorColor(Color value) {
    if (_cursorColor == value) {
      return;
    }
    _cursorColor = value;
    markNeedsPaint();
  }

  Color _selectionColor;
  Color get selectionColor => _selectionColor;
  set selectionColor(Color value) {
    if (_selectionColor == value) {
      return;
    }
    _selectionColor = value;
    markNeedsPaint();
  }

  TextAlign _textAlign;
  TextAlign get textAlign => _textAlign;
  set textAlign(TextAlign value) {
    if (_textAlign == value) {
      return;
    }
    _textAlign = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextWidthBasis _textWidthBasis;
  TextWidthBasis get textWidthBasis => _textWidthBasis;
  set textWidthBasis(TextWidthBasis value) {
    if (_textWidthBasis == value) {
      return;
    }
    _textWidthBasis = value;
    markNeedsLayout();
  }

  TextHeightBehavior? _textHeightBehavior;
  TextHeightBehavior? get textHeightBehavior => _textHeightBehavior;
  set textHeightBehavior(TextHeightBehavior? value) {
    if (_textHeightBehavior == value) {
      return;
    }
    _textHeightBehavior = value;
    markNeedsLayout();
  }

  StrutStyle? _strutStyle;
  StrutStyle? get strutStyle => _strutStyle;
  set strutStyle(StrutStyle? value) {
    if (_strutStyle == value) {
      return;
    }
    _strutStyle = value;
    markNeedsLayout();
  }

  SelectionChangedCallback _onSelectionChanged;

  VoidCallback? _onTap;

  TextPainter? _textPainter;

  // Tap tracking
  Offset? _lastTapDownPosition;

  void _handleControllerChanged() {
    _textPainter = null; // Clear cache when controller changes
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void detach() {
    _controller.removeListener(_handleControllerChanged);
    super.detach();
  }

  String _buildPlainText() {
    final buffer = StringBuffer();
    final fields = _controller.value ?? [];

    for (final field in fields) {
      for (final block in field.children) {
        if (block is MarkdownParagraphBlockValue) {
          for (var i = 0; i < block.children.length; i++) {
            final line = block.children[i];
            for (final span in line.children) {
              buffer.write(span.value);
            }
            // Add newline except for the last line
            if (i < block.children.length - 1) {
              buffer.writeln();
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  TextPainter _getTextPainter() {
    if (_textPainter != null) {
      return _textPainter!;
    }

    final text = _buildPlainText();
    _textPainter = TextPainter(
      text: TextSpan(text: text, style: _style),
      textAlign: _textAlign,
      textDirection: _textDirection,
      textWidthBasis: _textWidthBasis,
      textHeightBehavior: _textHeightBehavior,
      strutStyle: _strutStyle,
    );

    return _textPainter!;
  }

  @override
  void performLayout() {
    final painter = _getTextPainter();
    painter.layout(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
    );

    size = constraints.constrain(Size(
      constraints.maxWidth,
      painter.height,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final painter = _getTextPainter();
    final canvas = context.canvas;

    // Draw selection
    if (_selection.isValid && !_selection.isCollapsed) {
      final boxes = painter.getBoxesForSelection(_selection);
      final paint = Paint()..color = _selectionColor;
      for (final box in boxes) {
        canvas.drawRect(box.toRect().shift(offset), paint);
      }
    }

    // Draw text
    painter.paint(canvas, offset);

    // Draw cursor
    if (_showCursor && _selection.isValid && _selection.isCollapsed) {
      final cursorOffset = painter.getOffsetForCaret(
        TextPosition(offset: _selection.baseOffset),
        Rect.zero,
      );
      final cursorHeight = _cursorHeight ?? painter.preferredLineHeight;
      final cursorRect = Rect.fromLTWH(
        offset.dx + cursorOffset.dx,
        offset.dy + cursorOffset.dy,
        _cursorWidth,
        cursorHeight,
      );

      final paint = Paint()..color = _cursorColor;
      if (_cursorRadius != null) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(cursorRect, _cursorRadius!),
          paint,
        );
      } else {
        canvas.drawRect(cursorRect, paint);
      }
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry), "");
    if (event is PointerDownEvent) {
      _handleTapDown(event);
    } else if (event is PointerUpEvent) {
      _handleTapUp(event);
    } else if (event is PointerMoveEvent) {
      _handleDragUpdate(event);
    }
  }

  void _handleTapDown(PointerDownEvent event) {
    _lastTapDownPosition = globalToLocal(event.position);
  }

  void _handleTapUp(PointerUpEvent event) {
    if (_lastTapDownPosition == null) {
      return;
    }

    final position = globalToLocal(event.position);
    final painter = _getTextPainter();
    final textPosition = painter.getPositionForOffset(position);

    _onTap?.call();
    _onSelectionChanged(
      TextSelection.collapsed(offset: textPosition.offset),
      SelectionChangedCause.tap,
    );
    _lastTapDownPosition = null;
  }

  void _handleDragUpdate(PointerMoveEvent event) {
    if (_lastTapDownPosition == null) {
      return;
    }

    final position = globalToLocal(event.position);
    final painter = _getTextPainter();
    final textPosition = painter.getPositionForOffset(position);

    if (_selection.isCollapsed) {
      // Start selection from tap down position
      final downPosition = painter.getPositionForOffset(_lastTapDownPosition!);
      _onSelectionChanged(
        TextSelection(
          baseOffset: downPosition.offset,
          extentOffset: textPosition.offset,
        ),
        SelectionChangedCause.drag,
      );
    } else {
      // Extend selection
      _onSelectionChanged(
        TextSelection(
          baseOffset: _selection.baseOffset,
          extentOffset: textPosition.offset,
        ),
        SelectionChangedCause.drag,
      );
    }
  }
}
