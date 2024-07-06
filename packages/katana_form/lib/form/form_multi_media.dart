part of '/katana_form.dart';

const _kTypeKey = "type";
const _kPathKey = "path";

/// Default height of the form when using [FormMultiMediaInlineDelegate].
///
/// [FormMultiMediaInlineDelegate]を利用する際のフォームのデフォルトの高さ。
const kFormMultiMediaInlineHeight = 96.0;

/// Form for submitting images and videos. Multiple media can be submitted.
///
/// All media is managed by [FormMediaValue].
///
/// The path to the file asset and the asset type are passed to [FormMediaValue] as [FormMediaType], so display and save accordingly.
///
/// Describe the process when the form is tapped in the [onTap] field. Normally, use `image_picker` or `file_picker` to display a dialog to select a file and return the media path to `onUpdate`.
///
/// Implement the part that actually displays the image based on the [FormMediaValue] in [builder].
///
/// Specify a callback for deleting items in [onRemove].
///
/// The entire design can be changed by specifying [delegate].
/// Specify [FormMultiMediaInlineDelegate] to display a list of media inline. Specify [FormMultiMediaListTileDelegate] to display a list of media in a vertical list view.
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
/// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if the item is not specified.
///
/// Other error checking is performed by specifying [validator].
/// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
///
/// Deactivated if [enabled] is `false` or [readOnly] is `true`.
///
/// If [maxLength] is specified, no more items can be added.
///
/// 画像や映像を投稿するためのフォーム。複数のメディアを投稿することが可能です。
///
/// メディアはすべて[FormMediaValue]で管理されます。
///
/// [FormMediaValue]にファイルアセットへのパスとアセットのタイプが[FormMediaType]で渡されるのでそれに応じて表示や保存を行ってください。
///
/// [onTap]にフォームがタップされた場合の処理を記述します。通常は`image_picker`や`file_picker`を用いてファイルを選択するダイアログを表示しメディアのパスを`onUpdate`に返すようにします。
///
/// [builder]に[FormMediaValue]を元に実際に画像を表示する部分を実装してください。
///
/// [onRemove]に項目の削除時のコールバックを指定します。
///
/// [delegate]を指定することで、全体のデザインを変更することが可能です。
/// [FormMultiMediaInlineDelegate]を指定するとインライン内でメディアの一覧が表示されるようになります。[FormMultiMediaListTileDelegate]を指定すると縦にリスト表示でメディアの一覧が表示されるようになります。
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
/// [emptyErrorText]が指定されている時に限り、項目が指定されていない場合[emptyErrorText]がエラーとして表示されます。
///
/// それ以外のエラーチェックは[validator]を指定することで行ないます。
/// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
///
/// [enabled]が`false`になる、もしくは[readOnly]が`true`になっている場合は非有効化されます。
///
/// [maxLength]が指定されている場合、それ以上項目を増やすことができなくなります。
@immutable
class FormMultiMedia<TValue> extends FormField<List<FormMediaValue>> {
  /// Form for submitting images and videos. Multiple media can be submitted.
  ///
  /// All media is managed by [FormMediaValue].
  ///
  /// The path to the file asset and the asset type are passed to [FormMediaValue] as [FormMediaType], so display and save accordingly.
  ///
  /// Describe the process when the form is tapped in the [onTap] field. Normally, use `image_picker` or `file_picker` to display a dialog to select a file and return the media path to `onUpdate`.
  ///
  /// Implement the part that actually displays the image based on the [FormMediaValue] in [builder].
  ///
  /// Specify a callback for deleting items in [onRemove].
  ///
  /// The entire design can be changed by specifying [delegate].
  /// Specify [FormMultiMediaInlineDelegate] to display a list of media inline. Specify [FormMultiMediaListTileDelegate] to display a list of media in a vertical list view.
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
  /// Only when [emptyErrorText] is specified, [emptyErrorText] will be displayed as an error if the item is not specified.
  ///
  /// Other error checking is performed by specifying [validator].
  /// If a string other than [Null] is returned in the callback, the string is displayed as an error statement. If [Null] is returned, it is processed as no error.
  ///
  /// Deactivated if [enabled] is `false` or [readOnly] is `true`.
  ///
  /// If [maxLength] is specified, no more items can be added.
  ///
  /// 画像や映像を投稿するためのフォーム。複数のメディアを投稿することが可能です。
  ///
  /// メディアはすべて[FormMediaValue]で管理されます。
  ///
  /// [FormMediaValue]にファイルアセットへのパスとアセットのタイプが[FormMediaType]で渡されるのでそれに応じて表示や保存を行ってください。
  ///
  /// [onTap]にフォームがタップされた場合の処理を記述します。通常は`image_picker`や`file_picker`を用いてファイルを選択するダイアログを表示しメディアのパスを`onUpdate`に返すようにします。
  ///
  /// [builder]に[FormMediaValue]を元に実際に画像を表示する部分を実装してください。
  ///
  /// [onRemove]に項目の削除時のコールバックを指定します。
  ///
  /// [delegate]を指定することで、全体のデザインを変更することが可能です。
  /// [FormMultiMediaInlineDelegate]を指定するとインライン内でメディアの一覧が表示されるようになります。[FormMultiMediaListTileDelegate]を指定すると縦にリスト表示でメディアの一覧が表示されるようになります。
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
  /// [emptyErrorText]が指定されている時に限り、項目が指定されていない場合[emptyErrorText]がエラーとして表示されます。
  ///
  /// それ以外のエラーチェックは[validator]を指定することで行ないます。
  /// コールバック内で[Null]以外を返すようにするとその文字列がエラー文として表示されます。[Null]の場合はエラーなしとして処理されます。
  ///
  /// [enabled]が`false`になる、もしくは[readOnly]が`true`になっている場合は非有効化されます。
  ///
  /// [maxLength]が指定されている場合、それ以上項目を増やすことができなくなります。
  FormMultiMedia({
    super.key,
    this.form,
    this.style,
    this.onRemove,
    this.maxLength,
    this.labelText,
    List<FormMediaValue>? initialValue,
    this.emptyErrorText,
    this.readOnly = false,
    required Widget Function(
      BuildContext context,
      FormMediaValue value,
    ) builder,
    required this.onTap,
    this.onChanged,
    TValue Function(List<FormMediaValue> value)? onSaved,
    String Function(List<FormMediaValue> value)? validator,
    this.delegate = const FormMultiMediaInlineDelegate(),
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
            if (emptyErrorText.isNotEmpty && value.isEmpty) {
              return emptyErrorText;
            }
            return validator?.call(value ?? []);
          },
          initialValue: initialValue ?? [],
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

  /// If specified, no more items can be added.
  ///
  /// 指定されている場合、それ以上項目を増やすことができなくなります。
  final int? maxLength;

  /// Callback when deleting an item.
  ///
  /// The data at the time of deletion is passed to [value].
  ///
  /// 項目の削除時のコールバック。
  ///
  /// [value]に削除時のデータが渡されます。
  final void Function(FormMediaValue value)? onRemove;

  /// A delegate to determine the design of the form.
  ///
  /// Specify [FormMultiMediaInlineDelegate] to display a list of media inline. Specify [FormMultiMediaListTileDelegate] to display a list of media in a vertical list view.
  ///
  /// フォームのデザインを決めるためのデリゲート。
  ///
  /// [FormMultiMediaInlineDelegate]を指定するとインライン内でメディアの一覧が表示されるようになります。[FormMultiMediaListTileDelegate]を指定すると縦にリスト表示でメディアの一覧が表示されるようになります。
  final FormMultiMediaDelegate delegate;

  /// Implement the part that actually displays the image based on [FormMediaValue].
  ///
  /// The [context] is passed the [BuildContext] and the [value] is passed the [FormMediaValue] of the media to be displayed.
  ///
  /// [FormMediaValue]を元に実際に画像を表示する部分を実装してください。
  ///
  /// [context]に[BuildContext]、[value]に表示するメディアの[FormMediaValue]が渡されます。
  final Widget Function(
    BuildContext context,
    FormMediaValue value,
  ) _builder;

  /// Describe what to do when the form is tapped.
  ///
  /// Normally, use `image_picker` or `file_picker` to display a dialog to select a file and return the media path to [FormMediaRef.update].
  ///
  /// フォームがタップされた場合の処理を記述します。
  ///
  /// 通常は`image_picker`や`file_picker`を用いてファイルを選択するダイアログを表示しメディアのパスを[FormMediaRef.update]に返すようにします。
  final void Function(FormMultiMediaRef ref) onTap;

  /// Callback to be executed each time the value is changed.
  ///
  /// The current value is passed to `value`.
  ///
  /// 値が変更されるたびに実行されるコールバック。
  ///
  /// `value`に現在の値が渡されます。
  final void Function(List<FormMediaValue> value)? onChanged;

  /// Error text. Only displayed if no characters are entered.
  ///
  /// エラーテキスト。入力された文字がない場合のみ表示されます。
  final String? emptyErrorText;

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

  /// Label text for forms.
  ///
  /// フォーム用のラベルテキスト。
  final String? labelText;

  @override
  // ignore: library_private_types_in_public_api
  _FormMultiMediaState<TValue> createState() => _FormMultiMediaState<TValue>();
}

class _FormMultiMediaState<TValue> extends FormFieldState<List<FormMediaValue>>
    with AutomaticKeepAliveClientMixin<FormField<List<FormMediaValue>>>
    implements FormMultiMediaRef<TValue> {
  @override
  FormMultiMedia<TValue> get widget => super.widget as FormMultiMedia<TValue>;
  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
  }

  @override
  void didUpdateWidget(FormMultiMedia<TValue> oldWidget) {
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
  void didChange(List<FormMediaValue>? value) {
    widget.onChanged?.call(value ?? []);
    super.didChange(value);
  }

  @override
  void update(Uri fileUri, FormMediaType type) {
    if (widget.maxLength != null && widget.maxLength! <= value.length) {
      return;
    }
    final val = FormMediaValue(type: type, uri: fileUri);
    if (value.contains(val)) {
      return;
    }
    didChange([...value ?? [], val]);
    setState(() {});
  }

  @override
  void delete(dynamic dataOrIndex) {
    if (dataOrIndex is FormMediaValue) {
      if (!value.contains(dataOrIndex)) {
        return;
      }
      final copied = List<FormMediaValue>.from(value ?? []);
      copied.remove(dataOrIndex);
      widget.onRemove?.call(dataOrIndex);
      setValue(copied);
      setState(() {});
    } else if (dataOrIndex is int) {
      if (dataOrIndex < 0 || value.length <= dataOrIndex) {
        return;
      }
      final copied = List<FormMediaValue>.from(value ?? []);
      widget.onRemove?.call(copied.removeAt(dataOrIndex));
      setValue(copied);
      setState(() {});
    }
  }

  @override
  void reset() {
    super.reset();
    setValue([]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.delegate.build(
      context,
      this,
      widget,
      value ?? [],
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/// A delegate to build a [FormMultiMedia] with a design of the type arranged in a list.
///
/// Specify the text to be added in [addLabel].
///
/// Specify an icon for adding an item in [addIcon] and an icon for removing an item in [removeIcon].
///
/// リストに並べるタイプのデザインを持つ[FormMultiMedia]を構築するためのデリゲート。
///
/// [addLabel]に追加を行うためのテキストを指定してください。
///
/// [addIcon]に追加時のアイコン、[removeIcon]に各項目を削除するときのアイコンを指定します。
@immutable
class FormMultiMediaListTileDelegate extends FormMultiMediaDelegate {
  /// A delegate to build a [FormMultiMedia] with a design of the type arranged in a list.
  ///
  /// Specify the text to be added in [addLabel].
  ///
  /// Specify an icon for adding an item in [addIcon] and an icon for removing an item in [removeIcon].
  ///
  /// リストに並べるタイプのデザインを持つ[FormMultiMedia]を構築するためのデリゲート。
  ///
  /// [addLabel]に追加を行うためのテキストを指定してください。
  ///
  /// [addIcon]に追加時のアイコン、[removeIcon]に各項目を削除するときのアイコンを指定します。
  const FormMultiMediaListTileDelegate({
    required this.addLabel,
    this.addIcon = Icons.add,
    this.removeIcon = Icons.close,
  });

  /// Text at time of addition.
  ///
  /// 追加時のテキスト。
  final Widget addLabel;

  /// Icon at the time of addition.
  ///
  /// 追加時のアイコン。
  final IconData addIcon;

  /// Icon for deleting each item.
  ///
  /// 各項目を削除するときのアイコン。
  final IconData removeIcon;

  @override
  Widget build<TValue>(
    BuildContext context,
    FormMultiMediaRef<TValue> ref,
    FormMultiMedia<TValue> widget,
    List<FormMediaValue> values,
  ) {
    return Padding(
      padding: widget.style?.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...values.map((value) {
            return _buildItem(
              context,
              value,
              widget._builder,
              widget.readOnly || !widget.enabled ? null : ref.update,
              widget.readOnly || !widget.enabled
                  ? null
                  : () => ref.delete(value),
            );
          }),
          if (widget.maxLength == null || widget.maxLength! > values.length)
            ListTile(
              onTap: widget.readOnly || !widget.enabled
                  ? null
                  : () {
                      widget.onTap.call(ref);
                    },
              title: addLabel,
              trailing: Icon(addIcon),
            ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    FormMediaValue value,
    Widget Function(
      BuildContext context,
      FormMediaValue value,
    ) builder,
    void Function(Uri fileUri, FormMediaType type)? onUpdate,
    VoidCallback? onRemove,
  ) {
    if (value.uri.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return ListTile(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: builder.call(context, value),
          ),
        ),
        title: Text(value.uri!.last()),
        trailing: IconButton(
          onPressed: onRemove == null
              ? null
              : () {
                  onRemove();
                },
          icon: Icon(removeIcon),
        ),
      );
    }
  }
}

/// A delegate to build [FormMultiMedia] with a type design that fits inline with the form.
///
/// Specify an icon for adding an item in [addIcon] and an icon for removing an item in [removeIcon].
///
/// フォームのインラインに収まるタイプのデザインを持つ[FormMultiMedia]を構築するためのデリゲート。
///
/// [addIcon]に追加時のアイコン、[removeIcon]に各項目を削除するときのアイコンを指定します。
@immutable
class FormMultiMediaInlineDelegate extends FormMultiMediaDelegate {
  /// A delegate to build [FormMultiMedia] with a type design that fits inline with the form.
  ///
  /// Specify an icon for adding an item in [addIcon] and an icon for removing an item in [removeIcon].
  ///
  /// フォームのインラインに収まるタイプのデザインを持つ[FormMultiMedia]を構築するためのデリゲート。
  ///
  /// [addIcon]に追加時のアイコン、[removeIcon]に各項目を削除するときのアイコンを指定します。
  const FormMultiMediaInlineDelegate({
    this.addIcon = Icons.add_a_photo,
    this.removeIcon = Icons.remove_circle,
  });

  /// Icon at the time of addition.
  ///
  /// 追加時のアイコン。
  final IconData addIcon;

  /// Icon for deleting each item.
  ///
  /// 各項目を削除するときのアイコン。
  final IconData removeIcon;

  @override
  Widget build<TValue>(
    BuildContext context,
    FormMultiMediaRef<TValue> ref,
    FormMultiMedia<TValue> widget,
    List<FormMediaValue> values,
  ) {
    return FormStyleContainer(
      style: widget.style,
      labelText: widget.labelText,
      alignment: Alignment.centerLeft,
      padding: widget.style?.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        height: widget.style?.height ?? kFormMultiMediaInlineHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.maxLength == null || widget.maxLength! > values.length)
                Container(
                  width: widget.style?.width ?? kFormMultiMediaInlineHeight,
                  height: widget.style?.height ?? kFormMultiMediaInlineHeight,
                  margin: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: widget.style?.color ??
                            Theme.of(context).dividerColor,
                        width: widget.style?.borderWidth ?? 2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    )),
                    onPressed: widget.readOnly || !widget.enabled
                        ? null
                        : () {
                            widget.onTap.call(ref);
                          },
                    child: Icon(
                      addIcon,
                      color:
                          widget.style?.color ?? Theme.of(context).dividerColor,
                      size: (widget.style?.height ??
                              kFormMultiMediaInlineHeight) /
                          3.0,
                    ),
                  ),
                ),
              ...values.mapAndRemoveEmpty(
                (value) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildItem(
                      context,
                      widget,
                      value,
                      widget._builder,
                      widget.readOnly || !widget.enabled ? null : ref.update,
                      widget.readOnly || !widget.enabled
                          ? null
                          : () => ref.delete(value),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem<TValue>(
    BuildContext context,
    FormMultiMedia<TValue> widget,
    FormMediaValue value,
    Widget Function(
      BuildContext context,
      FormMediaValue value,
    ) builder,
    void Function(Uri fileUri, FormMediaType type)? onUpdate,
    VoidCallback? onRemove,
  ) {
    if (value.uri.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Stack(
        children: [
          InkWell(
            mouseCursor: widget.enabled == false
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            onLongPress: onRemove == null
                ? null
                : () {
                    onRemove();
                  },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: builder.call(context, value),
            ),
          ),
          if (onRemove != null)
            Positioned.fill(
              child: InkWell(
                onTap: () {
                  onRemove();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.remove_circle,
                    size: 24,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            )
        ],
      );
    }
  }
}

/// A delegate to determine the design of [FormMultiMedia].
///
/// Describe the entire build in [build].
///
/// [FormMultiMedia]のデザインを決めるためのデリゲート。
///
/// [build]に全体のビルド内容を記載します。
@immutable
abstract class FormMultiMediaDelegate {
  /// A delegate to determine the design of [FormMultiMedia].
  ///
  /// Describe the entire build in [build].
  ///
  /// [FormMultiMedia]のデザインを決めるためのデリゲート。
  ///
  /// [build]に全体のビルド内容を記載します。
  const FormMultiMediaDelegate();

  /// Build the whole thing.
  ///
  /// Pass [context] the [BuildContext], [widget] the original widget being built, and [values] the current values.
  ///
  /// The callback for updating is passed to [onUpdate] and the callback for deleting is passed to [onRemove].
  ///
  /// 全体をビルドします。
  ///
  /// [context]に[BuildContext]、[widget]にビルドされている元のWidget、[values]に現在の値を渡します。
  ///
  /// [onUpdate]に更新時のコールバックと[onRemove]に削除時のコールバックが渡されます。
  Widget build<TValue>(
    BuildContext context,
    FormMultiMediaRef<TValue> ref,
    FormMultiMedia<TValue> widget,
    List<FormMediaValue> values,
  );
}

/// Class for controlling [FormMultiMedia].
///
/// [FormMultiMedia]のコントロールを行うためのクラス。
abstract class FormMultiMediaRef<TValue> {
  /// Upload the file by specifying the [fileUri] of the file.
  ///
  /// Specify whether it is an image or a video in [type].
  ///
  /// ファイルの[fileUri]を指定してアップロードを行います。
  ///
  /// [type]で画像か動画かを指定します。
  void update(Uri fileUri, FormMediaType type);

  /// Delete an item by specifying [dataOrIndex].
  ///
  /// [dataOrIndex]を指定して項目を削除します。
  void delete(dynamic dataOrIndex);
}
