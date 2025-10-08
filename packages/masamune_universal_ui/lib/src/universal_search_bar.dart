part of "/masamune_universal_ui.dart";

/// Create a search bar.
///
/// [UniversalSearchBar] is the `UniversalUI` version of search bar widget. It provides search functionality with mode switching and action button support.
/// Uses [FormTextField] internally for consistent styling across the app.
///
/// ## Basic Usage
///
/// ```dart
/// UniversalSearchBar(
///   hintText: "Search keywords",
///   onSearch: (text, mode) {
///     // Handle search action
///     print("Search text: $text");
///   },
///   onChanged: (text) {
///     // Handle text changed action
///     print("Input: $text");
///   },
///   searchIcon: const Icon(Icons.search),
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.clear),
///       onPressed: () {
///         // Handle clear action
///       },
///     ),
///   ],
/// );
/// ```
///
/// ---
///
/// 検索バーを作成します。
///
/// [UniversalSearchBar]は検索バーウィジェットの`UniversalUI`版です。検索機能を提供し、検索モードの切り替えやアクションボタンの追加が可能です。
/// 内部で[FormTextField]を使用し統一されたスタイリングを提供します。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalSearchBar(
///   hintText: "検索キーワードを入力",
///   onSearch: (text, mode) {
///     // 検索アクションを処理
///     print("検索テキスト: $text");
///   },
///   onChanged: (text) {
///     // テキスト変更アクションを処理
///     print("入力中: $text");
///   },
///   searchIcon: const Icon(Icons.search),
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.clear),
///       onPressed: () {
///         // クリアアクションを処理
///       },
///     ),
///   ],
/// );
/// ```
@immutable
class UniversalSearchBar<T> extends StatefulWidget {
  /// Create a search bar.
  ///
  /// [UniversalSearchBar] is the `UniversalUI` version of search bar widget. It provides search functionality with mode switching and action button support.
  /// Uses [FormTextField] internally for consistent styling across the app.
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalSearchBar(
  ///   hintText: "Search keywords",
  ///   onSearch: (text, mode) {
  ///     // Handle search action
  ///     print("Search text: $text");
  ///   },
  ///   onChanged: (text) {
  ///     // Handle text changed action
  ///     print("Input: $text");
  ///   },
  ///   searchIcon: const Icon(Icons.search),
  ///   actions: [
  ///     IconButton(
  ///       icon: const Icon(Icons.clear),
  ///       onPressed: () {
  ///         // Handle clear action
  ///       },
  ///     ),
  ///   ],
  /// );
  /// ```
  ///
  /// ---
  ///
  /// 検索バーを作成します。
  ///
  /// [UniversalSearchBar]は検索バーウィジェットの`UniversalUI`版です。検索機能を提供し、検索モードの切り替えやアクションボタンの追加が可能です。
  /// 内部で[FormTextField]を使用し統一されたスタイリングを提供します。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalSearchBar(
  ///   hintText: "検索キーワードを入力",
  ///   onSearch: (text, mode) {
  ///     // 検索アクションを処理
  ///     print("検索テキスト: $text");
  ///   },
  ///   onChanged: (text) {
  ///     // テキスト変更アクションを処理
  ///     print("入力中: $text");
  ///   },
  ///   searchIcon: const Icon(Icons.search),
  ///   actions: [
  ///     IconButton(
  ///       icon: const Icon(Icons.clear),
  ///       onPressed: () {
  ///         // クリアアクションを処理
  ///       },
  ///     ),
  ///   ],
  /// );
  /// ```
  const UniversalSearchBar({
    super.key,
    this.onSearch,
    this.onChanged,
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
  final void Function(String text, T mode)? onSearch;

  /// Callback when text changed.
  ///
  /// テキストが変更された時のコールバックです。
  final void Function(String text)? onChanged;

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
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        widget.onChanged?.call(value);
                      },
                      onSubmitted: (value) {
                        widget.onSearch?.call(_effectiveController.text, _mode);
                      },
                    ),
                  ),
                  IconButton(
                    icon: widget.searchIcon,
                    style: IconButton.styleFrom(
                      foregroundColor: widget.foregroundColor,
                    ),
                    onPressed: () {
                      widget.onSearch?.call(_effectiveController.text, _mode);
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
                                ?.call(_effectiveController.text, _mode);
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
