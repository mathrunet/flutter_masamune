part of '/katana_form.dart';

/// Widget to display & edit by number of stars by passing [double].
///
/// Can be used to evaluate users and articles.
///
/// [iconCount] allows you to specify the number of icons. The icon widget itself can be specified with [icon], and the design can be changed by specifying [iconSize], [activeColor], and [inactiveColor]. Also, if [iconBuilder] is specified, the icon can be created in a callback.
///
/// The minimum and maximum values can be specified with [min] and [max].
///
/// You can specify whether to allow half stars with [allowHalfRating].
///
/// Normally, the value can be changed by dragging, but [tapOnlyMode] allows the value to be specified only by tapping.
///
/// If [showLabel] is specified, the actual value can be displayed as a numerical value.
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// If [FormController.validate] is executed, validation and data saving are performed.
///
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// If [enabled] is `false`, the text is deactivated.
///
/// If [readOnly] is set to `true`, it will show enabled, but the value cannot be changed.
///
/// [double]を渡して星の数で表示＆編集するためのウィジェット。
///
/// ユーザーや記事の評価に使用可能です。
///
/// [iconCount]を使用するとアイコンの数を指定できます。[icon]でアイコンウィジェットそのものを指定でき、[iconSize]や[activeColor]、[inactiveColor]を指定するとデザインを変更することができます。また、[iconBuilder]を指定するとコールバックでアイコンを作成可能です。
///
/// [min]と[max]で値の最小値、最大値を指定できます。
///
/// [allowHalfRating]で半分の星を許可するかどうかを指定できます。
///
/// 通常はドラッグで値を変更できますが、[tapOnlyMode]でタップのみで値を指定可能にします。
///
/// [showLabel]を指定すると実際の値を数値として表示することが可能です。
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
/// [enabled]が`false`になるとテキストが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、値が変更できなくなります。
@immutable
class FormRatingBar<TValue> extends FormField<double> {
  /// Widget to display & edit by number of stars by passing [double].
  ///
  /// Can be used to evaluate users and articles.
  ///
  /// [iconCount] allows you to specify the number of icons. The icon widget itself can be specified with [icon], and the design can be changed by specifying [iconSize], [activeColor], and [inactiveColor]. Also, if [iconBuilder] is specified, the icon can be created in a callback.
  ///
  /// The minimum and maximum values can be specified with [min] and [max].
  ///
  /// You can specify whether to allow half stars with [allowHalfRating].
  ///
  /// Normally, the value can be changed by dragging, but [tapOnlyMode] allows the value to be specified only by tapping.
  ///
  /// If [showLabel] is specified, the actual value can be displayed as a numerical value.
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// If [FormController.validate] is executed, validation and data saving are performed.
  ///
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if no characters are entered.
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// If [enabled] is `false`, the text is deactivated.
  ///
  /// If [readOnly] is set to `true`, it will show enabled, but the value cannot be changed.
  ///
  /// [double]を渡して星の数で表示＆編集するためのウィジェット。
  ///
  /// ユーザーや記事の評価に使用可能です。
  ///
  /// [iconCount]を使用するとアイコンの数を指定できます。[icon]でアイコンウィジェットそのものを指定でき、[iconSize]や[activeColor]、[inactiveColor]を指定するとデザインを変更することができます。また、[iconBuilder]を指定するとコールバックでアイコンを作成可能です。
  ///
  /// [min]と[max]で値の最小値、最大値を指定できます。
  ///
  /// [allowHalfRating]で半分の星を許可するかどうかを指定できます。
  ///
  /// 通常はドラッグで値を変更できますが、[tapOnlyMode]でタップのみで値を指定可能にします。
  ///
  /// [showLabel]を指定すると実際の値を数値として表示することが可能です。
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
  /// [enabled]が`false`になるとテキストが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、値が変更できなくなります。
  FormRatingBar({
    this.form,
    this.style,
    this.keepAlive = true,
    this.controller,
    this.iconCount = 5,
    this.iconSize = 40.0,
    this.readOnly = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.min,
    this.max,
    this.iconBuilder,
    this.allowHalfRating = true,
    this.tapOnlyMode = false,
    this.direction = Axis.horizontal,
    this.showLabel = false,
    this.icon,
    this.format = "0.#",
    super.key,
    this.emptyErrorText,
    TValue Function(double value)? onSaved,
    String Function(double? value)? validator,
    num? initialValue,
    super.enabled,
  })  : assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
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
          initialValue: initialValue?.toDouble(),
        );

  /// Widget to display & edit by number of stars by passing [double].
  ///
  /// If a value is given in [initialValue], that value will be displayed.
  ///
  /// The value cannot be changed.
  ///
  /// [iconCount] allows you to specify the number of icons. The icon widget itself can be specified with [icon], and the design can be changed by specifying [iconSize], [activeColor], and [inactiveColor]. Also, if [iconBuilder] is specified, the icon can be created in a callback.
  ///
  /// The minimum and maximum values can be specified with [min] and [max].
  ///
  /// You can specify whether to allow half stars with [allowHalfRating].
  ///
  /// If [showLabel] is specified, the actual value can be displayed as a numerical value.
  ///
  /// [double]を渡して星の数で表示＆編集するためのウィジェット。
  ///
  /// [initialValue]で値を与えるとその値が表示されます。
  ///
  /// 値の変更はできません。
  ///
  /// [iconCount]を使用するとアイコンの数を指定できます。[icon]でアイコンウィジェットそのものを指定でき、[iconSize]や[activeColor]、[inactiveColor]を指定するとデザインを変更することができます。また、[iconBuilder]を指定するとコールバックでアイコンを作成可能です。
  ///
  /// [min]と[max]で値の最小値、最大値を指定できます。
  ///
  /// [allowHalfRating]で半分の星を許可するかどうかを指定できます。
  ///
  /// [showLabel]を指定すると実際の値を数値として表示することが可能です。
  FormRatingBar.view(
    num initialValue, {
    Key? key,
    FormStyle? style,
    int iconCount = 5,
    double iconSize = 40.0,
    Color? activeColor,
    Color? inaciveColor,
    double? min,
    double? max,
    Widget Function(BuildContext context, int index)? itemBuilder,
    bool allowHalfRating = true,
    Axis direction = Axis.horizontal,
    bool showLabel = false,
    Widget? icon,
  }) : this(
          initialValue: initialValue.toDouble(),
          key: key,
          style: style,
          iconCount: iconCount,
          iconSize: iconSize,
          activeColor: activeColor,
          inactiveColor: inaciveColor,
          min: min,
          max: max,
          iconBuilder: itemBuilder,
          allowHalfRating: allowHalfRating,
          direction: direction,
          showLabel: showLabel,
          icon: icon,
          readOnly: true,
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

  /// Normally, the value can be changed by dragging, but [tapOnlyMode] allows the value to be specified only by tapping.
  ///
  /// 通常はドラッグで値を変更できますが、[tapOnlyMode]でタップのみで値を指定可能にします。
  final bool tapOnlyMode;

  /// You can specify whether to allow half stars.
  ///
  /// 半分の星を許可するかどうかを指定できます。
  final bool allowHalfRating;

  /// If specified, actual values can be displayed as numerical values.
  ///
  /// 指定すると実際の値を数値として表示することが可能です。
  final bool showLabel;

  /// Specifies the color of the star when active.
  ///
  /// アクティブなときの星の色を指定します。
  final Color? activeColor;

  /// Specifies the color of the star when inactive.
  ///
  /// 非アクティブなときの星の色を指定します。
  final Color? inactiveColor;

  /// Specifies the minimum value.
  ///
  /// 値の最小値を指定します。
  final double? min;

  /// Specifies the maximum value.
  ///
  /// 値の最大値を指定します。
  final double? max;

  /// Specify the format for text in [showLabel] and [controller].
  ///
  /// [showLabel]や[controller]でテキスト化するときのフォーマットを指定します。
  final String format;

  /// Specify the widget for the icon.
  ///
  /// Use [iconBuilder] if you want to change the icon according to the value.
  ///
  /// アイコンのウィジェットを指定します。
  ///
  /// 数値に応じてアイコンを変えたい場合は[iconBuilder]を使用してください。
  final Widget? icon;

  /// Builder if you want to change the icon according to the value of [index].
  ///
  /// [index]の値に応じてアイコンを変えたい場合のビルダー。
  final Widget Function(BuildContext context, int index)? iconBuilder;

  /// Specify the number of icons to be placed.
  ///
  /// 設置するアイコンの数を指定します。
  final int iconCount;

  /// Specifies the size of the icon.
  ///
  /// アイコンのサイズを指定します。
  final double iconSize;

  /// Specifies the orientation of the bar.
  ///
  /// バーの向きを指定します。
  final Axis direction;

  /// Text field controller.
  ///
  /// テキストフィールドのコントローラー。
  final TextEditingController? controller;

  /// Error text. Only displayed if no characters are entered.
  ///
  /// エラーテキスト。入力された文字がない場合のみ表示されます。
  final String? emptyErrorText;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(double? value)? onChanged;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  @override
  FormFieldState<double> createState() => _FormRatingBarState<TValue>();
}

class _FormRatingBarState<TValue> extends FormFieldState<double>
    with AutomaticKeepAliveClientMixin<FormField<double>> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  @override
  FormRatingBar<TValue> get widget => super.widget as FormRatingBar<TValue>;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller =
          TextEditingController(text: (widget.initialValue ?? 0.0).toString());
      _controller?.addListener(_handleControllerChanged);
    }
    if (value == null) {
      setValue(_parse(_effectiveController?.text ?? "") ?? widget.initialValue);
    }
    widget.form?.register(this);
    widget.controller?.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(FormRatingBar<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
        _controller?.addListener(_handleControllerChanged);
      }
      if (widget.controller != null) {
        setValue(_parse(widget.controller?.text ?? ""));
        if (oldWidget.controller == null) {
          _controller?.dispose();
          _controller = null;
        }
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
    _controller?.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  void didChange(double? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
  }

  double? _parse(String text) {
    if (text.isEmpty) {
      return 0.0;
    }
    return double.tryParse(text);
  }

  @override
  void reset() {
    super.reset();
    _effectiveController?.text = (widget.initialValue ?? 0.0).toString();
    didChange(widget.initialValue);
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != (widget.initialValue ?? 0.0).toString()) {
      didChange(_parse(_effectiveController?.text ?? ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mainTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.color ??
              Theme.of(context).textTheme.titleMedium?.color,
        );
    final disabledTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.disabledColor,
        ) ??
        TextStyle(
          color: widget.style?.disabledColor ?? Theme.of(context).disabledColor,
        );
    final min = widget.min ?? 1.0;

    if (widget.showLabel) {
      return FormStyleScope(
        style: widget.style,
        child: Padding(
          padding: widget.style?.contentPadding ?? const EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _build(context),
              ),
              if (widget.showLabel) ...[
                Text(
                  (value ?? min).format(widget.format),
                  textAlign: TextAlign.end,
                  style: widget.enabled ? mainTextStyle : disabledTextStyle,
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      return FormStyleScope(
        style: widget.style,
        child: Padding(
          padding: widget.style?.contentPadding ?? const EdgeInsets.all(0),
          child: _build(context),
        ),
      );
    }
  }

  Widget _build(BuildContext context) {
    final min = widget.min ?? 1.0;
    if (widget.readOnly) {
      return IconTheme(
        data: IconThemeData(
          color: widget.activeColor ?? Theme.of(context).primaryColor,
          size: widget.iconSize,
        ),
        child: RatingBarIndicator(
          rating: value ?? min,
          itemBuilder: (context, index) {
            if (widget.iconBuilder != null) {
              return widget.iconBuilder!.call(context, index);
            }
            return const Icon(Icons.star);
          },
          unratedColor: widget.inactiveColor ?? Theme.of(context).disabledColor,
          direction: widget.direction,
          itemSize: widget.iconSize,
          itemCount: widget.iconCount,
        ),
      );
    } else {
      return IconTheme(
        data: IconThemeData(
          color: widget.activeColor ?? Theme.of(context).primaryColor,
          size: widget.iconSize,
        ),
        child: MouseRegion(
          cursor: widget.enabled == false
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: RatingBar.builder(
            minRating: min,
            maxRating: widget.max ?? widget.iconCount.toDouble(),
            itemBuilder: (context, index) {
              if (widget.iconBuilder != null) {
                return widget.iconBuilder!.call(context, index);
              }
              return widget.icon ?? const Icon(Icons.star);
            },
            onRatingUpdate: (value) {
              widget.onChanged?.call(value);
              didChange(value);
            },
            tapOnlyMode: widget.tapOnlyMode,
            initialRating: value ?? min,
            allowHalfRating: widget.allowHalfRating,
            unratedColor:
                widget.inactiveColor ?? Theme.of(context).disabledColor,
            direction: widget.direction,
            itemSize: widget.iconSize,
            itemCount: widget.iconCount,
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
