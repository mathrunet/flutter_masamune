part of "/masamune_markdown.dart";

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
class FormMarkdownField<TValue> extends FormField<List<MarkdownFieldValue>> {
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
    this.form,
    this.controller,
    this.style,
    super.enabled = true,
    List<MarkdownFieldValue>? initialValue,
    this.focusNode,
    TextInputAction textInputAction = TextInputAction.newline,
    bool enableInteractiveSelection = true,
    this.readOnly = false,
    TextInputType keyboardType = TextInputType.multiline,
    TextCapitalization textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    String? emptyErrorText,
    TextAlign textAlign = TextAlign.start,
    String? Function(List<MarkdownFieldValue>? value)? validator,
    TValue Function(List<MarkdownFieldValue> value)? onSaved,
    String? hintText,
    bool scrollable = true,
    void Function(Uri link)? onTapLink,
    void Function(MarkdownMention mention)? onTapMention,
    this.autofocus = false,
    VoidCallback? onTap,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    void Function()? onEditingComplete,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          initialValue: initialValue ?? [],
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
          builder: (FormFieldState<List<MarkdownFieldValue>> field) {
            final state = field as FormMarkdownFieldState<TValue>;

            return FormContainer(
              form: form,
              style: style,
              enabled: enabled,
              hintText: hintText,
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
              child: MarkdownField(
                enabled: enabled,
                enableInteractiveSelection: enableInteractiveSelection,
                readOnly: readOnly,
                autofocus: autofocus,
                controller: state._effectiveController,
                focusNode: focusNode,
                onTap: onTap,
                onTapLink: onTapLink,
                onTapMention: onTapMention,
                scrollable: scrollable,
                onEditingComplete: onEditingComplete,
                onChanged: (value) {
                  field.didChange(value);
                  onChanged?.call(value);
                },
                onSubmitted: onSubmitted?.call,
                scrollController: scrollController,
                scrollPhysics: scrollPhysics,
                textInputAction: textInputAction,
                expands: expands,
                textCapitalization: textCapitalization,
                textAlign: textAlign,
                keyboardType: keyboardType,
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
  final void Function(List<MarkdownFieldValue>? value)? onChanged;

  /// It is executed when the Enter button on the keyboard or the Submit button on the software keyboard is pressed.
  ///
  /// The current value is passed to `value`.
  ///
  /// キーボードのEnterボタン、もしくはソフトウェアキーボードのサブミットボタンが押された場合に実行されます。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(List<MarkdownFieldValue>? value)? onSubmitted;

  @override
  FormFieldState<List<MarkdownFieldValue>> createState() =>
      FormMarkdownFieldState<TValue>();
}

/// State for FormMarkdownField.
///
/// フォーム用のMarkdownテキストフィールド用のステート。
class FormMarkdownFieldState<TValue>
    extends FormFieldState<List<MarkdownFieldValue>>
    with AutomaticKeepAliveClientMixin<FormField<List<MarkdownFieldValue>>> {
  @override
  FormMarkdownField<TValue> get widget =>
      super.widget as FormMarkdownField<TValue>;

  MarkdownController get _effectiveController {
    if (widget.controller != null) {
      return widget.controller!;
    }
    return _controller ??= MarkdownController();
  }

  MarkdownController? _controller;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormMarkdownField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}
