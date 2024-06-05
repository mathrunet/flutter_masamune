part of '/masamune_universal_ui.dart';

/// Create a search bar.
///
/// Set the callback for search to [onSearch].
///
/// If you set [searchModeList], you can select a search mode. In that case, specify [searchModeLabelBuilder] to display the search mode.
///
/// Other actions can be added by setting [actions].
///
/// 検索バーを作成します。
///
/// [onSearch]に検索時のコールバックを設定します。
///
/// [searchModeList]を設定すると、検索モードを選択できるようになります。その場合[searchModeLabelBuilder]を指定して検索モードを表示するようにしてください。
///
/// [actions]を設定するとその他のアクションを追加できます。
@immutable
class UniversalSearchBar<T> extends StatefulWidget {
  /// Create a search bar.
  ///
  /// Set the callback for search to [onSearch].
  ///
  /// If you set [searchModeList], you can select a search mode. In that case, specify [searchModeLabelBuilder] to display the search mode.
  ///
  /// Other actions can be added by setting [actions].
  ///
  /// 検索バーを作成します。
  ///
  /// [onSearch]に検索時のコールバックを設定します。
  ///
  /// [searchModeList]を設定すると、検索モードを選択できるようになります。その場合[searchModeLabelBuilder]を指定して検索モードを表示するようにしてください。
  ///
  /// [actions]を設定するとその他のアクションを追加できます。
  const UniversalSearchBar({
    super.key,
    required this.onSearch,
    this.controller,
    this.actions,
    this.padding,
    this.decoration,
    this.initialValue,
    this.contentPadding,
    this.margin,
    this.textStyle,
    this.autofocus = false,
    this.defaultSearchMode,
    this.searchIcon = const Icon(Icons.search),
    this.searchModeList = const [],
    this.hintText,
    this.backgroundColor,
    this.searchModeLabelBuilder,
    this.foregroundColor,
  }) : assert(
          searchModeList.length <= 0 || searchModeLabelBuilder != null,
          "[searchModeLabelBuilder] is required when [searchModeList] is not empty,",
        );

  /// The default search mode.
  ///
  /// デフォルトの検索モードです。
  final T? defaultSearchMode;

  /// List of search modes.
  ///
  /// To set this, specify [searchModeLabelBuilder].
  ///
  /// 検索モードのリストです。
  ///
  /// これを設定する場合[searchModeLabelBuilder]を指定してください。
  final List<T> searchModeList;

  /// Builder for search mode label.
  ///
  /// 検索モードのラベルのビルダーです。
  final Widget Function(T mode)? searchModeLabelBuilder;

  /// Initial value.
  ///
  /// 初期値です。
  final String? initialValue;

  /// Callback when search.
  ///
  /// 検索時のコールバックです。
  final void Function(String text, T mode) onSearch;

  /// Text controller.
  ///
  /// テキストコントローラーです。
  final TextEditingController? controller;

  /// List of actions.
  ///
  /// アクションのリストです。
  final List<Widget>? actions;

  /// Search icon.
  ///
  /// 検索アイコンです。
  final Widget searchIcon;

  /// Search bar margins.
  ///
  /// 検索バーのマージン。
  final EdgeInsetsGeometry? margin;

  /// Search bar padding.
  ///
  /// 検索バーのパディング。
  final EdgeInsetsGeometry? padding;

  /// Content padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsetsGeometry? contentPadding;

  /// Decoration.
  ///
  /// デコレーション。
  final Decoration? decoration;

  /// Text style.
  ///
  /// テキストスタイル。
  final TextStyle? textStyle;

  /// `true` if autofocus.
  ///
  /// オートフォーカスする場合は`true`。
  final bool autofocus;

  /// Hint text.
  ///
  /// ヒントテキスト。
  final String? hintText;

  /// Background color.
  ///
  /// 背景色。
  final Color? backgroundColor;

  /// Foreground color.
  ///
  /// 前景色。
  final Color? foregroundColor;

  @override
  State<StatefulWidget> createState() => _UniversalSearchBarState();
}

class _UniversalSearchBarState<T> extends State<UniversalSearchBar> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!;
  late T? _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.defaultSearchMode;
    _focusNode = FocusNode();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _controller?.dispose();
  }

  @override
  void didUpdateWidget(UniversalSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller == null) {
        _controller = TextEditingController();
      }
    }
    if (widget.initialValue != oldWidget.initialValue) {
      _effectiveController.text = widget.initialValue ?? "";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autofocus) {
      _focusNode?.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: widget.foregroundColor),
      child: IconTheme(
        data: IconThemeData(color: widget.foregroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
              padding:
                  widget.padding ?? const EdgeInsets.symmetric(horizontal: 8),
              decoration: widget.decoration ??
                  BoxDecoration(
                    color: widget.backgroundColor ??
                        Theme.of(context).colorScheme.surface,
                    borderRadius: 4.r,
                  ),
              child: Row(
                children: [
                  Expanded(
                    child: FormTextField(
                      focusNode: _focusNode,
                      hintText: widget.hintText,
                      style: FormStyle(
                        textStyle: widget.textStyle,
                        contentPadding: widget.contentPadding,
                      ),
                      controller: _effectiveController,
                      onSubmitted: (value) {
                        widget.onSearch.call(_effectiveController.text, _mode);
                      },
                    ),
                  ),
                  IconButton(
                    icon: widget.searchIcon,
                    style: IconButton.styleFrom(
                      foregroundColor: widget.foregroundColor,
                    ),
                    onPressed: () {
                      widget.onSearch.call(_effectiveController.text, _mode);
                    },
                  ),
                  if (widget.actions != null) ...widget.actions!,
                ],
              ),
            ),
            if (widget.searchModeList.isNotEmpty &&
                widget.searchModeLabelBuilder != null)
              Row(
                children: [
                  ...widget.searchModeList.map(
                    (e) {
                      return InkWell(
                        onTap: () {
                          if (_mode == e) {
                            return;
                          }
                          setState(() {
                            _mode = e;
                            widget.onSearch
                                .call(_effectiveController.text, _mode);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(_mode == e
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                            widget.searchModeLabelBuilder?.call(e) ??
                                const Empty(),
                            8.sx,
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
