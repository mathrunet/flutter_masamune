part of katana_form;

const _kObjectReplacementChar = 0xFFFD;

typedef ChipBuilder<T> = Widget Function(
  BuildContext context,
  ChipsInputController<T> state,
  T data,
);

class FormChipsField<TValue> extends FormField<List<String>> {
  FormChipsField({
    Key? key,
    this.form,
    this.style,
    bool enabled = true,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    required this.chipBuilder,
    this.suggestionBuilder,
    this.suggestion = const [],
    this.onChanged,
    this.onChipTapped,
    this.maxChips,
    this.emptyErrorText,
    this.focusNode,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.autocorrect = false,
    this.suggestionStyle,
    this.keepAlive = true,
    TValue Function(List<String> value)? onSaved,
    String Function(List<String>? value)? validator,
    List<String> initialValue = const [],
  }) : super(
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

  final ChipBuilder<String> chipBuilder;
  final ChipBuilder<String>? suggestionBuilder;
  final List<String> suggestion;
  final void Function(String value)? onChipTapped;
  final TextInputType inputType;
  final int? maxChips;
  final bool obscureText;
  final bool autocorrect;
  final String? hintText;
  final String? labelText;
  final bool readOnly;

  /// Window style for suggestions.
  ///
  /// サジェスト用のウインドウのスタイル。
  final SuggestionStyle? suggestionStyle;

  /// Specifies the focus node.
  ///
  /// The focus node makes it possible to control the focus of the form.
  ///
  /// フォーカスノードを指定します。
  ///
  /// フォーカスノードを利用してフォームのフォーカスをコントロールすることが可能になります。
  final FocusNode? focusNode;

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

  @override
  FormFieldState<List<String>> createState() => _FormChipsField<TValue>();
}

class _FormChipsField<TValue> extends FormFieldState<List<String>> {
  final FocusNode _focusNode = FocusNode();

  @override
  FormChipsField<TValue> get widget => super.widget as FormChipsField<TValue>;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(FormChipsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_handleFocus);
  }

  void _handleFocus() {
    if (!_focusNode.hasFocus) {
      return;
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

    final suggestionStyle = widget.suggestionStyle ?? const SuggestionStyle();

    return Padding(
      padding: widget.style?.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        alignment: Alignment.centerLeft,
        constraints: const BoxConstraints(minHeight: 32),
        child: ChipTheme(
          data: ChipThemeData(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              side: BorderSide.none,
            ),
            side: BorderSide.none,
            backgroundColor: widget.style?.activeBackgroundColor ??
                Theme.of(context).colorScheme.primary,
            disabledColor:
                widget.style?.disabledColor ?? Theme.of(context).disabledColor,
            labelStyle: mainTextStyle.copyWith(
              color: widget.style?.activeColor ??
                  Theme.of(context).colorScheme.onPrimary,
            ),
            secondaryLabelStyle: subTextStyle.copyWith(
              color: widget.style?.activeColor ??
                  Theme.of(context).colorScheme.onPrimary,
            ),
            deleteIconColor: widget.style?.activeColor ??
                Theme.of(context).colorScheme.onPrimary,
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.text,
            child: _ChipsInput<String>(
              initialValue: value ?? [],
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
              // style: mainTextStyle,
              // textAlign: widget.style?.textAlign ?? TextAlign.left,
              // textAlignVertical: widget.style?.textAlignVertical,
              obscureText: widget.obscureText,
              enabled: widget.enabled,
              chipBuilder: (context, state, value) {
                if (value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return widget.chipBuilder.call(context, state, value);
              },
              suggestionBuilder: (context, state, value) {
                return widget.suggestionBuilder?.call(context, state, value) ??
                    const SizedBox.shrink();
              },
              findSuggestions: (value, chips) async {
                final items = value.isNotEmpty ? [value] : <String>[];
                for (var element in chips) {
                  items.add(element);
                }
                items.addAll(
                  widget.suggestion.where((element) => element.contains(value)),
                );
                return items;
              },
              onChanged: (values) {
                setValue(values);
                widget.onChanged?.call(values);
              },
              focusNode: _focusNode,
              onChipTapped: widget.onChipTapped,
              maxChips: widget.maxChips,
              suggestionsBoxMaxHeight: suggestionStyle.maxHeight,
              autocorrect: widget.autocorrect,
              suggestionMargin: EdgeInsets.zero,
              suggestionPadding: EdgeInsets.zero,
              suggestionColor: suggestionStyle.color ??
                  Theme.of(context).colorScheme.onSurface,
              suggestionBackgroundColor: suggestionStyle.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipsInput<T> extends StatefulWidget {
  const _ChipsInput({
    Key? key,
    this.initialValue = const [],
    this.decoration = const InputDecoration(),
    this.enabled = true,
    required this.chipBuilder,
    required this.suggestionBuilder,
    required this.findSuggestions,
    required this.onChanged,
    this.suggestionBackgroundColor,
    this.suggestionColor,
    this.suggestionPadding = const EdgeInsets.all(0),
    this.suggestionMargin = const EdgeInsets.all(0),
    this.maxChips,
    this.textStyle,
    this.suggestionsBoxMaxHeight,
    this.inputType = TextInputType.text,
    this.textOverflow = TextOverflow.clip,
    this.obscureText = false,
    this.autocorrect = true,
    this.actionLabel,
    this.inputAction = TextInputAction.done,
    this.keyboardAppearance = Brightness.light,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.allowChipEditing = false,
    this.focusNode,
    this.initialSuggestions,
    this.onChipTapped,
  })  : assert(maxChips == null || initialValue.length <= maxChips),
        super(key: key);

  final InputDecoration decoration;
  final TextStyle? textStyle;
  final bool enabled;
  final FutureOr<List<T>> Function(
    String query,
    Set<T> chips,
  ) findSuggestions;
  final ValueChanged<List<T>> onChanged;
  final ChipBuilder<T> chipBuilder;
  final ChipBuilder<T> suggestionBuilder;
  final List<T> initialValue;
  final int? maxChips;
  final double? suggestionsBoxMaxHeight;
  final TextInputType inputType;
  final TextOverflow textOverflow;
  final bool obscureText;
  final bool autocorrect;
  final String? actionLabel;
  final TextInputAction inputAction;
  final Brightness keyboardAppearance;
  final bool autofocus;
  final bool allowChipEditing;
  final FocusNode? focusNode;
  final List<T>? initialSuggestions;
  final void Function(T value)? onChipTapped;
  final EdgeInsetsGeometry suggestionPadding;
  final EdgeInsetsGeometry suggestionMargin;
  final Color? suggestionBackgroundColor;
  final Color? suggestionColor;

  final TextCapitalization textCapitalization;

  @override
  _ChipsInputState<T> createState() => _ChipsInputState<T>();
}

abstract class ChipsInputController<T> {
  void requestKeyboard();

  void selectSuggestion(T data);

  void deleteChip(T data);
}

class _ChipsInputState<T> extends State<_ChipsInput<T>>
    implements TextInputClient, ChipsInputController<T> {
  Set<T> _chips = <T>{};
  List<T?>? _suggestions;
  final StreamController<List<T?>?> _suggestionsStreamController =
      StreamController<List<T>?>.broadcast();
  int _searchId = 0;
  TextEditingValue _value = const TextEditingValue();
  TextInputConnection? _textInputConnection;
  late _SuggestionsBoxController _suggestionsBoxController;
  final _layerLink = LayerLink();
  final Map<T?, String> _enteredTexts = <T, String>{};

  TextInputConfiguration get _textInputConfiguration => TextInputConfiguration(
        inputType: widget.inputType,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        actionLabel: widget.actionLabel,
        inputAction: widget.inputAction,
        keyboardAppearance: widget.keyboardAppearance,
        textCapitalization: widget.textCapitalization,
      );

  bool get _hasInputConnection =>
      _textInputConnection != null && _textInputConnection!.attached;

  bool get _hasReachedMaxChips =>
      widget.maxChips != null && _chips.length >= widget.maxChips!;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());
  late FocusAttachment _nodeAttachment;

  RenderBox? get _renderBox => context.findRenderObject() as RenderBox?;

  bool get _canRequestFocus => widget.enabled;

  @override
  void requestKeyboard() {
    if (_effectiveFocusNode.hasFocus) {
      _openInputConnection();
    } else {
      FocusScope.of(context).requestFocus(_effectiveFocusNode);
    }
  }

  @override
  void selectSuggestion(T data) {
    if (!_hasReachedMaxChips) {
      setState(() => _chips = _chips..add(data));
      if (widget.allowChipEditing) {
        final enteredText = _value.normalCharactersText;
        if (enteredText.isNotEmpty) {
          _enteredTexts[data] = enteredText;
        }
      }
      _updateTextInputState(replaceText: true);
      setState(() => _suggestions = null);
      _suggestionsStreamController.add(_suggestions);
      if (_hasReachedMaxChips) {
        _suggestionsBoxController.close();
      }
      widget.onChanged(_chips.toList(growable: false));
    } else {
      _suggestionsBoxController.close();
    }
  }

  @override
  void deleteChip(T data) {
    if (widget.enabled) {
      setState(() => _chips.remove(data));
      if (_enteredTexts.containsKey(data)) {
        _enteredTexts.remove(data);
      }
      _updateTextInputState();
      widget.onChanged(_chips.toList(growable: false));
    }
  }

  @override
  void initState() {
    super.initState();
    _chips.addAll(widget.initialValue);
    _suggestions = widget.initialSuggestions
        ?.where((r) => !_chips.contains(r))
        .toList(growable: false);
    _suggestionsBoxController = _SuggestionsBoxController(context);

    _effectiveFocusNode.addListener(_handleFocusChanged);
    _nodeAttachment = _effectiveFocusNode.attach(context);
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;

    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      _initOverlayEntry();
      if (mounted && widget.autofocus) {
        FocusScope.of(context).autofocus(_effectiveFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _closeInputConnectionIfNeeded();
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _suggestionsStreamController.close();
    _suggestionsBoxController.close();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (_effectiveFocusNode.hasFocus) {
      _openInputConnection();
      _suggestionsBoxController.open();
    } else {
      _closeInputConnectionIfNeeded();
      _suggestionsBoxController.close();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _initOverlayEntry() {
    _suggestionsBoxController.overlayEntry = OverlayEntry(
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
        if (null != widget.suggestionsBoxMaxHeight) {
          suggestionBoxHeight =
              min(suggestionBoxHeight, widget.suggestionsBoxMaxHeight!);
        }
        final showTop = topAvailableSpace > bottomAvailableSpace;
        final compositedTransformFollowerOffset =
            showTop ? Offset(0, -size.height) : Offset.zero;

        return StreamBuilder<List<T?>?>(
          stream: _suggestionsStreamController.stream,
          initialData: _suggestions,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final suggestionsListView = Material(
                elevation: 0,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.suggestionColor ??
                        Theme.of(context).colorScheme.onSurface,
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.suggestionColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
                    child: Container(
                      margin: widget.suggestionMargin,
                      padding: widget.suggestionPadding,
                      color: widget.suggestionBackgroundColor ??
                          Theme.of(context).colorScheme.surface,
                      constraints: BoxConstraints(
                        maxHeight: suggestionBoxHeight,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final suggestion = _suggestions?[index];
                          return suggestion != null
                              ? widget.suggestionBuilder(
                                  context,
                                  this,
                                  suggestion,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              );
              return Positioned(
                width: size.width,
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
            return Container();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    final chipsChildren = _chips.map<Widget>((data) {
      return InkWell(
        onTap: widget.onChipTapped != null
            ? () {
                widget.onChipTapped?.call(data);
              }
            : null,
        child: widget.chipBuilder(context, this, data),
      );
    }).toList();

    final theme = Theme.of(context);

    chipsChildren.add(
      SizedBox(
        height: 30,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text(
                _value.normalCharactersText,
                maxLines: 1,
                overflow: widget.textOverflow,
                style: widget.textStyle ??
                    theme.textTheme.titleMedium!.copyWith(height: 1.5),
              ),
            ),
            Flexible(
              flex: 0,
              child: _TextCursor(resumed: _effectiveFocusNode.hasFocus),
            ),
          ],
        ),
      ),
    );

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (SizeChangedLayoutNotification val) {
        WidgetsBinding.instance.scheduleFrameCallback((_) async {
          _suggestionsBoxController.overlayEntry?.markNeedsBuild();
        });
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Column(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                requestKeyboard();
              },
              child: InputDecorator(
                decoration: widget.decoration,
                isFocused: _effectiveFocusNode.hasFocus,
                isEmpty: _value.text.isEmpty && _chips.isEmpty,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: chipsChildren,
                ),
              ),
            ),
            CompositedTransformTarget(
              link: _layerLink,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    final oldTextEditingValue = _value;
    if (value.text != oldTextEditingValue.text) {
      setState(() {
        _value = value;
      });
      if (value.replacementCharactersCount <
          oldTextEditingValue.replacementCharactersCount) {
        final removedChip = _chips.last;
        _chips = Set.of(_chips.take(value.replacementCharactersCount));
        widget.onChanged(
          _chips.toList(growable: false)..removeEmpty(),
        );
        var putText = '';
        if (widget.allowChipEditing && _enteredTexts.containsKey(removedChip)) {
          putText = _enteredTexts[removedChip]!;
          _enteredTexts.remove(removedChip);
        }
        _updateTextInputState(putText: putText);
      } else {
        _updateTextInputState();
      }
      _onSearchChanged(_value.normalCharactersText);
    }
  }

  @override
  void performAction(TextInputAction action) {
    switch (action) {
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.send:
      case TextInputAction.search:
        final suggestion = _suggestions.firstOrNull;
        if (suggestion != null) {
          selectSuggestion(suggestion);
        } else {
          _effectiveFocusNode.unfocus();
        }
        break;
      default:
        _effectiveFocusNode.unfocus();
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void didUpdateWidget(covariant _ChipsInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}

  @override
  void connectionClosed() {}

  @override
  TextEditingValue get currentTextEditingValue => _value;

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  void insertTextPlaceholder(Size size) {}

  @override
  void removeTextPlaceholder() {}

  @override
  void showToolbar() {}

  @override
  void didChangeInputControl(
      TextInputControl? oldControl, TextInputControl? newControl) {}

  @override
  void performSelector(String selectorName) {}

  void _updateTextInputState({replaceText = false, putText = ''}) {
    if (replaceText || putText != '') {
      final updatedText =
          String.fromCharCodes(_chips.map((_) => _kObjectReplacementChar)) +
              (replaceText ? '' : _value.normalCharactersText) +
              putText;
      setState(() {
        final textLength = updatedText.characters.length;
        final replacedLength = _chips.length;
        _value = _value.copyWith(
          text: updatedText,
          selection: TextSelection.collapsed(offset: textLength),
          composing: (UniversalPlatform.isIOS || replacedLength == textLength)
              ? TextRange.empty
              : TextRange(
                  start: replacedLength,
                  end: textLength,
                ),
        );
      });
      if (UniversalPlatform.isIOS) {
        _textInputConnection ??=
            TextInput.attach(this, _textInputConfiguration);
        _textInputConnection?.setEditingState(_value);
      }
    }
    if (!UniversalPlatform.isIOS) {
      _textInputConnection ??= TextInput.attach(this, _textInputConfiguration);
      _textInputConnection?.setEditingState(_value);
    }
  }

  void _openInputConnection() {
    if (!_hasInputConnection) {
      _textInputConnection = TextInput.attach(this, _textInputConfiguration);
      _textInputConnection!.show();
      _updateTextInputState();
    } else {
      _textInputConnection?.show();
    }

    _scrollToVisible();
  }

  void _scrollToVisible() {
    Future.delayed(const Duration(milliseconds: 300), () {
      WidgetsBinding.instance.scheduleFrameCallback((_) async {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          await Scrollable.of(context).position.ensureVisible(renderBox);
        }
      });
    });
  }

  Future<void> _onSearchChanged(String value) async {
    final localId = ++_searchId;
    final results = await widget.findSuggestions(value, _chips);
    if (_searchId == localId && mounted) {
      setState(
        () => _suggestions =
            results.where((r) => !_chips.contains(r)).toList(growable: false),
      );
    }
    _suggestionsStreamController.add(_suggestions ?? []);
    if (!_suggestionsBoxController.isOpened && !_hasReachedMaxChips) {
      _suggestionsBoxController.open();
    }
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection!.close();
      _textInputConnection = null;
    }
  }
}

class _SuggestionsBoxController {
  _SuggestionsBoxController(this.context);
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

extension _TextEditingValueExtensions on TextEditingValue {
  String get normalCharactersText => String.fromCharCodes(
        text.codeUnits.where((ch) => ch != _kObjectReplacementChar),
      );

  List<int> get replacementCharacters => text.codeUnits
      .where((ch) => ch == _kObjectReplacementChar)
      .toList(growable: false);

  int get replacementCharactersCount => replacementCharacters.length;
}

class _TextCursor extends StatefulWidget {
  const _TextCursor({
    Key? key,
    this.resumed = false,
  }) : super(key: key);

  final bool resumed;

  @override
  _TextCursorState createState() => _TextCursorState();
}

class _TextCursorState extends State<_TextCursor>
    with SingleTickerProviderStateMixin {
  bool _displayed = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), _onTimer);
  }

  void _onTimer(Timer timer) {
    setState(() => _displayed = !_displayed);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Opacity(
        opacity: _displayed && widget.resumed ? 1.0 : 0.0,
        child: Container(
          width: 2.0,
          color: theme.textSelectionTheme.cursorColor ??
              theme.textSelectionTheme.selectionColor ??
              theme.primaryColor,
        ),
      ),
    );
  }
}
