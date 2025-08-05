part of "/masamune_painter.dart";

/// A widget for a drawing field in forms.
///
/// You can draw freely and save the layer data.
///
/// You must pass a [PainterController] to [controller].
///
/// Only the raw layer data is saved in this field. To output as image data, use [PainterController.renderImage].
///
/// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
///
/// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
///
/// Enter the initial value given by [FormController.value] in [initialValue].
///
/// Each time the content is changed, [onChanged] is executed.
///
/// If [enabled] is `false`, the drawing area is deactivated.
///
/// If [readOnly] is set to `true`, the activation is displayed, but the drawing area cannot be changed.
///
/// フォーム用の描画フィールド用のウィジェット。
///
/// 自由に描画を行いそのレイヤーデータを保存することができます。
///
/// [controller]に必ず[PainterController]を渡してください。
///
/// このフィールドで保存されるのはあくまでレイヤーのRawデータです。画像データとして出力する場合は[PainterController.renderImage]を使用してください。
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
/// [enabled]が`false`になると描画エリアが非有効化されます。
///
/// [readOnly]が`true`になっている場合は、有効化の表示になりますが、描画エリアが変更できなくなります。
class FormPainterField<TValue> extends FormField<List<PaintingValue>> {
  /// A widget for a drawing field in forms.
  ///
  /// You can draw freely and save the layer data.
  ///
  /// You must pass a [PainterController] to [controller].
  ///
  /// Only the raw layer data is saved in this field. To output as image data, use [PainterController.renderImage].
  ///
  /// Place under the [Form] that gave [FormController.key], or pass [FormController] to [form].
  ///
  /// When [FormController] is passed to [form], [onSaved] must also be passed together. The contents of [onSaved] will be used to save the data.
  ///
  /// Enter the initial value given by [FormController.value] in [initialValue].
  ///
  /// Each time the content is changed, [onChanged] is executed.
  ///
  /// If [enabled] is `false`, the drawing area is deactivated.
  ///
  /// If [readOnly] is set to `true`, the activation is displayed, but the drawing area cannot be changed.
  ///
  /// フォーム用の描画フィールド用のウィジェット。
  ///
  /// 自由に描画を行いそのレイヤーデータを保存することができます。
  ///
  /// [controller]に必ず[PainterController]を渡してください。
  ///
  /// このフィールドで保存されるのはあくまでレイヤーのRawデータです。画像データとして出力する場合は[PainterController.renderImage]を使用してください。
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
  /// [enabled]が`false`になると描画エリアが非有効化されます。
  ///
  /// [readOnly]が`true`になっている場合は、有効化の表示になりますが、描画エリアが変更できなくなります。
  FormPainterField({
    required this.controller,
    super.key,
    this.keepAlive = true,
    bool expands = false,
    bool scrollable = true,
    this.form,
    this.style,
    super.enabled = true,
    List<PaintingValue>? initialValue,
    this.readOnly = false,
    this.onChanged,
    TValue Function(List<PaintingValue> value)? onSaved,
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
          builder: (FormFieldState<List<PaintingValue>> field) {
            final state = field as FormPainterFieldState<TValue>;
            final context = state.context;
            final theme = Theme.of(context);
            final adapter =
                MasamuneAdapterScope.of<PainterMasamuneAdapter>(context) ??
                    PainterMasamuneAdapter.primary;
            final canvasSize = controller.canvasSize;

            Widget child = CustomPaint(
              painter: _RawPainter(values: state.value ?? []),
              size: canvasSize,
            );

            if (scrollable) {
              child = InteractiveViewer(child: child);
            }

            return FormContainer(
              form: form,
              style: style,
              enabled: enabled,
              alignment: style?.alignment ?? Alignment.topLeft,
              contentPadding: style?.contentPadding ?? EdgeInsets.zero,
              child: child,
            );
          },
        );

  /// Form Style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// If `true`, the form is not destroyed when scrolling.
  ///
  /// `true`の場合、スクロール時にフォームが破棄されません。
  final bool keepAlive;

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

  /// Controller for painter forms.
  ///
  /// 描画フォーム用のコントローラー。
  final PainterController controller;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(List<PaintingValue>? value)? onChanged;

  @override
  FormFieldState<List<PaintingValue>> createState() =>
      FormPainterFieldState<TValue>();
}

/// State for FormPainterField.
///
/// フォーム用のMarkdownテキストフィールド用のステート。
class FormPainterFieldState<TValue> extends FormFieldState<List<PaintingValue>>
    with AutomaticKeepAliveClientMixin<FormField<List<PaintingValue>>> {
  @override
  List<PaintingValue>? get value => widget.controller.value;

  @override
  FormPainterField<TValue> get widget =>
      super.widget as FormPainterField<TValue>;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    widget.controller._registerState(this);
  }

  @override
  void didUpdateWidget(FormPainterField<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller._unregisterState(this);
      widget.controller._registerState(this);
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
    widget.form?.unregister(this);
    widget.controller._unregisterState(this);
    super.dispose();
  }

  @override
  void reset() {
    widget.controller.clear();
    widget.controller._values.addAll(widget.initialValue ?? []);
    super.reset();
  }

  void _handleOnChange() {
    setState(() {});
  }

  void _handleOnChanged() {
    setState(() {
      widget.onChanged?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(this);
  }
}

class _RawPainter extends CustomPainter {
  _RawPainter({
    required this.values,
  });

  final List<PaintingValue> values;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(_RawPainter oldDelegate) {
    return oldDelegate.values.length != values.length ||
        !oldDelegate.values.equalsTo(values);
  }
}
