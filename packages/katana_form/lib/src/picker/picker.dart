// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, unused_element_parameter

part of '/katana_form.dart';

typedef _PickerSelectedCallback = void Function(
    _Picker picker, int index, List<int> selected);

typedef _PickerConfirmCallback = void Function(
    _Picker picker, List<int> selected);

typedef _PickerConfirmBeforeCallback = Future<bool> Function(
    _Picker picker, List<int> selected);

typedef _PickerValueFormat<T> = String Function(T value);

typedef _PickerWidgetBuilder = Widget Function(
    BuildContext context, Widget pickerWidget);

typedef PickerItemBuilder = Widget? Function(BuildContext context, String? text,
    Widget? child, bool selected, int col, int index);

class _Picker {
  static const double kDefaultTextSize = 18.0;

  late List<int> selecteds;

  late _PickerAdapter adapter;

  final List<_PickerDelimiter>? delimiter;

  final VoidCallback? onCancel;
  final _PickerSelectedCallback? onSelect;
  final _PickerConfirmCallback? onConfirm;
  final _PickerConfirmBeforeCallback? onConfirmBefore;

  // ignore: prefer_typing_uninitialized_variables
  final changeToFirst;

  final List<int>? columnFlex;

  final Widget? title;
  final Widget? cancel;
  final Widget? confirm;
  final String? cancelText;
  final String? confirmText;

  final double height;

  final double itemExtent;

  final TextStyle? textStyle,
      cancelTextStyle,
      confirmTextStyle,
      selectedTextStyle;
  final TextAlign textAlign;
  final IconThemeData? selectedIconTheme;

  final double? textScaleFactor;

  final EdgeInsetsGeometry? columnPadding;
  final Color? backgroundColor, headerColor, containerColor;

  final bool hideHeader;

  final bool reversedOrder;

  final WidgetBuilder? builderHeader;

  final PickerItemBuilder? onBuilderItem;

  final bool looping;

  final int smooth;

  final Widget? footer;

  final Widget selectionOverlay;

  final Decoration? headerDecoration;

  final double magnification;
  final double diameterRatio;
  final double squeeze;

  final bool printDebug;

  Widget? _widget;
  _InternalPickerWidgetState? _state;

  _Picker(
      {required this.adapter,
      this.delimiter,
      List<int>? selecteds,
      this.height = 150.0,
      this.itemExtent = 28.0,
      this.columnPadding,
      this.textStyle,
      this.cancelTextStyle,
      this.confirmTextStyle,
      this.selectedTextStyle,
      this.selectedIconTheme,
      this.textAlign = TextAlign.start,
      this.textScaleFactor,
      this.title,
      this.cancel,
      this.confirm,
      this.cancelText,
      this.confirmText,
      this.backgroundColor,
      this.containerColor,
      this.headerColor,
      this.builderHeader,
      this.changeToFirst = false,
      this.hideHeader = false,
      this.looping = false,
      this.reversedOrder = false,
      this.headerDecoration,
      this.columnFlex,
      this.footer,
      this.smooth = 0,
      this.magnification = 1.0,
      this.diameterRatio = 1.1,
      this.squeeze = 1.45,
      this.selectionOverlay = const CupertinoPickerDefaultSelectionOverlay(),
      this.onBuilderItem,
      this.onCancel,
      this.onSelect,
      this.onConfirmBefore,
      this.onConfirm,
      this.printDebug = false}) {
    this.selecteds = selecteds ?? <int>[];
  }

  Widget? get widget => _widget;
  // ignore: library_private_types_in_public_api
  _InternalPickerWidgetState? get state => _state;
  int _maxLevel = 1;

  Widget makePicker([ThemeData? themeData, bool isModal = false, Key? key]) {
    _maxLevel = adapter.maxLevel;
    adapter.picker = this;
    adapter.initSelects();
    _widget = _PickerWidget(
      key: key ?? ValueKey(this),
      data: this,
      child: _InternalPickerWidget(
          picker: this, themeData: themeData, isModal: isModal),
    );
    return _widget!;
  }

  void show(
    ScaffoldState state, {
    ThemeData? themeData,
    Color? backgroundColor,
    _PickerWidgetBuilder? builder,
  }) {
    state.showBottomSheet((BuildContext context) {
      final picker = makePicker(themeData);
      return builder == null ? picker : builder(context, picker);
    }, backgroundColor: backgroundColor);
  }

  void showBottomSheet(
    BuildContext context, {
    ThemeData? themeData,
    Color? backgroundColor,
    _PickerWidgetBuilder? builder,
  }) {
    Scaffold.of(context).showBottomSheet((BuildContext context) {
      final picker = makePicker(themeData);
      return builder == null ? picker : builder(context, picker);
    }, backgroundColor: backgroundColor);
  }

  Future<T?> showModal<T>(BuildContext context,
      {ThemeData? themeData,
      bool isScrollControlled = false,
      bool useRootNavigator = false,
      Color? backgroundColor,
      _PickerWidgetBuilder? builder}) async {
    return await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        backgroundColor: backgroundColor,
        builder: (BuildContext context) {
          final picker = makePicker(themeData, true);
          return builder == null ? picker : builder(context, picker);
        });
  }

  Future<List<int>?> showDialog(BuildContext context,
      {bool barrierDismissible = true,
      Color? backgroundColor,
      _PickerWidgetBuilder? builder,
      Key? key}) {
    return material.showDialog<List<int>>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          final actions = <Widget>[];
          final theme = Theme.of(context);
          final _cancel = _InternalPickerWidgetState._buildButton(
              context, cancelText, cancel, cancelTextStyle, true, theme, () {
            Navigator.pop<List<int>>(context, null);
            if (onCancel != null) {
              onCancel!();
            }
          });
          if (_cancel != null) {
            actions.add(_cancel);
          }
          final _confirm = _InternalPickerWidgetState._buildButton(
              context, confirmText, confirm, confirmTextStyle, false, theme,
              () async {
            if (onConfirmBefore != null &&
                !(await onConfirmBefore!(this, selecteds))) {
              return;
            }
            Navigator.pop<List<int>>(context, selecteds);
            if (onConfirm != null) {
              onConfirm!(this, selecteds);
            }
          });
          if (_confirm != null) {
            actions.add(_confirm);
          }
          return AlertDialog(
            key: key ?? const Key("picker-dialog"),
            title: title,
            backgroundColor: backgroundColor,
            actions: actions,
            content: builder == null
                ? makePicker(theme)
                : builder(context, makePicker(theme)),
          );
        });
  }

  List getSelectedValues() {
    return adapter.getSelectedValues();
  }

  void doCancel(BuildContext context) {
    Navigator.of(context).pop<List<int>>(null);
    if (onCancel != null) onCancel!();
    _widget = null;
  }

  void doConfirm(BuildContext context) async {
    if (onConfirmBefore != null && !(await onConfirmBefore!(this, selecteds))) {
      return;
    }
    Navigator.of(context).pop<List<int>>(selecteds);
    if (onConfirm != null) onConfirm!(this, selecteds);
    _widget = null;
  }

  void updateColumn(int index, [bool all = false]) {
    if (all) {
      _state?.update();
      return;
    }
    if (_state?._keys[index] != null) {
      adapter.setColumn(index - 1);
      _state?._keys[index]!(() {});
    }
  }

  static ButtonStyle _getButtonStyle(ButtonThemeData? theme,
          [isCancelButton = false]) =>
      TextButton.styleFrom(
          minimumSize: Size(theme?.minWidth ?? 0.0, 42),
          textStyle: TextStyle(
            fontSize: _Picker.kDefaultTextSize,
            color: isCancelButton ? null : theme?.colorScheme?.secondary,
          ),
          padding: theme?.padding);
}

class _PickerDelimiter {
  final Widget? child;
  final int column;
  _PickerDelimiter({required this.child, this.column = 1});
}

class _PickerItem<T> {
  final Widget? text;

  final T? value;

  final List<_PickerItem<T>>? children;

  _PickerItem({this.text, this.value, this.children});
}

class _PickerWidget<T> extends InheritedWidget {
  final _Picker data;
  const _PickerWidget({super.key, required this.data, required super.child});
  @override
  bool updateShouldNotify(covariant _PickerWidget oldWidget) =>
      oldWidget.data != data;

  static _PickerWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PickerWidget>()
        as _PickerWidget;
  }
}

class _InternalPickerWidget<T> extends StatefulWidget {
  final _Picker picker;
  final ThemeData? themeData;
  final bool isModal;
  const _InternalPickerWidget(
      {super.key, required this.picker, this.themeData, required this.isModal});

  @override
  _InternalPickerWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _InternalPickerWidgetState<T>(
          picker: this.picker, themeData: this.themeData);
}

class _InternalPickerWidgetState<T> extends State<_InternalPickerWidget> {
  final _Picker picker;
  final ThemeData? themeData;
  _InternalPickerWidgetState({required this.picker, this.themeData});

  ThemeData? theme;
  final List<FixedExtentScrollController> scrollController = [];
  final List<StateSetter?> _keys = [];

  @override
  void initState() {
    super.initState();
    picker._state = this;
    picker.adapter.doShow();

    if (scrollController.isEmpty) {
      for (int i = 0; i < picker._maxLevel; i++) {
        scrollController
            .add(FixedExtentScrollController(initialItem: picker.selecteds[i]));
        _keys.add(null);
      }
    }
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    theme = themeData ?? Theme.of(context);

    if (_wait && picker.smooth > 0) {
      Future.delayed(Duration(milliseconds: picker.smooth), () {
        if (!_wait) return;
        setState(() {
          _wait = false;
        });
      });
    } else {
      _wait = false;
    }

    final _body = <Widget>[];
    if (!picker.hideHeader) {
      if (picker.builderHeader != null) {
        _body.add(picker.headerDecoration == null
            ? picker.builderHeader!(context)
            : DecoratedBox(
                decoration: picker.headerDecoration!,
                child: picker.builderHeader!(context)));
      } else {
        _body.add(DecoratedBox(
          decoration: picker.headerDecoration ??
              BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme!.dividerColor, width: 0.5),
                  bottom: BorderSide(color: theme!.dividerColor, width: 0.5),
                ),
                color: picker.headerColor ?? theme?.bottomAppBarTheme.color,
              ),
          child: Row(
            children: _buildHeaderViews(context),
          ),
        ));
      }
    }

    _body.add(_wait
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildViews(),
          )
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildViews(),
            ),
          ));

    if (picker.footer != null) _body.add(picker.footer!);
    Widget v = Column(
      mainAxisSize: MainAxisSize.min,
      children: _body,
    );
    if (widget.isModal) {
      return GestureDetector(
        onTap: () {},
        child: v,
      );
    }
    return v;
  }

  List<Widget>? _headerItems;

  List<Widget> _buildHeaderViews(BuildContext context) {
    if (_headerItems != null) {
      return _headerItems!;
    }
    theme ??= Theme.of(context);
    List<Widget> items = [];

    final _cancel = _buildButton(context, picker.cancelText, picker.cancel,
        picker.cancelTextStyle, true, theme, () => picker.doCancel(context));
    if (_cancel != null) {
      items.add(_cancel);
    }

    items.add(Expanded(
      child: picker.title == null
          ? const SizedBox()
          : DefaultTextStyle(
              style: theme!.textTheme.titleLarge?.copyWith(
                    fontSize: _Picker.kDefaultTextSize,
                  ) ??
                  const TextStyle(fontSize: _Picker.kDefaultTextSize),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              child: picker.title!),
    ));

    final _confirm = _buildButton(context, picker.confirmText, picker.confirm,
        picker.confirmTextStyle, false, theme, () => picker.doConfirm(context));
    if (_confirm != null) {
      items.add(_confirm);
    }

    _headerItems = items;
    return items;
  }

  static Widget? _buildButton(
      BuildContext context,
      String? text,
      Widget? widget,
      TextStyle? textStyle,
      bool isCancel,
      ThemeData? theme,
      VoidCallback? onPressed) {
    if (widget == null) {
      String? _txt = text ??
          (isCancel
              ? _PickerLocalizations.of(context).cancelText
              : _PickerLocalizations.of(context).confirmText);
      if (_txt == null || _txt.isEmpty) {
        return null;
      }
      return TextButton(
          style: _Picker._getButtonStyle(ButtonTheme.of(context), isCancel),
          onPressed: onPressed,
          child: Text(_txt, overflow: TextOverflow.ellipsis, style: textStyle));
    } else {
      return textStyle == null
          ? widget
          : DefaultTextStyle(style: textStyle, child: widget);
    }
  }

  bool _changing = false;
  bool _wait = true;
  final Map<int, int> lastData = {};

  List<Widget> _buildViews() {
    if (picker.printDebug) {
      debugPrint("_buildViews");
    }
    theme ??= Theme.of(context);
    for (int j = 0; j < _keys.length; j++) {
      _keys[j] = null;
    }

    List<Widget> items = [];
    _PickerAdapter? adapter = picker.adapter;
    adapter.setColumn(-1);

    final _decoration = BoxDecoration(
      color: picker.containerColor ?? theme!.dialogTheme.backgroundColor,
    );

    if (adapter.length > 0) {
      for (int i = 0; i < picker._maxLevel; i++) {
        Widget view = Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            padding: picker.columnPadding,
            height: picker.height,
            decoration: _decoration,
            child: _wait
                ? null
                : StatefulBuilder(
                    builder: (context, state) {
                      _keys[i] = state;
                      adapter.setColumn(i - 1);
                      if (picker.printDebug) {
                        debugPrint("builder. col: $i");
                      }

                      final _lastIsEmpty = scrollController[i].hasClients &&
                          !scrollController[i].position.hasContentDimensions;

                      final _length = adapter.length;
                      final _view = _buildCupertinoPicker(context, i, _length,
                          adapter, _lastIsEmpty ? ValueKey(_length) : null);

                      if (_lastIsEmpty ||
                          (!picker.changeToFirst &&
                              picker.selecteds[i] >= _length)) {
                        Timer(const Duration(milliseconds: 100), () {
                          if (!mounted) {
                            return;
                          }
                          if (picker.printDebug) {
                            debugPrint("timer last");
                          }
                          var _len = adapter.length;
                          var _index = (_len < _length ? _len : _length) - 1;
                          if (scrollController[i]
                              .position
                              .hasContentDimensions) {
                            scrollController[i].jumpToItem(_index);
                          } else {
                            scrollController[i] = FixedExtentScrollController(
                                initialItem: _index);
                            if (_keys[i] != null) {
                              _keys[i]!(() {});
                            }
                          }
                        });
                      }

                      return _view;
                    },
                  ),
          ),
        );
        items.add(view);
      }
    }

    if (picker.delimiter != null && !_wait) {
      for (int i = 0; i < picker.delimiter!.length; i++) {
        var o = picker.delimiter![i];
        if (o.child == null) continue;
        var item = SizedBox(
            height: picker.height,
            child: DecoratedBox(
              decoration: _decoration,
              child: o.child,
            ));
        if (o.column < 0) {
          items.insert(0, item);
        } else if (o.column >= items.length) {
          items.add(item);
        } else {
          items.insert(o.column, item);
        }
      }
    }

    if (picker.reversedOrder) return items.reversed.toList();

    return items;
  }

  Widget _buildCupertinoPicker(BuildContext context, int i, int _length,
      _PickerAdapter adapter, Key? key) {
    return CupertinoPicker.builder(
      key: key,
      backgroundColor: picker.backgroundColor,
      scrollController: scrollController[i],
      itemExtent: picker.itemExtent,
      magnification: picker.magnification,
      diameterRatio: picker.diameterRatio,
      squeeze: picker.squeeze,
      selectionOverlay: picker.selectionOverlay,
      childCount: picker.looping ? null : _length,
      itemBuilder: (context, index) {
        adapter.setColumn(i - 1);
        return adapter.buildItem(context, index % _length);
      },
      onSelectedItemChanged: (int _index) {
        if (_length <= 0) return;
        var index = _index % _length;
        if (picker.printDebug) {
          debugPrint("onSelectedItemChanged. col: $i, row: $index");
        }
        picker.selecteds[i] = index;
        updateScrollController(i);
        adapter.doSelect(i, index);
        if (picker.changeToFirst) {
          for (int j = i + 1; j < picker.selecteds.length; j++) {
            picker.selecteds[j] = 0;
            scrollController[j].jumpTo(0.0);
          }
        }
        if (picker.onSelect != null) {
          picker.onSelect!(picker, i, picker.selecteds);
        }

        if (adapter.needUpdatePrev(i)) {
          for (int j = 0; j < picker.selecteds.length; j++) {
            if (j != i && _keys[j] != null) {
              adapter.setColumn(j - 1);
              _keys[j]!(() {});
            }
          }
        } else {
          if (_keys[i] != null) _keys[i]!(() {});
          if (adapter.isLinkage) {
            for (int j = i + 1; j < picker.selecteds.length; j++) {
              if (j == i) continue;
              adapter.setColumn(j - 1);
              _keys[j]?.call(() {});
            }
          }
        }
      },
    );
  }

  void updateScrollController(int col) {
    if (_changing || picker.adapter.isLinkage == false) return;
    _changing = true;
    for (int j = 0; j < picker.selecteds.length; j++) {
      if (j != col) {
        if (scrollController[j].hasClients &&
            scrollController[j].position.hasContentDimensions) {
          scrollController[j].position.notifyListeners();
        }
      }
    }
    _changing = false;
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>("_changing", _changing));
  }
}

abstract class _PickerAdapter<T> {
  _Picker? picker;

  int getLength();
  int getMaxLevel();
  void setColumn(int index);
  void initSelects();
  Widget buildItem(BuildContext context, int index);

  bool needUpdatePrev(int curIndex) {
    return false;
  }

  Widget makeText(Widget? child, String? text, bool isSel) {
    final theme = picker!.textStyle != null || picker!.state?.context == null
        ? null
        : Theme.of(picker!.state!.context);
    return Center(
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker!.textAlign,
            style: picker!.textStyle ??
                TextStyle(
                    color: theme?.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                    fontFamily: theme == null
                        ? ""
                        : theme.textTheme.titleLarge?.fontFamily,
                    fontSize: _Picker.kDefaultTextSize),
            child: child != null
                ? (isSel && picker!.selectedIconTheme != null
                    ? IconTheme(
                        data: picker!.selectedIconTheme!,
                        child: child,
                      )
                    : child)
                : Text(text ?? "",
                    style: (isSel ? picker!.selectedTextStyle : null))));
  }

  Widget makeTextEx(
      Widget? child, String text, Widget? postfix, Widget? suffix, bool isSel) {
    List<Widget> items = [];
    if (postfix != null) items.add(postfix);
    items.add(
        child ?? Text(text, style: (isSel ? picker!.selectedTextStyle : null)));
    if (suffix != null) items.add(suffix);
    final theme = picker!.textStyle != null || picker!.state?.context == null
        ? null
        : Theme.of(picker!.state!.context);
    Color? _txtColor =
        theme?.brightness == Brightness.dark ? Colors.white : Colors.black87;
    double? _txtSize = _Picker.kDefaultTextSize;
    if (isSel && picker!.selectedTextStyle != null) {
      if (picker!.selectedTextStyle!.color != null) {
        _txtColor = picker!.selectedTextStyle!.color;
      }
      if (picker!.selectedTextStyle!.fontSize != null) {
        _txtSize = picker!.selectedTextStyle!.fontSize;
      }
    }

    return Center(
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker!.textAlign,
            style: picker!.textStyle ??
                TextStyle(
                    color: _txtColor,
                    fontSize: _txtSize,
                    fontFamily: theme == null
                        ? ""
                        : theme.textTheme.titleLarge?.fontFamily),
            child: Wrap(
              children: items,
            )));
  }

  String getText() {
    return getSelectedValues().toString();
  }

  List<T> getSelectedValues() {
    return [];
  }

  void doShow() {}
  void doSelect(int column, int index) {}

  int getColumnFlex(int column) {
    if (picker!.columnFlex != null && column < picker!.columnFlex!.length) {
      return picker!.columnFlex![column];
    }
    return 1;
  }

  int get maxLevel => getMaxLevel();

  int get length => getLength();

  String get text => getText();

  bool get isLinkage => getIsLinkage();

  @override
  String toString() {
    return getText();
  }

  bool getIsLinkage() {
    return true;
  }

  void notifyDataChanged() {
    if (picker?.state != null) {
      picker!.adapter.doShow();
      picker!.adapter.initSelects();
      for (int j = 0; j < picker!.selecteds.length; j++) {
        picker!.state!.scrollController[j].jumpToItem(picker!.selecteds[j]);
      }
    }
  }
}

class _PickerDataAdapter<T> extends _PickerAdapter<T> {
  late List<_PickerItem<T>> data;
  List<_PickerItem<dynamic>>? _datas;
  int _maxLevel = -1;
  int _col = 0;
  final bool isArray;

  _PickerDataAdapter(
      {List? pickerData, List<_PickerItem<T>>? data, this.isArray = false}) {
    this.data = data ?? <_PickerItem<T>>[];
    _parseData(pickerData);
  }

  @override
  bool getIsLinkage() {
    return !isArray;
  }

  void _parseData(List? pickerData) {
    if (pickerData != null && pickerData.isNotEmpty && (data.isEmpty)) {
      if (isArray) {
        _parseArrayPickerDataItem(pickerData, data);
      } else {
        _parsePickerDataItem(pickerData, data);
      }
    }
  }

  _parseArrayPickerDataItem(List? pickerData, List<_PickerItem> data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var v = pickerData[i];
      if (v is! List) continue;
      List lv = v;
      if (lv.isEmpty) continue;

      _PickerItem item = _PickerItem<T>(children: <_PickerItem<T>>[]);
      data.add(item);

      for (int j = 0; j < lv.length; j++) {
        var o = lv[j];
        if (o is T) {
          item.children!.add(_PickerItem<T>(value: o));
        } else if (T == String) {
          String _v = o.toString();
          item.children!.add(_PickerItem<T>(value: _v as T));
        }
      }
    }
    if (picker?.printDebug == true) {
      debugPrint("data.length: ${data.length}");
    }
  }

  _parsePickerDataItem(List? pickerData, List<_PickerItem> data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var item = pickerData[i];
      if (item is T) {
        data.add(_PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.isEmpty) continue;

        List<T> _mapList = map.keys.toList().cast();
        for (int j = 0; j < _mapList.length; j++) {
          var _o = map[_mapList[j]];
          if (_o is List && _o.isNotEmpty) {
            List<_PickerItem<T>> _children = <_PickerItem<T>>[];
            //print("add: ${data.runtimeType.toString()}");
            data.add(_PickerItem<T>(value: _mapList[j], children: _children));
            _parsePickerDataItem(_o, _children);
          }
        }
      } else if (T == String && item is! List) {
        String _v = item.toString();
        //print("add: $_v");
        data.add(_PickerItem<T>(value: _v as T));
      }
    }
  }

  @override
  void setColumn(int index) {
    if (_datas != null && _col == index + 1) return;
    _col = index + 1;
    if (isArray) {
      if (picker!.printDebug) {
        debugPrint("index: $index");
      }
      if (_col < data.length) {
        _datas = data[_col].children;
      } else {
        _datas = null;
      }
      return;
    }
    if (index < 0) {
      _datas = data;
    } else {
      _datas = data;
      for (int i = 0; i <= index; i++) {
        var j = picker!.selecteds[i];
        if (_datas != null && _datas!.length > j) {
          _datas = _datas![j].children;
        } else {
          _datas = null;
          break;
        }
      }
    }
  }

  @override
  int getLength() => _datas?.length ?? 0;

  @override
  getMaxLevel() {
    if (_maxLevel == -1) _checkPickerDataLevel(data, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final _PickerItem item = _datas![index];
    final isSel = index == picker!.selecteds[_col];
    if (picker!.onBuilderItem != null) {
      final _v = picker!.onBuilderItem!(
          context, item.value.toString(), item.text, isSel, _col, index);
      if (_v != null) return makeText(_v, null, isSel);
    }
    if (item.text != null) {
      return isSel && picker!.selectedTextStyle != null
          ? DefaultTextStyle(
              style: picker!.selectedTextStyle!,
              textAlign: picker!.textAlign,
              child: picker!.selectedIconTheme != null
                  ? IconTheme(
                      data: picker!.selectedIconTheme!,
                      child: item.text!,
                    )
                  : item.text!)
          : item.text!;
    }
    return makeText(
        item.text, item.text != null ? null : item.value.toString(), isSel);
  }

  @override
  void initSelects() {
    // ignore: unnecessary_null_comparison
    if (picker!.selecteds == null) picker!.selecteds = <int>[];
    if (picker!.selecteds.isEmpty) {
      for (int i = 0; i < _maxLevel; i++) {
        picker!.selecteds.add(0);
      }
    }
  }

  @override
  List<T> getSelectedValues() {
    List<T> _items = [];
    var _sLen = picker!.selecteds.length;
    if (isArray) {
      for (int i = 0; i < _sLen; i++) {
        int j = picker!.selecteds[i];
        if (j < 0 ||
            data[i].children == null ||
            j >= data[i].children!.length) {
          break;
        }
        _items.add(data[i].children![j].value as T);
      }
    } else {
      List<_PickerItem<dynamic>>? datas = data;
      for (int i = 0; i < _sLen; i++) {
        int j = picker!.selecteds[i];
        if (j < 0 || j >= datas!.length) break;
        _items.add(datas[j].value);
        datas = datas[j].children;
        if (datas == null || datas.isEmpty) break;
      }
    }
    return _items;
  }

  _checkPickerDataLevel(List<_PickerItem>? data, int level) {
    if (data == null) return;
    if (isArray) {
      _maxLevel = data.length;
      return;
    }
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children!.isNotEmpty) {
        _checkPickerDataLevel(data[i].children, level + 1);
      }
    }
    if (_maxLevel < level) _maxLevel = level;
  }
}

class _NumberPickerColumn {
  final List<int>? items;
  final int begin;
  final int end;
  final int? initValue;
  final int columnFlex;
  final int jump;
  final Widget? postfix, suffix;
  final _PickerValueFormat<int>? onFormatValue;

  const _NumberPickerColumn({
    this.begin = 0,
    this.end = 9,
    this.items,
    this.initValue,
    this.jump = 1,
    this.columnFlex = 1,
    this.postfix,
    this.suffix,
    this.onFormatValue,
  });

  int indexOf(int? value) {
    if (value == null) return -1;
    if (items != null) return items!.indexOf(value);
    if (value < begin || value > end) return -1;
    return (value - begin) ~/ (jump == 0 ? 1 : jump);
  }

  int valueOf(int index) {
    if (items != null) {
      return items![index];
    }
    return begin + index * (jump == 0 ? 1 : jump);
  }

  String getValueText(int index) {
    return onFormatValue == null
        ? "${valueOf(index)}"
        : onFormatValue!(valueOf(index));
  }

  int count() {
    var v = (end - begin) ~/ (jump == 0 ? 1 : jump) + 1;
    if (v < 1) return 0;
    return v;
  }
}

class _NumberPickerAdapter extends _PickerAdapter<int> {
  _NumberPickerAdapter({required this.data});

  final List<_NumberPickerColumn> data;
  _NumberPickerColumn? cur;
  int _col = 0;

  @override
  int getLength() {
    if (cur == null) return 0;
    if (cur!.items != null) return cur!.items!.length;
    return cur!.count();
  }

  @override
  int getMaxLevel() => data.length;

  @override
  bool getIsLinkage() {
    return false;
  }

  @override
  void setColumn(int index) {
    if (index != -1 && _col == index + 1) return;
    _col = index + 1;
    if (_col >= data.length) {
      cur = null;
    } else {
      cur = data[_col];
    }
  }

  @override
  void initSelects() {
    int _maxLevel = getMaxLevel();
    // ignore: unnecessary_null_comparison
    if (picker!.selecteds == null) picker!.selecteds = <int>[];
    if (picker!.selecteds.isEmpty) {
      for (int i = 0; i < _maxLevel; i++) {
        int v = data[i].indexOf(data[i].initValue);
        if (v < 0) v = 0;
        picker!.selecteds.add(v);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final txt = cur!.getValueText(index);
    final isSel = index == picker!.selecteds[_col];
    if (picker!.onBuilderItem != null) {
      final _v = picker!.onBuilderItem!(context, txt, null, isSel, _col, index);
      if (_v != null) return makeText(_v, null, isSel);
    }
    if (cur!.postfix == null && cur!.suffix == null) {
      return makeText(null, txt, isSel);
    } else {
      return makeTextEx(null, txt, cur!.postfix, cur!.suffix, isSel);
    }
  }

  @override
  int getColumnFlex(int column) {
    return data[column].columnFlex;
  }

  @override
  List<int> getSelectedValues() {
    List<int> _items = [];
    for (int i = 0; i < picker!.selecteds.length; i++) {
      int j = picker!.selecteds[i];
      int v = data[i].valueOf(j);
      _items.add(v);
    }
    return _items;
  }
}

class PickerDateTimeType {
  static const int kMDY = 0; // m, d, y
  static const int kHM = 1; // hh, mm
  static const int kHMS = 2; // hh, mm, ss
  static const int kHMAP = 3; // hh, mm, ap(AM/PM)
  static const int kMDYHM = 4; // m, d, y, hh, mm
  static const int kMDYHMAP = 5; // m, d, y, hh, mm, AM/PM
  static const int kMDYHMS = 6; // m, d, y, hh, mm, ss

  static const int kYMD = 7; // y, m, d
  static const int kYMDHM = 8; // y, m, d, hh, mm
  static const int kYMDHMS = 9; // y, m, d, hh, mm, ss
  static const int kYMDAPHM = 10; // y, m, d, ap, hh, mm

  static const int kYM = 11; // y, m
  static const int kDMY = 12; // d, m, y
  static const int kY = 13; // y
}

class _DateTimePickerAdapter extends _PickerAdapter<DateTime> {
  final int type;

  final bool isNumberMonth;

  final List<String>? months;

  final List<String>? strAMPM;

  final int? yearBegin, yearEnd;

  final int? minHour, maxHour;

  final DateTime? minValue, maxValue;

  final int? minuteInterval;

  final String? yearSuffix,
      monthSuffix,
      daySuffix,
      hourSuffix,
      minuteSuffix,
      secondSuffix;

  final bool twoDigitYear;

  final List<int>? customColumnType;

  static const List<String> kMonthsListEN = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  _DateTimePickerAdapter({
    _Picker? picker,
    this.type = 0,
    this.isNumberMonth = false,
    this.months = kMonthsListEN,
    this.strAMPM,
    this.yearBegin = 1900,
    this.yearEnd = 2100,
    this.value,
    this.minValue,
    this.maxValue,
    this.minHour,
    this.maxHour,
    this.secondSuffix,
    this.minuteSuffix,
    this.hourSuffix,
    this.yearSuffix,
    this.monthSuffix,
    this.daySuffix,
    this.minuteInterval,
    this.customColumnType,
    this.twoDigitYear = false,
  }) : assert(minuteInterval == null ||
            (minuteInterval >= 1 &&
                minuteInterval <= 30 &&
                (60 % minuteInterval == 0))) {
    super.picker = picker;
    _yearBegin = yearBegin ?? 0;
    if (minValue != null && minValue!.year > _yearBegin) {
      _yearBegin = minValue!.year;
    }
    List<int> _columnType;
    if (customColumnType != null) {
      _columnType = customColumnType!;
    } else {
      _columnType = columnType[type];
    }
    var month = _columnType.indexWhere((element) => element == 1);
    var day = _columnType.indexWhere((element) => element == 2);
    _needUpdatePrev =
        day < month || day < _columnType.indexWhere((element) => element == 0);
    if (!_needUpdatePrev) {
      var ap = _columnType.indexWhere((element) => element == 6);
      if (ap > _columnType.indexWhere((element) => element == 7)) {
        _apBeforeHourAp = true;
        _needUpdatePrev = true;
      }
    }
    value ??= DateTime.now();
    _existSec = existSec();
    _verificationMinMaxValue();
  }

  bool _existSec = false;
  int _col = 0;
  int _colAP = -1;
  int _colHour = -1;
  int _colDay = -1;
  int _yearBegin = 0;
  bool _needUpdatePrev = false;
  bool _apBeforeHourAp = false;

  DateTime? value;

  static const List<List<int>> lengths = [
    [12, 31, 0],
    [24, 60],
    [24, 60, 60],
    [12, 60, 2],
    [12, 31, 0, 24, 60],
    [12, 31, 0, 12, 60, 2],
    [12, 31, 0, 24, 60, 60],
    [0, 12, 31],
    [0, 12, 31, 24, 60],
    [0, 12, 31, 24, 60, 60],
    [0, 12, 31, 2, 12, 60],
    [0, 12],
    [31, 12, 0],
    [0],
  ];

  static const Map<int, int> columnTypeLength = {
    0: 0,
    1: 12,
    2: 31,
    3: 24,
    4: 60,
    5: 60,
    6: 2,
    7: 12
  };

  static const List<List<int>> columnType = [
    [1, 2, 0],
    [3, 4],
    [3, 4, 5],
    [7, 4, 6],
    [1, 2, 0, 3, 4],
    [1, 2, 0, 7, 4, 6],
    [1, 2, 0, 3, 4, 5],
    [0, 1, 2],
    [0, 1, 2, 3, 4],
    [0, 1, 2, 3, 4, 5],
    [0, 1, 2, 6, 7, 4],
    [0, 1],
    [2, 1, 0],
    [0],
  ];

  int getColumnType(int index) {
    if (customColumnType != null) return customColumnType![index];
    List<int> items = columnType[type];
    if (index >= items.length) return -1;
    return items[index];
  }

  bool existSec() {
    final _columns =
        customColumnType == null ? columnType[type] : customColumnType!;
    return _columns.contains(5);
  }

  @override
  int getLength() {
    int v = (customColumnType == null
        ? lengths[type][_col]
        : columnTypeLength[customColumnType![_col]])!;
    if (v == 0) {
      int ye = yearEnd!;
      if (maxValue != null) ye = maxValue!.year;
      return ye - _yearBegin + 1;
    }
    if (v == 31) return _calcDateCount(value!.year, value!.month);
    int _type = getColumnType(_col);
    switch (_type) {
      case 3: // hour
        if ((minHour != null && minHour! >= 0) ||
            (maxHour != null && maxHour! <= 23)) {
          return (maxHour ?? 23) - (minHour ?? 0) + 1;
        }
        break;
      case 4: // minute
        if (minuteInterval != null && minuteInterval! > 1) {
          return v ~/ minuteInterval!;
        }
        break;
      case 7: // hour am/pm
        if ((minHour != null && minHour! >= 0) ||
            (maxHour != null && maxHour! <= 23)) {
          if (_colAP < 0) {
            return 12;
          } else {
            var _min = 0;
            var _max = 0;
            if (picker!.selecteds[_colAP] == 0) {
              // am
              _min = minHour == null
                  ? 1
                  : minHour! >= 12
                      ? 12
                      : minHour! + 1;
              _max = maxHour == null
                  ? 12
                  : maxHour! >= 12
                      ? 12
                      : maxHour! + 1;
            } else {
              _min = minHour == null
                  ? 1
                  : minHour! >= 12
                      ? 24 - minHour! - 12
                      : 1;
              _max = maxHour == null
                  ? 12
                  : maxHour! >= 12
                      ? maxHour! - 12
                      : 1;
            }
            return _max > _min ? _max - _min + 1 : _min - _max + 1;
          }
        }
        break;
    }
    return v;
  }

  @override
  int getMaxLevel() {
    return customColumnType == null
        ? lengths[type].length
        : customColumnType!.length;
  }

  @override
  bool needUpdatePrev(int curIndex) {
    if (_needUpdatePrev) {
      if (value?.month == 2) {
        var _curType = getColumnType(curIndex);
        return _curType == 1 || _curType == 0;
      } else if (_apBeforeHourAp) {
        return getColumnType(curIndex) == 6;
      }
    }
    return false;
  }

  @override
  void setColumn(int index) {
    _col = index + 1;
    if (_col < 0) _col = 0;
  }

  @override
  void initSelects() {
    _colAP = _getAPColIndex();
    int _maxLevel = getMaxLevel();
    // ignore: unnecessary_null_comparison
    if (picker!.selecteds == null) picker!.selecteds = <int>[];
    if (picker!.selecteds.isEmpty) {
      for (int i = 0; i < _maxLevel; i++) {
        picker!.selecteds.add(0);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    String _text = "";
    int colType = getColumnType(_col);
    switch (colType) {
      case 0:
        if (twoDigitYear) {
          _text = "${_yearBegin + index}";
          var _l = _text.length;
          _text =
              "${_text.substring(_l - (_l - 2), _l)}${_checkStr(yearSuffix)}";
        } else {
          _text = "${_yearBegin + index}${_checkStr(yearSuffix)}";
        }
        break;
      case 1:
        if (isNumberMonth) {
          _text = "${index + 1}${_checkStr(monthSuffix)}";
        } else {
          if (months != null) {
            _text = months![index];
          } else {
            List _months =
                _PickerLocalizations.of(context).months ?? kMonthsListEN;
            _text = "${_months[index]}";
          }
        }
        break;
      case 2:
        _text = "${index + 1}${_checkStr(daySuffix)}";
        break;
      case 3:
        _text = "${intToStr(index + (minHour ?? 0))}${_checkStr(hourSuffix)}";
        break;
      case 5:
        _text = "${intToStr(index)}${_checkStr(secondSuffix)}";
        break;
      case 4:
        if (minuteInterval == null || minuteInterval! < 2) {
          _text = "${intToStr(index)}${_checkStr(minuteSuffix)}";
        } else {
          _text =
              "${intToStr(index * minuteInterval!)}${_checkStr(minuteSuffix)}";
        }
        break;
      case 6:
        final apStr = strAMPM ??
            _PickerLocalizations.of(context).ampm ??
            const ["AM", "PM"];
        _text = "${apStr[index]}";
        break;
      case 7:
        _text = intToStr(index +
            (minHour == null
                ? 0
                : (picker!.selecteds[_colAP] == 0 ? minHour! : 0)) +
            1);
        break;
    }

    final isSel = picker!.selecteds[_col] == index;
    if (picker!.onBuilderItem != null) {
      var _v = picker!.onBuilderItem!(context, _text, null, isSel, _col, index);
      if (_v != null) return makeText(_v, null, isSel);
    }
    return makeText(null, _text, isSel);
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  int getColumnFlex(int column) {
    if (picker!.columnFlex != null && column < picker!.columnFlex!.length) {
      return picker!.columnFlex![column];
    }
    if (getColumnType(column) == 0) return 3;
    return 2;
  }

  @override
  void doShow() {
    if (_yearBegin == 0) getLength();
    var _maxLevel = getMaxLevel();
    final sh = value!.hour;
    for (int i = 0; i < _maxLevel; i++) {
      int colType = getColumnType(i);
      switch (colType) {
        case 0:
          picker!.selecteds[i] = yearEnd != null && value!.year > yearEnd!
              ? yearEnd! - _yearBegin
              : value!.year - _yearBegin;
          break;
        case 1:
          picker!.selecteds[i] = value!.month - 1;
          break;
        case 2:
          picker!.selecteds[i] = value!.day - 1;
          break;
        case 3:
          var h = sh;
          if ((minHour != null && minHour! >= 0) ||
              (maxHour != null && maxHour! <= 23)) {
            if (minHour != null) {
              h = h > minHour! ? h - minHour! : 0;
            } else {
              h = (maxHour ?? 23) - (minHour ?? 0) + 1;
            }
          }
          picker!.selecteds[i] = h;
          break;
        case 4:
          if (minuteInterval == null || minuteInterval! < 2) {
            picker!.selecteds[i] = value!.minute;
          } else {
            picker!.selecteds[i] = value!.minute ~/ minuteInterval!;
            final m = picker!.selecteds[i] * minuteInterval!;
            if (m != value!.minute) {
              var s = value!.second;
              if (type != 2 && type != 6) s = 0;
              final h = _colAP >= 0 ? _calcHourOfAMPM(sh, m) : sh;
              value = DateTime(value!.year, value!.month, value!.day, h, m, s);
            }
          }
          break;
        case 5:
          picker!.selecteds[i] = value!.second;
          break;
        case 6:
          picker!.selecteds[i] = (sh > 12 ||
                  (sh == 12 && (value!.minute > 0 || value!.second > 0)))
              ? 1
              : 0;
          break;
        case 7:
          picker!.selecteds[i] = sh == 0
              ? 11
              : (sh > 12)
                  ? sh - 12 - 1
                  : sh - 1;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int year, month, day, h, m, s;
    year = value!.year;
    month = value!.month;
    day = value!.day;
    h = value!.hour;
    m = value!.minute;
    s = _existSec ? value!.second : 0;

    int colType = getColumnType(column);
    switch (colType) {
      case 0:
        year = _yearBegin + index;
        break;
      case 1:
        month = index + 1;
        break;
      case 2:
        day = index + 1;
        break;
      case 3:
        h = index + (minHour ?? 0);
        break;
      case 4:
        m = (minuteInterval == null || minuteInterval! < 2)
            ? index
            : index * minuteInterval!;
        if (_colAP >= 0) {
          h = _calcHourOfAMPM(h, m);
        }
        break;
      case 5:
        s = index;
        break;
      case 6:
        h = _calcHourOfAMPM(h, m);
        if (minHour != null || maxHour != null) {
          if (minHour != null && _colHour >= 0) {
            if (h < minHour!) {
              picker!.selecteds[_colHour] = 0;
              picker!.updateColumn(_colHour);
              return;
            }
          }
          if (maxHour != null && h > maxHour!) h = maxHour!;
        }
        break;
      case 7:
        h = index +
            (minHour == null
                ? 0
                : (picker!.selecteds[_colAP] == 0 ? minHour! : 0)) +
            1;
        if (_colAP >= 0) {
          h = _calcHourOfAMPM(h, m);
        }
        if (h > 23) h = 0;
        break;
    }
    int __day = _calcDateCount(year, month);

    bool _isChangeDay = false;
    if (day > __day) {
      day = __day;
      _isChangeDay = true;
    }
    value = DateTime(year, month, day, h, m, s);

    if (_verificationMinMaxValue()) {
      notifyDataChanged();
    } else if (_isChangeDay && _colDay >= 0) {
      doShow();
      picker!.updateColumn(_colDay);
    }
  }

  bool _verificationMinMaxValue() {
    DateTime? _minV = minValue;
    DateTime? _maxV = maxValue;
    if (_minV == null && yearBegin != null) {
      _minV = DateTime(yearBegin!, 1, 1, minHour ?? 0);
    }
    if (_maxV == null && yearEnd != null) {
      _maxV = DateTime(yearEnd!, 12, 31, maxHour ?? 23, 59, 59);
    }
    if (_minV != null &&
        (value!.millisecondsSinceEpoch < _minV.millisecondsSinceEpoch)) {
      value = _minV;
      return true;
    } else if (_maxV != null &&
        value!.millisecondsSinceEpoch > _maxV.millisecondsSinceEpoch) {
      value = _maxV;
      return true;
    }
    return false;
  }

  int _calcHourOfAMPM(int h, int m) {
    if (picker!.selecteds[_colAP] == 0) {
      if (h == 12 && m == 0) {
        h = 0;
      } else if (h == 0 && m > 0) {
        h = 12;
      }
      if (h > 12) h = h - 12;
    } else {
      if (h > 0 && h < 12) h = h + 12;
      if (h == 12 && m > 0) {
        h = 0;
      } else if (h == 0 && m == 0) {
        h = 12;
      }
    }
    return h;
  }

  int _getAPColIndex() {
    List<int> items = customColumnType ?? columnType[type];
    _colHour = items.indexWhere((e) => e == 7);
    _colDay = items.indexWhere((e) => e == 2);
    for (int i = 0; i < items.length; i++) {
      if (items[i] == 6) return i;
    }
    return -1;
  }

  int _calcDateCount(int year, int month) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 2:
        {
          if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            return 29;
          }
          return 28;
        }
    }
    return 30;
  }

  String intToStr(int v) {
    return (v < 10) ? "0$v" : "$v";
  }

  String _checkStr(String? v) {
    return v ?? "";
  }
}
