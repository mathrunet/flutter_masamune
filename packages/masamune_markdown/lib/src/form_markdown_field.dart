part of '/masamune_markdown.dart';

/// Widget for Markdown text field for forms.
///
/// You can use `h1`, `h2`, `h3`, and block styles for quotes and code.
/// You can insert media such as images and videos.
/// You can use the font styles `bold`, `italic`, `underline`, `strike`, `link`, and `code`.
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// When [FormController.validate] is executed, validation and data saving are performed.
///
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
///
/// If [enabled] is `false`, the text is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
///
/// フォーム用のMarkdownテキストフィールド用のウィジェット。
///
/// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
/// 画像や映像のメディアを挿入することができます。
/// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
///
/// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
///
/// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
///
/// [initialValue]に[FormController.value]から与えられた初期値を入力します。
///
/// 内容が変更される度[onChanged]が実行されます。
///
/// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
///
/// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
///
/// それ以外のエラーチェックは[validator]を指定することで行ないます。
/// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
///
/// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
///
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
class FormMarkdownField<TValue> extends FormField<String> {
  /// Widget for Markdown text field for forms.
  ///
  /// You can use `h1`, `h2`, `h3`, and block styles for quotes and code.
  /// You can insert media such as images and videos.
  /// You can use the font styles `bold`, `italic`, `underline`, `strike`, `link`, and `code`.
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// When [FormController.validate] is executed, validation and data saving are performed.
  ///
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// The [onSubmitted] process is executed when the Enter key or other keys are pressed.
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
  ///
  /// フォーム用のMarkdownテキストフィールド用のウィジェット。
  ///
  /// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
  /// 画像や映像のメディアを挿入することができます。
  /// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
  ///
  /// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
  ///
  /// [form]に[FormController]を渡した場合、一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
  ///
  /// [initialValue]に[FormController.value]から与えられた初期値を入力します。
  ///
  /// 内容が変更される度[onChanged]が実行されます。
  ///
  /// [FormController.validate]が実行された場合、バリデーションとデータの保存を行ないます。
  ///
  /// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
  ///
  /// それ以外のエラーチェックは[validator]を指定することで行ないます。
  /// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
  ///
  /// Enterキーなどが押された場合の処理を[onSubmitted]が実行されます。
  ///
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
  FormMarkdownField({
    super.key,
    this.keepAlive = true,
    bool expands = false,
    bool scrollable = true,
    this.form,
    this.controller,
    this.style,
    super.enabled = true,
    String? initialValue,
    this.focusNode,
    TextInputAction textInputAction = TextInputAction.newline,
    bool enableInteractiveSelection = true,
    this.readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    String? emptyErrorText,
    String? Function(String? value)? validator,
    TValue Function(String value)? onSaved,
    String? hintText,
    void Function(String link)? onTapLink,
    this.autofocus = false,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          initialValue: initialValue ?? "",
          onSaved: (value) {
            if (value == null) {
              return;
            }
            final res = onSaved?.call(value);
            if (res == null) {
              return;
            }
            form!.value = res;
          },
          autovalidateMode: AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final FormMarkdownFieldState<TValue> state =
                field as FormMarkdownFieldState<TValue>;
            final context = state.context;
            final theme = Theme.of(context);
            final defaultStyles = DefaultStyles.getInstance(context);

            final mainTextStyle = style?.textStyle?.copyWith(
                  color: style.color,
                ) ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: style?.color ?? theme.textTheme.bodyMedium?.color,
                ) ??
                TextStyle(
                  color: style?.color ??
                      theme.textTheme.bodyMedium?.color ??
                      theme.textTheme.bodyMedium?.color,
                );
            final subTextStyle = style?.textStyle?.copyWith(
                  color: style.subColor,
                ) ??
                TextStyle(
                  color: style?.subColor ??
                      style?.color?.withValues(alpha: 0.5) ??
                      theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                );
            final linkTextStyle = TextStyle(
              color: style?.activeColor ?? theme.colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: style?.activeColor ?? theme.colorScheme.primary,
            );
            final borderColor = style?.borderColor ?? theme.dividerColor;

            return FormStyleContainer(
              form: form,
              style: style,
              enabled: enabled,
              errorText: emptyErrorText,
              alignment: style?.alignment ?? Alignment.topLeft,
              contentPadding: style?.contentPadding ?? EdgeInsets.zero,
              validator: form != null
                  ? () {
                      final value = state.value;
                      if (emptyErrorText.isNotEmpty && value.isEmpty) {
                        return emptyErrorText;
                      }
                      return validator?.call(value);
                    }
                  : null,
              child: QuillEditor.basic(
                controller: state._controller,
                focusNode: state._effectiveFocusNode,
                config: QuillEditorConfig(
                  scrollable: scrollable,
                  autoFocus: autofocus,
                  linkActionPickerDelegate: defaultLinkActionPickerDelegate,
                  padding: style?.contentPadding ?? EdgeInsets.zero,
                  expands: expands,
                  placeholder: hintText,
                  onLaunchUrl: onTapLink,
                  textCapitalization: textCapitalization,
                  textInputAction: textInputAction,
                  enableInteractiveSelection: enableInteractiveSelection,
                  customStyles: defaultStyles.merge(
                    DefaultStyles(
                      color: mainTextStyle.color,
                      link: linkTextStyle,
                      inlineCode: InlineCodeStyle(
                        style: mainTextStyle.copyWith(
                          fontSize: mainTextStyle.fontSize! * 0.8,
                        ),
                        header1: defaultStyles.inlineCode?.header1,
                        header2: defaultStyles.inlineCode?.header2,
                        header3: defaultStyles.inlineCode?.header3,
                        header4: defaultStyles.inlineCode?.header4,
                        header5: defaultStyles.inlineCode?.header5,
                        header6: defaultStyles.inlineCode?.header6,
                        backgroundColor: style?.subBackgroundColor ??
                            theme.colorScheme.surface,
                        radius: Radius.circular(4),
                      ),
                      code: defaultStyles.code?.copyWith(
                        style: mainTextStyle,
                        verticalSpacing: VerticalSpacing(12, 6),
                        decoration: BoxDecoration(
                          color: style?.subBackgroundColor ??
                              theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      placeHolder: defaultStyles.placeHolder?.copyWith(
                        style: subTextStyle,
                      ),
                      lists: defaultStyles.lists?.copyWith(
                        style: mainTextStyle,
                        indentWidthBuilder:
                            (block, context, count, numberPointWidthDelegate) {
                          final res = TextBlockUtils.defaultIndentWidthBuilder(
                              block, context, count, numberPointWidthDelegate);

                          final attrs = block.style.attributes;
                          if (attrs[Attribute.list.key] == Attribute.ul) {
                            return HorizontalSpacing(
                                (res.left - (mainTextStyle.fontSize ?? 14.0))
                                    .limitLow(0),
                                0);
                          }
                          return HorizontalSpacing(
                              (res.left -
                                      (mainTextStyle.fontSize ?? 14.0) / 2.0)
                                  .limitLow(0),
                              0);
                        },
                      ),
                      quote: defaultStyles.quote?.copyWith(
                        style: mainTextStyle,
                        verticalSpacing: VerticalSpacing(12, 6),
                        lineSpacing: VerticalSpacing(0, 0),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: borderColor,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController<TValue>? form;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// Controller for text forms.
  ///
  /// テキストフォーム用のコントローラー。
  final MarkdownController? controller;

  /// If `true`, focus is automatically applied.
  ///
  /// `true`の場合、自動でフォーカスが当たります。
  final bool autofocus;

  /// Specifies the focus node.
  ///
  /// The focus node makes it possible to control the focus of the form.
  ///
  /// フォーカスノードを指定します。
  ///
  /// フォーカスノードを利用してフォームのフォーカスをコントロールすることが可能になります。
  final FocusNode? focusNode;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(String? value)? onChanged;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(String? value)? onSubmitted;

  /// Default link action picker delegate.
  ///
  /// デフォルトのリンクアクションピッカーデリゲート。
  static Future<LinkMenuAction> defaultLinkActionPickerDelegate(
      BuildContext context, String link, Node node) async {
    return LinkMenuAction.none;
  }

  @override
  FormFieldState<String> createState() => FormMarkdownFieldState<TValue>();
}

/// State for FormMarkdownField.
///
/// フォーム用のMarkdownテキストフィールド用のステート。
class FormMarkdownFieldState<TValue> extends FormFieldState<String>
    with AutomaticKeepAliveClientMixin<FormField<String>> {
  String? _text;
  Delta? _delta;

  final QuillController _controller = QuillController(
    config: QuillControllerConfig(),
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
    keepStyleOnNewLine: false,
  );
  final MarkdownToDelta _mdToDelta = MarkdownToDelta(
    markdownDocument: md.Document(encodeHtml: false),
  );
  final DeltaToMarkdown _deltaToMd = DeltaToMarkdown();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode!;
  FocusNode? _focusNode;

  @override
  FormMarkdownField<TValue> get widget =>
      super.widget as FormMarkdownField<TValue>;

  /// Check if the cursor is in a link.
  ///
  /// カーソルがリンク内にあるかどうかをチェックします。
  bool get cursorInLink => _cursorInLink;
  bool _cursorInLink = false;
  bool _selectInLink = false;
  TextSelection? _previousSelection;

  /// Check if the cursor is in a mention link.
  ///
  /// カーソルがメンションリンク内にあるかどうかをチェックします。
  bool get selectInMentionLink => _selectInMentionLink;
  bool _selectInMentionLink = false;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleOnChanged);
    _syncQuillController(widget.initialValue);
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    widget.controller?._registerState(this);
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormMarkdownField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._unregisterState(this);
      widget.controller?._registerState(this);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
      }
    }
    if (widget.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      widget.form?.register(this);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      reset();
    }
  }

  @override
  void dispose() {
    widget.controller?._unregisterState(this);
    _controller.removeListener(_handleOnChanged);
    _controller.dispose();
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    _syncQuillController(value);
  }

  @override
  void reset() {
    _syncQuillController(null);
    super.reset();
  }

  void _syncQuillController(String? value) {
    if (_text != value) {
      _text = value;
      if (value == null) {
        _controller.document = Document();
        _delta = _controller.document.toDelta();
      } else {
        _delta = _mdToDelta.convert(value);
        _controller.document = Document.fromDelta(_delta!);
      }
    }
  }

  void _handleOnChanged() {
    _cursorInLink = _controller
        .getSelectionStyle()
        .values
        .any((e) => e.key == Attribute.link.key);
    final delta = _controller.document.toDelta();
    if (delta != _delta) {
      _delta = delta;
      _text = _deltaToMd.convert(delta);
    }
    if (_cursorInLink) {
      final selection = _controller.selection;
      if (_selectInLink && _previousSelection == selection) {
        return;
      }
      _previousSelection = selection;
      final document = _controller.document;
      final text = document.toPlainText();
      var index = selection.baseOffset;
      final lineStart = text.lastIndexOf("\n", index - 1) + 1;
      var res = document.queryChild(index);
      final node = res.node;
      if (node is Line) {
        for (final child in node.children) {
          final linkAttribute = child.style.attributes[Attribute.link.key];
          if (linkAttribute != null) {
            final link = linkAttribute.value as String;
            if (link.startsWith("@")) {
              _selectInMentionLink = true;
            }
            _selectInLink = true;
            final baseOffset = lineStart + child.offset;
            final extentOffset = baseOffset + child.length;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _controller.updateSelection(
                TextSelection(
                  baseOffset: baseOffset,
                  extentOffset: extentOffset,
                ),
                ChangeSource.local,
              );
            });
            return;
          }
        }
      }
    } else {
      _selectInLink = false;
      _selectInMentionLink = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}
