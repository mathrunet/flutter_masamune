part of katana_form;

/// A form that waits for another process to complete and updates the value of the form based on that value.
///
/// Use this when moving to another page and updating form values based on values entered on that page, or updating form values based on API responses.
///
/// Specifying [builder] describes the data acquisition process after a tap.
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must be passed together with [form]. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// When [FormController.validateAndSave] is executed, validation and data saving are performed.
///
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// If [enabled] is `false`, the text is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
///
/// 別の処理の完了を待ってその値を元にフォームの値を更新するフォーム。
///
/// 別のページに遷移してそのページで入力した値を元にフォームの値を更新する場合やAPIのレスポンスを元にフォームの値を更新する場合に使用します。
///
/// [builder]を指定することでタップした後のデータ取得処理を記述します。
///
/// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
///
/// [form]に[FormController]を渡した場合、[form]を渡した場合一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
///
/// [initialValue]に[FormController.value]から与えられた初期値を入力します。
///
/// 内容が変更される度[onChanged]が実行されます。
///
/// [FormController.validateAndSave]が実行された場合、バリデーションとデータの保存を行ないます。
///
/// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
///
/// それ以外のエラーチェックは[validator]を指定することで行ないます。
/// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
///
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
class FormFutureField<T extends Object, TValue> extends FormField<T> {
  /// A form that waits for another process to complete and updates the value of the form based on that value.
  ///
  /// Use this when moving to another page and updating form values based on values entered on that page, or updating form values based on API responses.
  ///
  /// Specifying [builder] describes the data acquisition process after a tap.
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must be passed together with [form]. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// When [FormController.validateAndSave] is executed, validation and data saving are performed.
  ///
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the text cannot be changed.
  ///
  /// 別の処理の完了を待ってその値を元にフォームの値を更新するフォーム。
  ///
  /// 別のページに遷移してそのページで入力した値を元にフォームの値を更新する場合やAPIのレスポンスを元にフォームの値を更新する場合に使用します。
  ///
  /// [builder]を指定することでタップした後のデータ取得処理を記述します。
  ///
  /// [FormController.key]を与えた[Form]配下に配置、もしくは[form]に[FormController]を渡します。
  ///
  /// [form]に[FormController]を渡した場合、[form]を渡した場合一緒に[onSaved]も渡してください。データの保存は[onSaved]の内容が実行されます。
  ///
  /// [initialValue]に[FormController.value]から与えられた初期値を入力します。
  ///
  /// 内容が変更される度[onChanged]が実行されます。
  ///
  /// [FormController.validateAndSave]が実行された場合、バリデーションとデータの保存を行ないます。
  ///
  /// [emptyErrorText]が指定されている時に限り、文字が入力されていない場合[emptyErrorText]がエラーとして表示されます。
  ///
  /// それ以外のエラーチェックは[validator]を指定することで行ないます。
  /// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
  ///
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、テキストが変更できなくなります。
  FormFutureField({
    this.form,
    this.style,
    required FutureOr<T?> Function() builder,
    this.parseToString,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.hintText,
    this.readOnly = false,
    this.labelText,
    this.onChanged,
    this.emptyErrorText,
    this.keepAlive = true,
    Key? key,
    TValue Function(T value)? onSaved,
    String? Function(T? value)? validator,
    T? initialValue,
    bool enabled = true,
  })  : _builder = builder,
        super(
          key: key,
          builder: (state) {
            return const SizedBox.shrink();
          },
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
          validator: (value) {
            if (emptyErrorText.isNotEmpty && value == null) {
              return emptyErrorText;
            }
            return validator?.call(value);
          },
          initialValue: initialValue,
          enabled: enabled,
        );

  /// Context for forms.
  ///
  /// The widget is created outside of the widget in advance and handed over to the client.
  ///
  /// フォーム用のコンテキスト。
  ///
  /// 予めウィジェット外で作成し渡します。
  final FormController<TValue>? form;

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  ///
  final FutureOr<T?> Function() _builder;

  /// Hint to be displayed on the form. Displayed when no text is entered.
  ///
  /// フォームに表示するヒント。文字が入力されていない場合表示されます。
  final String? hintText;

  /// Label text for forms.
  ///
  /// フォーム用のラベルテキスト。
  final String? labelText;

  /// Describe the data acquisition process after a tap.
  ///
  /// タップした後のデータ取得処理を記述します。
  final String Function(T? value)? parseToString;

  /// If this is `true`, the input will be hidden. Use this to enter passwords, etc.
  ///
  /// これが`true`の場合、入力された内容が隠されます。パスワードの入力等にご利用ください。
  final bool obscureText;

  /// Error text. Only displayed if the object entered is missing.
  ///
  /// エラーテキスト。入力されたオブジェクトがない場合のみ表示されます。
  final String? emptyErrorText;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(T? value)? onChanged;

  /// A widget that is placed in front of the form.
  ///
  /// Priority is given to this one, and if there is a [Null] element, [FormStyle.prefix] will be applied.
  ///
  /// フォームの前に配置されるウィジェット。
  ///
  /// 優先的にこちらが表示され、[Null]の要素がある場合は[FormStyle.prefix]が適用されます。
  final FormAffixStyle? prefix;

  /// A widget that is placed after the form.
  ///
  /// Priority is given to this one, and if there is a [Null] element, [FormStyle.suffix] will be applied.
  ///
  /// フォームの後に配置されるウィジェット。
  ///
  /// 優先的にこちらが表示され、[Null]の要素がある場合は[FormStyle.suffix]が適用されます。
  final FormAffixStyle? suffix;

  @override
  FormFieldState<T> createState() => _FormFutureFieldState<T, TValue>();
}

class _FormFutureFieldState<T extends Object, TValue> extends FormFieldState<T>
    with AutomaticKeepAliveClientMixin<FormField<T>> {
  late final TextEditingController _controller;
  @override
  FormFutureField<T, TValue> get widget =>
      super.widget as FormFutureField<T, TValue>;

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
    _controller = TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.parseToString?.call(widget.initialValue) ??
          widget.initialValue!.toString();
    }
  }

  @override
  void didUpdateWidget(FormFutureField<T, TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      widget.form?.register(this);
    }
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.parseToString?.call(widget.initialValue) ??
          widget.initialValue!.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void didChange(T? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mainTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.color ??
              Theme.of(context).textTheme.titleMedium?.color ??
              Theme.of(context).colorScheme.onBackground,
        );
    final subTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.subColor,
        ) ??
        TextStyle(
          color: widget.style?.subColor ??
              widget.style?.color?.withOpacity(0.5) ??
              Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.color
                  ?.withOpacity(0.5) ??
              Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        );
    final errorTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.errorColor,
        ) ??
        TextStyle(
          color:
              widget.style?.errorColor ?? Theme.of(context).colorScheme.error,
        );
    const borderSide = OutlineInputBorder(
      borderSide: BorderSide.none,
    );

    return Container(
      width: widget.style?.width,
      height: widget.style?.height,
      padding:
          widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          TextFormField(
            mouseCursor: SystemMouseCursors.click,
            enabled: widget.enabled,
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: widget.style?.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              fillColor: widget.style?.backgroundColor,
              filled: widget.style?.backgroundColor != null,
              isDense: true,
              border: widget.style?.border ?? borderSide,
              enabledBorder: widget.style?.border ?? borderSide,
              disabledBorder: widget.style?.disabledBorder ??
                  widget.style?.border ??
                  borderSide,
              errorBorder: widget.style?.errorBorder ??
                  widget.style?.border ??
                  borderSide,
              focusedBorder: widget.style?.border ?? borderSide,
              focusedErrorBorder: widget.style?.errorBorder ??
                  widget.style?.border ??
                  borderSide,
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefix: widget.prefix?.child ?? widget.style?.prefix?.child,
              suffix: widget.suffix?.child ?? widget.style?.suffix?.child,
              prefixIcon: widget.prefix?.icon ?? widget.style?.prefix?.icon,
              suffixIcon: widget.suffix?.icon ?? widget.style?.suffix?.icon,
              prefixText: widget.prefix?.label ?? widget.style?.prefix?.label,
              suffixText: widget.suffix?.label ?? widget.style?.suffix?.label,
              prefixIconColor:
                  widget.prefix?.iconColor ?? widget.style?.prefix?.iconColor,
              suffixIconColor:
                  widget.suffix?.iconColor ?? widget.style?.suffix?.iconColor,
              prefixIconConstraints: widget.prefix?.iconConstraints ??
                  widget.style?.prefix?.iconConstraints,
              suffixIconConstraints: widget.suffix?.iconConstraints ??
                  widget.style?.suffix?.iconConstraints,
              labelStyle: mainTextStyle,
              hintStyle: subTextStyle,
              suffixStyle: subTextStyle,
              prefixStyle: subTextStyle,
              counterStyle: subTextStyle,
              helperStyle: subTextStyle,
              errorStyle: errorTextStyle,
            ),
            style: mainTextStyle,
            textAlign: widget.style?.textAlign ?? TextAlign.left,
            textAlignVertical: widget.style?.textAlignVertical,
            readOnly: true,
            obscureText: widget.obscureText,
            onTap: widget.enabled && !widget.readOnly
                ? () async {
                    final res = await widget._builder();
                    if (res == null) {
                      return;
                    }
                    setState(() {
                      _controller.text =
                          widget.parseToString?.call(res) ?? res.toString();
                      setValue(res);
                    });
                  }
                : null,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IgnorePointer(
                  ignoring: true,
                  child:
                      Icon(Icons.arrow_drop_down, color: mainTextStyle.color),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _controller.text = widget.parseToString?.call(widget.initialValue) ??
          widget.initialValue!.toString();
    });
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}