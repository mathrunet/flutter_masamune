part of '/katana_form.dart';

/// Drop down form to select from there with [Map] as an option.
///
/// Unlike [FormMapDropdownField], multiple selections can be made like tags.
/// You can also add, edit, or delete choices.
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
/// By specifying [picker], it is possible to set the selection method for [Map].
///
/// Deactivated when [enabled] is set to `false`.
///
/// [Map]を選択肢としてそこから選択するためのドロップダウンフォーム。
///
/// [FormMapDropdownField]とは異なり、タグのように複数選択が可能です。
/// また、選択肢の追加や編集、削除も可能です。
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
/// [picker]を指定することで[Map]の選択方法を設定することが可能です。
///
/// [enabled]が`false`になると非有効化されます。
class FormMapTagDropdownField<TValue> extends FormField<List<String>> {
  /// Drop down form to select from there with [Map] as an option.
  ///
  /// Unlike [FormMapDropdownField], multiple selections can be made like tags.
  /// You can also add, edit, or delete choices.
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
  /// By specifying [picker], it is possible to set the selection method for [Map].
  ///
  /// Deactivated when [enabled] is set to `false`.
  ///
  /// [Map]を選択肢としてそこから選択するためのドロップダウンフォーム。
  ///
  /// [FormMapDropdownField]とは異なり、タグのように複数選択が可能です。
  /// また、選択肢の追加や編集、削除も可能です。
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
  /// [picker]を指定することで[Map]の選択方法を設定することが可能です。
  ///
  /// [enabled]が`false`になると非有効化されます。
  FormMapTagDropdownField({
    super.key,
    this.form,
    this.style,
    super.enabled,
    this.hintText,
    this.labelText,
    this.readOnly = false,
    required this.picker,
    this.onChanged,
    this.maxChips,
    this.emptyErrorText,
    this.suggestionStyle,
    this.keepAlive = true,
    this.prefix,
    this.suffix,
    this.showDropdownIcon = true,
    this.dropdownIcon,
    TValue Function(List<String> value)? onSaved,
    String Function(List<String>? value)? validator,
    List<String> super.initialValue = const [],
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
            if (emptyErrorText.isNotEmpty && value.isEmpty) {
              return emptyErrorText;
            }
            return validator?.call(value);
          },
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

  /// Picker object for selecting from [Map].
  ///
  /// [Map]からを選択するためのピッカーオブジェクト。
  final FormMapTagDropdownFieldPicker picker;

  /// Maximum number of [Chip].
  ///
  /// 最大の[Chip]数。
  final int? maxChips;

  /// Hint to be displayed on the form. Displayed when no text is entered.
  ///
  /// フォームに表示するヒント。文字が入力されていない場合表示されます。
  final String? hintText;

  /// Label text for forms.
  ///
  /// フォーム用のラベルテキスト。
  final String? labelText;

  /// If this is `true`, the form cannot be filled out and changed from its initial value.
  ///
  /// これが`true`の場合、フォームの入力が行えずに初期値から変更することができなくなります。
  final bool readOnly;

  /// Window style for suggestions.
  ///
  /// サジェスト用のウインドウのスタイル。
  final SuggestionStyle? suggestionStyle;

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
  final void Function(List<String>? value)? onChanged;

  /// true` if you want to display icons for drop-downs.
  ///
  /// ドロップダウン用のアイコンを表示する場合`true`。
  final bool showDropdownIcon;

  /// Icon for dropdown. Valid only if [showDropdownIcon] is `true`.
  ///
  /// ドロップダウン用のアイコン。[showDropdownIcon]が`true`の場合のみ有効。
  final Widget? dropdownIcon;

  @override
  FormFieldState<List<String>> createState() =>
      _FormMapTagDropdownField<TValue>();
}

class _FormMapTagDropdownField<TValue> extends FormFieldState<List<String>>
    with AutomaticKeepAliveClientMixin<FormField<List<String>>>
    implements FormMapTagDropdownFieldRef<List<String>> {
  late _SelectBoxController _selectBoxController;
  final _layerLink = LayerLink();
  final StreamController<Map<String, String>?> _selectionsStreamController =
      StreamController<Map<String, String>?>.broadcast();
  final StreamController<List<String>?> _selectedStreamController =
      StreamController<List<String>?>.broadcast();
  Map<String, String>? _selections;

  RenderBox? get _renderBox => context.findRenderObject() as RenderBox?;

  @override
  FormMapTagDropdownField<TValue> get widget =>
      super.widget as FormMapTagDropdownField<TValue>;

  bool get _hasReachedMaxChips =>
      widget.maxChips != null && value.length >= widget.maxChips!;

  void select(String key) {
    if (!_hasReachedMaxChips && widget.enabled) {
      didChange([...value ?? [], key]);
      if (_hasReachedMaxChips) {
        _selectBoxController.close();
      }
      _selectedStreamController.add(value);
      widget.onChanged?.call(value?.toList(growable: false));
    } else {
      _selectBoxController.close();
    }
  }

  void unselect(String key) {
    if (widget.enabled) {
      didChange([...value?.where((e) => e != key) ?? []]);
      _selectedStreamController.add(value);
      widget.onChanged?.call(value?.toList(growable: false));
    } else {
      _selectBoxController.close();
    }
  }

  void add(String value) {
    if (widget.enabled) {
      final key = uuid();
      _selections?.putIfAbsent(key, () => value);
      _selectionsStreamController.add(_selections);
      widget.picker.onAdd?.call(MapEntry(key, value));
      select(key);
    }
  }

  void edit(String key, String value) {
    if (widget.enabled && _selections?[key] != value) {
      _selections?[key] = value;
      _selectionsStreamController.add(_selections);
      widget.picker.onEdit?.call(MapEntry(key, value));
      unselect(key);
      select(key);
    }
  }

  void delete(String key) {
    if (widget.enabled && _selections.containsKey(key)) {
      _selections?.remove(key);
      _selectionsStreamController.add(_selections);
      widget.picker.onDelete?.call(key);
      unselect(key);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.form?.register(this);
    _selections = widget.picker.data.clone();
    _selectBoxController = _SelectBoxController(context);

    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      _initOverlayEntry();
    });
  }

  @override
  void didUpdateWidget(FormMapTagDropdownField oldWidget) {
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
    _selectionsStreamController.close();
    _selectedStreamController.close();
    _selectBoxController.close();
    super.dispose();
    widget.form?.unregister(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final mainTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.color,
        ) ??
        TextStyle(
          color: widget.style?.color ?? theme.textTheme.titleMedium?.color,
        );
    final subTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.subColor,
        ) ??
        TextStyle(
          color: widget.style?.subColor ??
              widget.style?.color?.withOpacity(0.5) ??
              theme.textTheme.titleMedium?.color?.withOpacity(0.5),
        );
    final errorTextStyle = widget.style?.errorTextStyle?.copyWith(
          color: widget.style?.errorColor,
        ) ??
        widget.style?.textStyle?.copyWith(
          color: widget.style?.errorColor,
        ) ??
        TextStyle(
          color: widget.style?.errorColor ?? theme.colorScheme.error,
        );
    final disabledTextStyle = widget.style?.textStyle?.copyWith(
          color: widget.style?.disabledColor,
        ) ??
        TextStyle(
          color: widget.style?.disabledColor ?? theme.disabledColor,
        );

    InputBorder getBorderSide(Color borderColor) {
      switch (widget.style?.borderStyle) {
        case FormInputBorderStyle.outline:
          return OutlineInputBorder(
            borderRadius: widget.style?.borderRadius ??
                const BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(
              color: borderColor,
              width: widget.style?.borderWidth ?? 1.0,
            ),
          );
        case FormInputBorderStyle.underline:
          return UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.style?.borderColor ?? theme.dividerColor,
              width: widget.style?.borderWidth ?? 1.0,
            ),
            borderRadius: widget.style?.borderRadius ??
                const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
          );
        default:
          return const OutlineInputBorder(
            borderSide: BorderSide.none,
          );
      }
    }

    final borderSide =
        getBorderSide(widget.style?.borderColor ?? theme.dividerColor);
    final errorBorderSide =
        getBorderSide(widget.style?.errorColor ?? theme.colorScheme.error);
    final disabledBorderSide =
        getBorderSide(widget.style?.disabledColor ?? theme.disabledColor);

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (SizeChangedLayoutNotification val) {
        WidgetsBinding.instance.scheduleFrameCallback((_) async {
          _selectBoxController.overlayEntry?.markNeedsBuild();
        });
        return true;
      },
      child: InkWell(
        onTap: () {
          if (!_selectBoxController.isOpened && !_hasReachedMaxChips) {
            _selectBoxController.open();
          }
        },
        child: SizeChangedLayoutNotifier(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: widget.style?.alignment,
                padding: widget.style?.padding ??
                    const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: widget.style?.height,
                  width: widget.style?.width,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        constraints: const BoxConstraints(minHeight: 32),
                        child: MouseRegion(
                          cursor: widget.enabled == false
                              ? SystemMouseCursors.forbidden
                              : SystemMouseCursors.text,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: widget.style?.contentPadding ??
                                  const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                              fillColor: widget.style?.backgroundColor,
                              filled: widget.style?.backgroundColor != null,
                              isDense: true,
                              border: widget.style?.border ?? borderSide,
                              enabledBorder: widget.style?.border ?? borderSide,
                              disabledBorder: widget.style?.disabledBorder ??
                                  widget.style?.border ??
                                  disabledBorderSide,
                              errorBorder: widget.style?.errorBorder ??
                                  widget.style?.border ??
                                  errorBorderSide,
                              focusedBorder: widget.style?.border ?? borderSide,
                              focusedErrorBorder: widget.style?.errorBorder ??
                                  widget.style?.border ??
                                  errorBorderSide,
                              hintText: widget.hintText,
                              labelText: widget.labelText,
                              prefix: widget.prefix?.child ??
                                  widget.style?.prefix?.child,
                              suffix: widget.suffix?.child ??
                                  widget.style?.suffix?.child,
                              prefixIcon: widget.prefix?.icon ??
                                  widget.style?.prefix?.icon,
                              suffixIcon: widget.suffix?.icon ??
                                  widget.style?.suffix?.icon,
                              prefixText: widget.prefix?.label ??
                                  widget.style?.prefix?.label,
                              suffixText: widget.suffix?.label ??
                                  widget.style?.suffix?.label,
                              prefixIconColor: widget.prefix?.iconColor ??
                                  widget.style?.prefix?.iconColor,
                              suffixIconColor: widget.suffix?.iconColor ??
                                  widget.style?.suffix?.iconColor,
                              prefixIconConstraints:
                                  widget.prefix?.iconConstraints ??
                                      widget.style?.prefix?.iconConstraints,
                              suffixIconConstraints:
                                  widget.suffix?.iconConstraints ??
                                      widget.style?.suffix?.iconConstraints,
                              labelStyle: widget.enabled
                                  ? mainTextStyle
                                  : disabledTextStyle,
                              hintStyle: subTextStyle,
                              suffixStyle: subTextStyle,
                              prefixStyle: subTextStyle,
                              counterStyle: subTextStyle,
                              helperStyle: subTextStyle,
                              errorStyle: errorTextStyle,
                              errorText: errorText,
                            ),
                            child: widget.picker
                                .buildChips(context, _selections ?? {}, this),
                          ),
                        ),
                      ),
                      if (widget.showDropdownIcon)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: IgnorePointer(
                                ignoring: true,
                                child: IconTheme(
                                  data: IconThemeData(
                                    size: 24,
                                    color: widget.enabled
                                        ? mainTextStyle.color
                                        : disabledTextStyle.color,
                                  ),
                                  child: widget.dropdownIcon ??
                                      const Icon(Icons.arrow_drop_down),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              CompositedTransformTarget(
                link: _layerLink,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  void _initOverlayEntry() {
    final theme = Theme.of(context);
    final suggestionStyle = widget.suggestionStyle ?? const SuggestionStyle();
    _selectBoxController.overlayEntry = OverlayEntry(
      builder: (context) {
        final size = _renderBox!.size;
        final renderBoxOffset = _renderBox!.localToGlobal(Offset.zero);
        final topAvailableSpace = renderBoxOffset.dy;
        final mq = MediaQuery.of(context);
        final bottomAvailableSpace = mq.size.height -
            mq.viewInsets.bottom -
            renderBoxOffset.dy -
            size.height;
        var suggestionBoxHeight = max(topAvailableSpace, bottomAvailableSpace);
        suggestionBoxHeight =
            min(suggestionBoxHeight, suggestionStyle.maxHeight);
        final showTop = topAvailableSpace > bottomAvailableSpace;
        final compositedTransformFollowerOffset =
            showTop ? Offset(0, -size.height) : Offset.zero;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _selectBoxController.close();
          },
          child: Stack(
            children: [
              StreamBuilder<Map<String, String>?>(
                stream: _selectionsStreamController.stream,
                initialData: _selections,
                builder: (context, _selectionsSnapshot) {
                  if (_selectionsSnapshot.hasData) {
                    return StreamBuilder<List<String>?>(
                      stream: _selectedStreamController.stream,
                      initialData: value,
                      builder: (context, _selectedSnapshot) {
                        if (_selectedSnapshot.hasData) {
                          final suggestionWidgets = widget.picker.buildPicker(
                            context,
                            _selectionsSnapshot.data!,
                            this,
                          );
                          final suggestionsListView = Material(
                            elevation: 0,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: suggestionStyle.color ??
                                    theme.colorScheme.onSurface,
                              ),
                              child: IconTheme(
                                data: IconThemeData(
                                  color: suggestionStyle.color ??
                                      theme.colorScheme.onSurface,
                                ),
                                child: Container(
                                  color: suggestionStyle.backgroundColor ??
                                      theme.colorScheme.surface,
                                  constraints: BoxConstraints(
                                    maxHeight: suggestionBoxHeight,
                                  ),
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: suggestionWidgets.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return suggestionWidgets[index];
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          return Positioned(
                            width: widget.picker.width ?? size.width,
                            left: widget.picker.width != null
                                ? size.width - widget.picker.width!
                                : null,
                            child: CompositedTransformFollower(
                              link: _layerLink,
                              showWhenUnlinked: false,
                              offset: compositedTransformFollowerOffset,
                              child: !showTop
                                  ? suggestionsListView
                                  : FractionalTranslation(
                                      translation: const Offset(0, -1),
                                      child: suggestionsListView,
                                    ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Class that defines the reference for [FormMapTagDropdownField].
///
/// This class is used to control the form field from the outside.
///
/// [FormMapTagDropdownField]のためのリファレンスを定義するクラス。
///
/// このクラスはフォームフィールドを外部から制御するために使用します。
abstract class FormMapTagDropdownFieldRef<T> {
  /// [key] to select that element.
  ///
  /// [key]を指定することでその要素を選択します。
  void select(String key);

  /// Unselect the element with [key].
  ///
  /// [key]の要素を選択解除します。
  void unselect(String key);

  /// Add a new element.
  ///
  /// Specify the element name in [value]. [key] is generated automatically.
  ///
  /// 新しい要素を追加します。
  ///
  /// [value]に要素名を指定します。[key]は自動で生成されます。
  void add(String value);

  /// Edit the element with [key].
  ///
  /// Specify the new name in [value].
  ///
  /// [key]の要素を編集します。
  ///
  /// 新しい名前を[value]に指定します。
  void edit(String key, String value);

  /// Delete the element with [key].
  ///
  /// [key]の要素を削除します。
  void delete(String key);

  /// The current value of the form field.
  T? get value;
}

/// Class that defines a picker style to select from [Map] for tags.
///
/// Pass `Map<String, String>` to [data].
/// Key in [Map] is the ID for selection and Value is the display label for selection.
///
/// The display of selected values can be customized by specifying [chipBuilder].
///
/// By specifying [onEdit], it is possible to set up a callback to be executed when editing choices.
///
/// タグ用の[Map]から選択するためのピッカースタイルを定義するクラス。
///
/// `Map<String, String>`を[data]に渡します。
/// [Map]のKeyが選択用のID、Valueが選択用の表示ラベルになります。
///
/// [chipBuilder]を指定することで選択された値の表示をカスタマイズすることが可能です。
///
/// [onEdit]を指定することで選択肢の編集時に実行されるコールバックを設定することが可能です。
class FormMapTagDropdownFieldPicker {
  /// Class that defines a picker style to select from [Map] for tags.
  ///
  /// Pass `Map<String, String>` to [data].
  /// Key in [Map] is the ID for selection and Value is the display label for selection.
  ///
  /// The display of selected values can be customized by specifying [chipBuilder].
  ///
  /// By specifying [onEdit], it is possible to set up a callback to be executed when editing choices.
  ///
  /// タグ用の[Map]から選択するためのピッカースタイルを定義するクラス。
  ///
  /// `Map<String, String>`を[data]に渡します。
  /// [Map]のKeyが選択用のID、Valueが選択用の表示ラベルになります。
  ///
  /// [chipBuilder]を指定することで選択された値の表示をカスタマイズすることが可能です。
  ///
  /// [onEdit]を指定することで選択肢の編集時に実行されるコールバックを設定することが可能です。
  FormMapTagDropdownFieldPicker({
    required this.data,
    this.backgroundColor,
    this.color,
    this.chipBuilder,
    this.onEdit,
    this.onDelete,
    this.onAdd,
    this.tilePadding,
    this.width,
  });

  /// Callback to be executed when adding choices.
  ///
  /// [data] is passed to the callback.
  ///
  /// 選択肢の追加時に実行されるコールバック。
  ///
  /// コールバックに[data]が渡されます。
  final void Function(MapEntry<String, String> data)? onAdd;

  /// Callback to be executed when editing choices.
  ///
  /// [data] is passed to the callback.
  ///
  /// 選択肢の編集時に実行されるコールバック。
  ///
  /// コールバックに[data]が渡されます。
  final void Function(MapEntry<String, String> data)? onEdit;

  /// Callback to be executed when deleting choices.
  ///
  /// [key] is passed to the callback.
  ///
  /// 選択肢の削除時に実行されるコールバック。
  ///
  /// コールバックに[key]が渡されます。
  final void Function(String key)? onDelete;

  /// Customize the display of selected values.
  ///
  /// [context] is passed [BuildContext] and [value] is passed the selected value.
  ///
  /// 選択された値の表示をカスタマイズします。
  ///
  /// [context]に[BuildContext]が渡され、[value]に選択された値が渡されます。
  final Widget Function(BuildContext context, String value)? chipBuilder;

  /// Data for options.
  ///
  /// Key in [Map] is the ID for selection and Value is the display label for selection.
  ///
  /// 選択肢用のデータ。
  ///
  /// [Map]のKeyが選択用のID、Valueが選択用の表示ラベルになります。
  final Map<String, String> data;

  /// Background color of the picker.
  ///
  /// ピッカーの背景色。
  final Color? backgroundColor;

  /// Foreground view of the picker.
  ///
  /// ピッカーの前景色。
  final Color? color;

  /// Padding for each tile.
  ///
  /// タイルごとのパディング。
  final EdgeInsetsGeometry? tilePadding;

  /// Tile width.
  ///
  /// タイルの幅。
  final double? width;

  /// Displays the selected value.
  ///
  /// [BuildContext] is passed to [context]. The current choices, the values selected from [ref] and the methods used to perform the operations are passed to [data].
  ///
  /// 選択された値の表示を行います。
  ///
  /// [context]に[BuildContext]が渡されます。[data]には現在の選択肢、[ref]から選択された値や操作を行うためのメソッドが渡されます。
  Widget buildChips(
    BuildContext context,
    Map<String, String> data,
    FormMapTagDropdownFieldRef<List<String>> ref,
  ) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...ref.value?.map((key) {
                return chipBuilder?.call(context, data[key] ?? "") ??
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        color:
                            WidgetStatePropertyAll(theme.colorScheme.primary),
                        label: Text(
                          data[key] ?? "",
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                        ),
                      ),
                    );
              }) ??
              [],
        ],
      ),
    );
  }

  /// Build the picker.
  ///
  /// [BuildContext] is passed to [context]. The current suggestion data is passed to [data], the selected value from [ref] and the method to perform the operation.
  ///
  /// ピッカーのビルドを行ないます。
  ///
  /// [context]に[BuildContext]が渡されます。[data]に現在のサジェストデータ、[ref]から選択された値や操作を行うためのメソッドが渡されます。
  List<Widget> buildPicker(
    BuildContext context,
    Map<String, String> data,
    FormMapTagDropdownFieldRef<List<String>> ref,
  ) {
    final keys = data.keys.toList();
    return [
      ...keys.map((key) {
        return _EditableListTile(
          tilePadding: tilePadding,
          key: ValueKey(key),
          value: key,
          name: data[key] ?? "",
          selected: ref.value?.contains(key) == true,
          onEdit: (value) {
            ref.edit(key, value);
          },
          onDelete: () {
            ref.delete(key);
          },
          onSelect: () {
            if (ref.value?.contains(key) == true) {
              ref.unselect(key);
            } else {
              ref.select(key);
            }
          },
        );
      }),
      _AddibleListTile(
        tilePadding: tilePadding,
        onAdd: (value) {
          ref.add(value);
        },
      ),
    ];
  }
}

class _EditableListTile extends StatefulWidget {
  const _EditableListTile({
    super.key,
    required this.value,
    required this.name,
    this.onEdit,
    this.onDelete,
    this.onSelect,
    this.selected = false,
    this.tilePadding,
  });

  final String value;
  final String name;
  final void Function(String name)? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final EdgeInsetsGeometry? tilePadding;
  final bool selected;

  @override
  State<StatefulWidget> createState() => _EditableListTileState();
}

class _EditableListTileState extends State<_EditableListTile> {
  bool _editable = false;
  late FocusNode _focusNode;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_EditableListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      _controller?.text = widget.name;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _submit();
    }
  }

  void _edit() {
    if (_editable) {
      return;
    }
    _focusNode.requestFocus();
    setState(() {
      _editable = true;
    });
  }

  void _submit() {
    if (!_editable) {
      return;
    }
    widget.onEdit?.call(_controller?.text ?? "");
    setState(() {
      _editable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: widget.tilePadding,
      title: _editable
          ? TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            )
          : Text(widget.name),
      leading: Checkbox(
        key: ValueKey("${widget.key.toString()}_check"),
        value: widget.selected,
        onChanged: (value) {
          widget.onSelect?.call();
          FocusScope.of(context).unfocus();
        },
      ),
      onTap: () {},
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_editable) ...[
            IconButton(
              key: ValueKey("${widget.key.toString()}_submit"),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                _submit();
                FocusScope.of(context).unfocus();
              },
            ),
          ] else ...[
            IconButton(
              key: ValueKey("${widget.key.toString()}_edit"),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.edit),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _edit();
              },
            ),
            IconButton(
              key: ValueKey("${widget.key.toString()}_delete"),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete),
              onPressed: () {
                widget.onDelete?.call();
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _AddibleListTile extends StatefulWidget {
  const _AddibleListTile({
    this.onAdd,
    this.tilePadding,
  });

  final void Function(String name)? onAdd;
  final EdgeInsetsGeometry? tilePadding;

  @override
  State<StatefulWidget> createState() => _AddibleListTileState();
}

class _AddibleListTileState extends State<_AddibleListTile> {
  bool _editable = false;
  late FocusNode _focusNode;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "");
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _submit();
    }
  }

  void _edit() {
    if (_editable) {
      return;
    }
    _focusNode.requestFocus();
    setState(() {
      _editable = true;
    });
  }

  void _submit() {
    if (!_editable) {
      return;
    }
    widget.onAdd?.call(_controller?.text ?? "");
    setState(() {
      _editable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: widget.tilePadding,
      title: _editable
          ? TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            )
          : const SizedBox(),
      leading: const SizedBox(width: 48),
      onTap: () {
        print("aaa");
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_editable) ...[
            IconButton(
              key: ValueKey("_submit"),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _submit();
              },
            ),
          ] else ...[
            IconButton(
              key: ValueKey("_edit"),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _edit();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectBoxController {
  _SelectBoxController(this.context);
  final BuildContext context;

  OverlayEntry? overlayEntry;

  bool _isOpened = false;

  bool get isOpened => _isOpened;

  void open() {
    if (_isOpened) {
      return;
    }
    assert(overlayEntry != null);
    Overlay.of(context).insert(overlayEntry!);
    _isOpened = true;
  }

  void close() {
    if (!_isOpened) {
      return;
    }
    assert(overlayEntry != null);
    overlayEntry!.remove();
    _isOpened = false;
  }

  void toggle() {
    if (_isOpened) {
      close();
    } else {
      open();
    }
  }
}
