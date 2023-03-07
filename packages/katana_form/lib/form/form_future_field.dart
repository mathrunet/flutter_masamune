part of katana_form;

/// 別の処理の完了を待ってその値を元にフォームの値を更新するウィジェット名はどうしたらいい？
class FormFutureField<T extends Object, TValue> extends FormField<T> {
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

  final FutureOr<T?> Function() _builder;
  final String? hintText;
  final String? labelText;
  final String Function(T? value)? parseToString;
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

    return Padding(
      padding:
          widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
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
          errorBorder:
              widget.style?.errorBorder ?? widget.style?.border ?? borderSide,
          focusedBorder: widget.style?.border ?? borderSide,
          focusedErrorBorder:
              widget.style?.errorBorder ?? widget.style?.border ?? borderSide,
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
