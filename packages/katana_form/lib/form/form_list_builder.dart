part of "/katana_form.dart";

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
class FormListBuilder<T, TValue> extends FormField<List<T>> {
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
  FormListBuilder({
    required Widget Function(
      BuildContext context,
      FormListBuilderRef<T, TValue> ref,
      T item,
      int index,
    ) builder,
    super.key,
    this.form,
    this.top,
    this.bottom,
    this.style,
    this.onChanged,
    TValue Function(List<T> value)? onSaved,
    String? Function(List<T> value)? validator,
    this.readOnly = false,
    super.initialValue,
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
          validator: (value) {
            final res = validator?.call(value ?? []);
            if (res == null) {
              return null;
            }
            return res;
          },
        );

  /// Widget to be displayed at the top of the list.
  ///
  /// リストの先頭に表示するウィジェット。
  final Widget Function(
      BuildContext context, FormListBuilderRef<T, TValue> ref)? top;

  /// Widget to be displayed at the bottom of the list.
  ///
  /// リストの末尾に表示するウィジェット。
  final Widget Function(
      BuildContext context, FormListBuilderRef<T, TValue> ref)? bottom;

  /// Builder for each item.
  ///
  /// 各アイテムのビルダー。
  final Widget Function(
    BuildContext context,
    FormListBuilderRef<T, TValue> ref,
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

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(List<T> value)? onChanged;

  @override
  FormFieldState<List<T>> createState() =>
      _FormAppendableListBuilderState<T, TValue>();
}

class _FormAppendableListBuilderState<T, TValue> extends FormFieldState<List<T>>
    with AutomaticKeepAliveClientMixin<FormField<List<T>>>
    implements FormListBuilderRef<T, TValue> {
  @override
  int get version => _version;
  int _version = 0;

  @override
  FormListBuilder<T, TValue> get widget =>
      super.widget as FormListBuilder<T, TValue>;

  @override
  void add(T item) async {
    setState(() {
      final newList = <T>[...(value ?? []), item];
      _version++;
      setValue(newList);
      widget.onChanged?.call(newList);
    });
  }

  @override
  void update(int index, T item) {
    if (value == null || index >= value!.length || index < 0) {
      return;
    }
    setState(() {
      final newList = List<T>.from(value ?? []);
      newList[index] = item;
      setValue(newList);
      widget.onChanged?.call(newList);
    });
  }

  @override
  void delete(T item) {
    setState(() {
      final newList = List<T>.from(value ?? []);
      newList.remove(item);
      _version++;
      setValue(newList);
      widget.onChanged?.call(newList);
    });
  }

  @override
  void deleteAt(int index) {
    if (value == null || index >= value!.length || index < 0) {
      return;
    }
    setState(() {
      final newList = List<T>.from(value ?? []);
      newList.removeAt(index);
      _version++;
      setValue(newList);
      widget.onChanged?.call(newList);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormListBuilder<T, TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form != oldWidget.form) {
      oldWidget.form?.unregister(this);
      widget.form?.register(this);
    }
    if (!oldWidget.initialValue.equalsTo(widget.initialValue) &&
        widget.initialValue != null) {
      _version = 0;
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
    final value = this.value;
    return FormStyleScope(
      style: widget.style,
      enabled: widget.enabled,
      child: Padding(
        padding: widget.style?.padding ?? const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.top != null) widget.top!.call(context, this),
            if (value != null)
              for (var i = 0; i < value.length; i++)
                widget._builder(context, this, value[i], i),
            if (widget.bottom != null) widget.bottom!.call(context, this),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// Controller class for [FormListBuilder].
///
/// [FormListBuilder]用のコントローラークラス。
abstract class FormListBuilderRef<T, TValue> {
  /// Version of the list.
  ///
  /// リストのバージョン。
  int get version;

  /// Add element [item] to the list.
  ///
  /// 要素[item]をリストに追加します。
  void add(T item);

  /// Update the element at the specified [index] to [item].
  ///
  /// 指定した[index]の要素を[item]に更新します。
  void update(int index, T item);

  /// Removes element [item] from the list.
  ///
  /// 要素[item]をリストから削除します。
  void delete(T item);

  /// Removes the [index]th element from the list.
  ///
  /// [index]番目の要素をリストから削除します。
  void deleteAt(int index);
}
