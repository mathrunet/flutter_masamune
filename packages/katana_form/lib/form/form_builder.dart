part of "/katana_form.dart";

/// A builder that can freely change the UI within a form.
///
/// Please return the form to [builder].
///
/// You can change the value of the form by putting a new value in [FormBuilderRef.update] in [builder].
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
/// フォームの中のUIを自由に変更することができるビルダー。
///
/// [builder]にフォームを返すようにしてください。
///
/// [builder]の中にある[FormBuilderRef.update]に新しい値を入れることでフォームの値を変更することが可能です。
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
class FormBuilder<T, TValue> extends FormField<T> {
  /// A builder that can freely change the UI within a form.
  ///
  /// Please return the form to [builder].
  ///
  /// You can change the value of the form by putting a new value in [FormBuilderRef.update] in [builder].
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
  /// フォームの中のUIを自由に変更することができるビルダー。
  ///
  /// [builder]にフォームを返すようにしてください。
  ///
  /// [builder]の中にある[FormBuilderRef.update]に新しい値を入れることでフォームの値を変更することが可能です。
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
  FormBuilder({
    required Widget Function(
      BuildContext context,
      FormBuilderRef<T, TValue> ref,
      T? item,
    ) builder,
    super.key,
    this.form,
    this.style,
    TValue? Function(T? value)? onSaved,
    super.initialValue,
    this.onChanged,
    super.validator,
    this.labelText,
    super.enabled,
    this.keepAlive = true,
  })  : _builder = builder,
        assert(
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
        );

  /// Label text.
  ///
  /// ラベルテキスト。
  final String? labelText;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(T? value)? onChanged;

  /// Builder for each item.
  ///
  /// 各アイテムのビルダー。
  final Widget Function(
    BuildContext context,
    FormBuilderRef<T, TValue> ref,
    T? item,
  ) _builder;

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

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  @override
  FormFieldState<T> createState() => _FormBuilderState<T, TValue>();
}

class _FormBuilderState<T, TValue> extends FormFieldState<T>
    with AutomaticKeepAliveClientMixin<FormField<T>>
    implements FormBuilderRef<T, TValue> {
  @override
  FormBuilder<T, TValue> get widget => super.widget as FormBuilder<T, TValue>;

  @override
  void update(T item) async {
    setState(() {
      setValue(item);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormBuilder<T, TValue> oldWidget) {
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
  void didChange(T? value) {
    widget.onChanged?.call(value);
    super.didChange(value);
  }

  @override
  void dispose() {
    widget.form?.unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FormContainer(
      style: widget.style,
      enabled: widget.enabled,
      labelText: widget.labelText,
      child: widget._builder(context, this, value),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// Controller class for [FormBuilder].
///
/// [FormBuilder]用のコントローラークラス。
abstract class FormBuilderRef<T, TValue> {
  /// Updates the value of the form with the element [item].
  ///
  /// 要素[item]でフォームの値を更新します。
  void update(T item);
}
