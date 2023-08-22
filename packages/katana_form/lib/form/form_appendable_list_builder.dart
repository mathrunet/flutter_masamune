part of katana_form;

/// A builder that can add and delete forms.
///
/// Make [builder] return each form.
///
/// You can specify [top] or [bottom] to place additional buttons on the form.
///
/// If [form] is specified, the timing when [onSaved] is executed is before the timing when [onSaved] of the form inside [builder] is executed, so it is possible to initialize the array.
///
/// Set the initial data by specifying [initialValue].
///
/// フォームの追加削除を行うことができるビルダー。
///
/// [builder]に各フォームを返すようにしてください。
///
/// [top]や[bottom]を指定することでフォームの追加ボタンの設置を行うことが可能です。
///
/// [form]を指定した場合、[onSaved]が実行されるタイミングが[builder]の中身のフォームの[onSaved]が実行されるタイミングの前になるので、配列の初期化を行ったりが可能です。
///
/// [initialValue]を指定して初期のデータを設定してください。
class FormAppendableListBuilder<T, TValue> extends FormField<List<T>> {
  /// A builder that can add and delete forms.
  ///
  /// Make [builder] return each form.
  ///
  /// You can specify [top] or [bottom] to place additional buttons on the form.
  ///
  /// If [form] is specified, the timing when [onSaved] is executed is before the timing when [onSaved] of the form inside [builder] is executed, so it is possible to initialize the array.
  ///
  /// Set the initial data by specifying [initialValue].
  ///
  /// フォームの追加削除を行うことができるビルダー。
  ///
  /// [builder]に各フォームを返すようにしてください。
  ///
  /// [top]や[bottom]を指定することでフォームの追加ボタンの設置を行うことが可能です。
  ///
  /// [form]を指定した場合、[onSaved]が実行されるタイミングが[builder]の中身のフォームの[onSaved]が実行されるタイミングの前になるので、配列の初期化を行ったりが可能です。
  ///
  /// [initialValue]を指定して初期のデータを設定してください。
  FormAppendableListBuilder({
    Key? key,
    this.form,
    this.top,
    this.bottom,
    this.style,
    required Widget Function(
      BuildContext context,
      FormAppendableListBuilderRef<T, TValue> ref,
      T item,
      int index,
    ) builder,
    TValue Function()? onSaved,
    this.readOnly = false,
    List<T>? initialValue,
    bool enabled = true,
    this.keepAlive = true,
  })  : _builder = builder,
        assert(
          (form == null && onSaved == null) ||
              (form != null && onSaved != null),
          "Both are required when using [form] or [onSaved].",
        ),
        super(
          key: key,
          builder: (state) {
            return const SizedBox.shrink();
          },
          onSaved: (_) {
            final res = onSaved?.call();
            if (res == null) {
              return;
            }
            form!.value = res;
          },
          initialValue: initialValue,
          enabled: enabled,
        );

  /// Widget to be displayed at the top of the list.
  ///
  /// リストの先頭に表示するウィジェット。
  final Widget Function(
      BuildContext context, FormAppendableListBuilderRef<T, TValue> ref)? top;

  /// Widget to be displayed at the bottom of the list.
  ///
  /// リストの末尾に表示するウィジェット。
  final Widget Function(
          BuildContext context, FormAppendableListBuilderRef<T, TValue> ref)?
      bottom;

  /// Builder for each item.
  ///
  /// 各アイテムのビルダー。
  final Widget Function(
    BuildContext context,
    FormAppendableListBuilderRef<T, TValue> ref,
    T item,
    int index,
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

  @override
  FormFieldState<List<T>> createState() =>
      _FormAppendableListBuilderState<T, TValue>();
}

class _FormAppendableListBuilderState<T, TValue> extends FormFieldState<List<T>>
    with AutomaticKeepAliveClientMixin<FormField<List<T>>>
    implements FormAppendableListBuilderRef<T, TValue> {
  @override
  FormAppendableListBuilder<T, TValue> get widget =>
      super.widget as FormAppendableListBuilder<T, TValue>;

  @override
  void add(T item) async {
    setState(() {
      setValue([...(value ?? []), item]);
    });
  }

  @override
  void delete(T item) {
    setState(() {
      setValue(List.from(value ?? [])..remove(item));
    });
  }

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormAppendableListBuilder<T, TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      widget.form?.register(this);
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
    return Padding(
      padding: widget.style?.padding ?? const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.top != null) widget.top!.call(context, this),
          if (value != null)
            for (var i = 0; i < value!.length; i++)
              widget._builder(context, this, value![i], i),
          if (widget.bottom != null) widget.bottom!.call(context, this),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// Controller class for [FormAppendableListBuilder].
///
/// [FormAppendableListBuilder]用のコントローラークラス。
abstract class FormAppendableListBuilderRef<T, TValue> {
  /// Add element [item] to the list.
  ///
  /// 要素[item]をリストに追加します。
  void add(T item);

  /// Removes element [item] from the list.
  ///
  /// 要素[item]をリストから削除します。
  void delete(T item);
}
