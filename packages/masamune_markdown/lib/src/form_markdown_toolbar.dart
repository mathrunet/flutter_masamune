part of "/masamune_markdown.dart";

const _kToolbarHeight = kToolbarHeight;
const _kLinkDialogHeight = _kToolbarHeight * 2;
const _kMentionDialogSpaceHeight = _kToolbarHeight + 24.0;
const _kMinChangeSize = 16.0;
const _kBlockMenuToggleDuration = Duration(milliseconds: 200);

/// Markdown toolbar.
///
/// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
///
/// By specifying [mentionBuilder], a list of mentions can be displayed.
///
/// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
/// You can insert image and video media.
/// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
///
/// Set [collapsed] to `true` when the toolbar should be in collapsed state (e.g., when used with ExpandableBottomSheet).
///
/// Markdown用のツールバー。
///
/// [MarkdownController]を渡し同じコントローラーを[FormMarkdownField]に渡してください。
///
/// [mentionBuilder]を指定することでメンションのリストを表示することができます。
///
/// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
/// 画像や映像のメディアを挿入することができます。
/// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
///
/// ツールバーを折りたたみ状態にする場合は[collapsed]を`true`に設定してください（例: ExpandableBottomSheetと併用する場合）。
class FormMarkdownToolbar extends StatefulWidget {
  /// Markdown toolbar.
  ///
  /// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
  ///
  /// By specifying [mentionBuilder], a list of mentions can be displayed.
  ///
  /// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
  /// You can insert image and video media.
  /// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
  ///
  /// Set [collapsed] to `true` when the toolbar should be in collapsed state (e.g., when used with ExpandableBottomSheet).
  ///
  /// Markdown用のツールバー。
  ///
  /// [MarkdownController]を渡し同じコントローラーを[FormMarkdownField]に渡してください。
  ///
  /// [mentionBuilder]を指定することでメンションのリストを表示することができます。
  ///
  /// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
  /// 画像や映像のメディアを挿入することができます。
  /// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
  ///
  /// ツールバーを折りたたみ状態にする場合は[collapsed]を`true`に設定してください（例: ExpandableBottomSheetと併用する場合）。
  const FormMarkdownToolbar({
    required this.controller,
    this.primaryTools,
    this.secondaryTools,
    super.key,
    this.style,
    this.mentionHintText,
    this.mentionBuilder,
    this.linkTitleHintText,
    this.linkLinkHintText,
    this.collapsed = false,
  }) : assert(
          (mentionBuilder == null && mentionHintText == null) ||
              mentionBuilder != null,
          "MentionHintText is required when using [mentionBuilder].",
        );

  /// Primary tools for the toolbar.
  ///
  /// ツールバーのプライマリーツール。
  final List<MarkdownPrimaryTools>? primaryTools;

  /// Secondary tools for the toolbar.
  ///
  /// ツールバーのセカンダリーツール。
  final List<MarkdownSecondaryTools>? secondaryTools;

  /// [MarkdownController] for the toolbar.
  ///
  /// Pass the same one to [FormMarkdownField].
  ///
  /// ツールバー用の[MarkdownController]。
  ///
  /// 同じものを[FormMarkdownField]に渡します。
  final MarkdownController controller;

  /// Style of the toolbar.
  ///
  /// ツールバーのスタイル。
  final FormStyle? style;

  /// Hint text for the mention.
  ///
  /// メンションのヒントテキスト。
  final String? mentionHintText;

  /// Hint text for the link title.
  ///
  /// リンクタイトルのヒントテキスト。
  final String? linkTitleHintText;

  /// Hint text for the link link.
  ///
  /// リンクリンクのヒントテキスト。
  final String? linkLinkHintText;

  /// Builder for the mentions.
  ///
  /// メンションのビルダー。
  final List<MarkdownMention> Function(BuildContext context)? mentionBuilder;

  /// Whether the toolbar is collapsed.
  ///
  /// ツールバーが折りたたまれているかどうか。
  final bool collapsed;

  @override
  State<FormMarkdownToolbar> createState() => FormMarkdownToolbarState();
}

/// State for [FormMarkdownToolbar].
///
/// [FormMarkdownToolbar]の状態。
class FormMarkdownToolbarState extends State<FormMarkdownToolbar>
    implements MarkdownToolRef {
  bool _isKeyboardHidden = false;
  bool _showBlockMenu = false;
  double _blockMenuHeight = 0;
  double _lastBottomInset = 0;
  Duration? _blockMenuToggleDuration;
  double? _prevBottomInset;
  bool _hasClipboardText = false;
  Timer? _clipboardCheckTimer;
  Completer<void>? _clipboardCheckCompleter;

  _LinkSetting? _linkSetting;
  _MentionSetting? _mentionSetting;

  @override
  MarkdownController get controller => widget.controller;

  @override
  MarkdownFieldState? get field => widget.controller._field;

  @override
  TextSelection? get selection => controller._field?._selection;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerStateOnChanged);
    _checkClipboard();
    // ペーストボタンの状態を更新するために定期的にクリップボードをチェック
    // TODO: もっといい実装はないかチェック
    _clipboardCheckTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _checkClipboard(),
    );
    widget.controller.setLinkDialogCallback(toggleLinkDialog);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerStateOnChanged);
    _clipboardCheckTimer?.cancel();
    _linkSetting?.cancel();
    _mentionSetting?.cancel();
    super.dispose();
  }

  @override
  MarkdownTools? get currentTool => _currentTool;
  MarkdownTools? _currentTool;

  @override
  bool get isKeyboardShowing =>
      _showBlockMenu || context.mediaQuery.viewInsets.bottom > 0;

  @override
  bool get isTextSelected {
    final selection = controller._field?._selection;
    if (selection == null) {
      return false;
    }
    return selection.isValid && !selection.isCollapsed;
  }

  @override
  bool get canPaste => _hasClipboardText;

  @override
  List<MarkdownMention> Function(BuildContext context)? get mentionBuilder =>
      widget.mentionBuilder;

  @override
  void toggleMode(MarkdownPrimaryTools tool) {
    // IME入力中の場合は先に確定する
    controller.finishComposing();

    setState(() {
      if (tool == _currentTool) {
        if (_showBlockMenu) {
          if (_blockMenuToggleDuration != null) {
            _blockMenuHeight = 0;
            _blockMenuToggleDuration = _kBlockMenuToggleDuration;
          }
          _showBlockMenu = false;
          _showKeyboard();
        } else {
          if (tool.hideKeyboardOnSelected) {
            if (_blockMenuHeight == 0) {
              _blockMenuHeight = context.mediaQuery.size.height / 3.0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
            _showBlockMenu = true;
            _hideKeyboard();
          }
        }
        _currentTool = tool;
      } else {
        if (_showBlockMenu) {
          if (!tool.hideKeyboardOnSelected) {
            if (_blockMenuToggleDuration != null) {
              _blockMenuHeight = 0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
            _showBlockMenu = false;
            _showKeyboard();
          }
        } else {
          if (tool.hideKeyboardOnSelected) {
            _showBlockMenu = true;
            _hideKeyboard();
            if (_blockMenuHeight == 0) {
              _blockMenuHeight = context.mediaQuery.size.height / 3.0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
          }
        }
        if (tool is MentionMarkdownPrimaryTools) {
          _mentionSetting = _MentionSetting(
            field: field!,
          );
          _mentionSetting!.focusNode.requestFocus();
        }
        if (_currentTool is MentionMarkdownPrimaryTools) {
          _mentionSetting?.cancel();
          _mentionSetting = null;
        }
        _currentTool = tool;
      }
    });
  }

  @override
  void toggleLinkDialog([String? initialUrl]) {
    // IME入力中の場合は先に確定する
    controller.finishComposing();

    if (_linkSetting != null) {
      setState(() {
        _linkSetting = null;
      });
    } else {
      setState(() {
        _linkSetting = _LinkSetting(
          field: field!,
          controller: controller,
          initialUrl: initialUrl,
        );
        _linkSetting?.focusNode.requestFocus();
      });
    }
  }

  @override
  void deleteMode() {
    // IME入力中の場合は先に確定する
    controller.finishComposing();

    setState(() {
      if (_currentTool is MentionMarkdownPrimaryTools) {
        _mentionSetting?.cancel();
        _mentionSetting = null;
      }
      if (_blockMenuToggleDuration != null) {
        _blockMenuHeight = 0;
        _blockMenuToggleDuration = _kBlockMenuToggleDuration;
      }
      _currentTool = null;
      _showBlockMenu = false;
      _showKeyboard();
    });
  }

  @override
  void closeKeyboard() {
    // IME入力中の場合は先に確定する
    controller.finishComposing();

    setState(() {
      _isKeyboardHidden = true;
      _showBlockMenu = false;
      _blockMenuHeight = 0;
      controller.focusNode.unfocus();
      _hideKeyboard();
    });
  }

  @override
  MarkdownImageBlockValue? insertImage(Uri uri) {
    return widget.controller.insertImage(uri);
  }

  @override
  void insertVideo(Uri uri) {
    // TODO: insert video
  }

  @override
  TValue? insertBlock<TValue extends MarkdownBlockValue>(
    TValue block, {
    int? offset,
  }) {
    return widget.controller.insertBlock<TValue>(block, offset: offset);
  }

  @override
  TValue? exchangeBlock<TValue extends MarkdownBlockValue>(
    TValue block, {
    int? index,
  }) {
    return widget.controller.exchangeBlock<TValue>(block, index: index);
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
  }

  void _showKeyboard() {
    if (field != null) {
      field!.reopenInputConnection();
    } else {
      SystemChannels.textInput.invokeMethod("TextInput.show");
    }
  }

  Future<void> _checkClipboard() async {
    if (_clipboardCheckCompleter != null) {
      return _clipboardCheckCompleter!.future;
    }
    _clipboardCheckCompleter = Completer<void>();
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final hasText = data?.text?.isNotEmpty ?? false;
      if (_hasClipboardText != hasText) {
        setState(() {
          _hasClipboardText = hasText;
        });
      }
      _clipboardCheckCompleter?.complete();
      _clipboardCheckCompleter = null;
    } catch (e) {
      _clipboardCheckCompleter?.completeError(e);
      _clipboardCheckCompleter = null;
    } finally {
      _clipboardCheckCompleter?.complete();
      _clipboardCheckCompleter = null;
    }
  }

  void _handledOnKeyboardStateChanged() {
    final currentBottomInset = context.mediaQuery.viewInsets.bottom;
    if (_prevBottomInset == currentBottomInset) {
      return;
    }
    _prevBottomInset = currentBottomInset;
    final isKeyboardShowing =
        _lastBottomInset + _kMinChangeSize < currentBottomInset;
    if (currentBottomInset > 0) {
      if (_isKeyboardHidden && _lastBottomInset == 0) {
        _isKeyboardHidden = false;
      }
      _blockMenuToggleDuration = null;
    }
    _lastBottomInset = currentBottomInset;
    if (!_isKeyboardHidden && _blockMenuHeight < currentBottomInset) {
      _blockMenuHeight = currentBottomInset;
    }
    if (isKeyboardShowing) {
      if (_showBlockMenu) {
        _showBlockMenu = false;
      }
    }
  }

  void _handleControllerStateOnChanged() {
    if ((isTextSelected && _currentTool is! FontMarkdownPrimaryTools) ||
        (!isTextSelected && _currentTool is FontMarkdownPrimaryTools)) {
      if (isTextSelected) {
        toggleMode(const FontMarkdownPrimaryTools());
      } else {
        deleteMode();
      }
      if (!isTextSelected) {
        setState(() {
          _linkSetting = null;
        });
      }
    } else {
      // 選択状態の変更を反映するためにUIを更新（例: コピーボタンの表示/非表示）
      // TODO: 状態を監視してUIを更新するようにする
      setState(() {});
    }
    if (_currentTool is MentionMarkdownPrimaryTools &&
        _showBlockMenu &&
        ((field?.cursorInLink ?? false) ||
            (field?.selectInMentionLink ?? false))) {
      toggleMode(const MentionMarkdownPrimaryTools());
    }
  }

  Iterable<Widget> _buildPrimaryTools(BuildContext context, ThemeData theme) {
    final primaryTools =
        widget.primaryTools ?? controller.adapter.defaultPrimaryTools;
    return primaryTools.mapAndRemoveEmpty((e) {
      if (!e.shown(context, this)) {
        return null;
      }
      // すべてのツールをListenableBuilderでラップしてコントローラー変更時にenabled/activedを再評価
      if (e is MentionMarkdownPrimaryTools) {
        if (_currentTool == e && _showBlockMenu) {
          return IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: widget.style?.activeBackgroundColor ??
                  theme.colorTheme?.primary ??
                  theme.colorScheme.primary,
              foregroundColor: widget.style?.activeColor ??
                  theme.colorTheme?.onPrimary ??
                  theme.colorScheme.onPrimary,
            ),
            onPressed: ((field?.cursorInLink ?? false) ||
                    (field?.selectInMentionLink ?? false))
                ? null
                : () {
                    e.onTap(context, this);
                  },
            icon: e.icon(context, this),
          );
        } else {
          return IconButton(
            onPressed: ((field?.cursorInLink ?? false) ||
                    (field?.selectInMentionLink ?? false))
                ? null
                : () {
                    e.onTap(context, this);
                  },
            icon: e.icon(context, this),
          );
        }
      } else if (e is IndentUpMarkdownPrimaryTools ||
          e is IndentDownMarkdownPrimaryTools) {
        final enabled = e.enabled(context, this);
        final actived = e.actived(context, this);
        if (!enabled || !actived) {
          return IconButton(
            onPressed: null,
            icon: e.icon(context, this),
          );
        }

        if (_currentTool == e && _showBlockMenu) {
          return IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: widget.style?.activeBackgroundColor ??
                  theme.colorTheme?.primary ??
                  theme.colorScheme.primary,
              foregroundColor: widget.style?.activeColor ??
                  theme.colorTheme?.onPrimary ??
                  theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              e.onTap(context, this);
            },
            icon: e.icon(context, this),
          );
        } else {
          return IconButton(
            onPressed: () {
              e.onTap(context, this);
            },
            icon: e.icon(context, this),
          );
        }
      } else {
        // コントローラー変更時にenabled/activedを再評価
        if (!e.enabled(context, this) || !e.actived(context, this)) {
          return IconButton(
            onPressed: null,
            icon: e.icon(context, this),
          );
        }

        if (_currentTool == e && _showBlockMenu) {
          return IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: widget.style?.activeBackgroundColor ??
                  theme.colorTheme?.primary ??
                  theme.colorScheme.primary,
              foregroundColor: widget.style?.activeColor ??
                  theme.colorTheme?.onPrimary ??
                  theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              e.onTap(context, this);
            },
            icon: e.icon(context, this),
          );
        } else {
          return IconButton(
            onPressed: () {
              e.onTap(context, this);
            },
            icon: e.icon(context, this),
          );
        }
      }
    });
  }

  Iterable<Widget> _buildSecondaryTools(BuildContext context, ThemeData theme) {
    final secondaryTools =
        widget.secondaryTools ?? controller.adapter.defaultSecondaryTools;
    final subMenu = secondaryTools.mapAndRemoveEmpty((e) {
      if (e.shown(context, this)) {
        return IconButton(
          onPressed: () {
            e.onTap(context, this);
          },
          icon: e.icon(context, this),
        );
      }
      return null;
    });
    if (subMenu.isNotEmpty) {
      return [
        VerticalDivider(
          width: 1,
          color: (widget.style?.borderColor ?? theme.colorScheme.outline)
              .withAlpha(128),
        ),
        ...subMenu,
      ];
    }
    return [];
  }

  Iterable<Widget> _buildInlineTools(
    BuildContext context,
    ThemeData theme,
    List<MarkdownInlineTools> tools,
  ) {
    return tools.map((e) {
      if (e.actived(context, this)) {
        return IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: widget.style?.activeBackgroundColor ??
                theme.colorTheme?.primary ??
                theme.colorScheme.primary,
            foregroundColor: widget.style?.activeColor ??
                theme.colorTheme?.onPrimary ??
                theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            e.onDeactive(context, this);
          },
          icon: e.icon(context, this),
        );
      } else {
        return IconButton(
          onPressed: () {
            e.onActive(context, this);
          },
          icon: e.icon(context, this),
        );
      }
    });
  }

  Iterable<Widget> _buildCustomTools(BuildContext context, ThemeData theme) {
    final customTools = widget.controller.customTools ?? [];
    return customTools.mapAndRemoveEmpty((e) {
      if (!e.shown(context, this)) {
        return null;
      }
      return IconButton(
        onPressed: e.enabled(context, this)
            ? () {
                e.onTap(context, this);
              }
            : null,
        icon: e.icon(context, this),
      );
    });
  }

  Widget _buildLinkDialog(BuildContext context, ThemeData theme) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: _blockMenuHeight,
      child: Container(
        color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
        height: _kLinkDialogHeight,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.title),
                16.sx,
                Expanded(
                  child: FormTextField(
                    controller: _linkSetting?.titleController,
                    hintText: widget.linkTitleHintText,
                    style: FormStyle(
                      borderStyle: FormInputBorderStyle.outline,
                      backgroundColor: widget.style?.subBackgroundColor ??
                          widget.style?.backgroundColor ??
                          theme.colorTheme?.surface,
                    ),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      _linkSetting?.updateTitle(value);
                    },
                  ),
                ),
                8.sx,
                IconButton(
                  onPressed: () {
                    // キャンセルボタンが押されたときにリンクを削除
                    controller.removeInlineProperty(
                      const LinkMarkdownInlineTools(),
                    );
                    _linkSetting?.cancel();
                    setState(() {
                      _linkSetting = null;
                    });
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.link),
                16.sx,
                Expanded(
                  child: FormTextField(
                    controller: _linkSetting?.urlController,
                    focusNode: _linkSetting?.focusNode,
                    hintText: widget.linkLinkHintText,
                    style: FormStyle(
                      borderStyle: FormInputBorderStyle.outline,
                      backgroundColor: widget.style?.subBackgroundColor ??
                          widget.style?.backgroundColor ??
                          theme.colorTheme?.surface,
                    ),
                  ),
                ),
                8.sx,
                IconButton(
                  onPressed: () {
                    _linkSetting?.submit();
                    setState(() {
                      _linkSetting = null;
                    });
                  },
                  icon: const Icon(Icons.check_circle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentionDialog(BuildContext context, ThemeData theme) {
    final height = context.mediaQuery.size.height -
        _blockMenuHeight -
        _kToolbarHeight -
        _kMentionDialogSpaceHeight -
        context.mediaQuery.viewPadding.bottom -
        context.mediaQuery.viewPadding.top;

    return Positioned(
      left: 0,
      right: 0,
      bottom: _blockMenuToggleDuration != null ? 0 : _blockMenuHeight,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
        ),
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: (widget.style?.borderColor ??
                              theme.colorTheme?.outline ??
                              theme.colorScheme.outline)
                          .withAlpha(128),
                    ),
                    bottom: BorderSide(
                      color: (widget.style?.borderColor ??
                              theme.colorTheme?.outline ??
                              theme.colorScheme.outline)
                          .withAlpha(128),
                    ),
                  ),
                ),
                child: ListenableBuilder(
                    listenable: _mentionSetting!.textEditingController,
                    builder: (context, child) {
                      final search = _mentionSetting!.textEditingController.text
                          .toLowerCase();
                      final mentions =
                          widget.mentionBuilder?.call(context).where((e) {
                                if (search.isEmpty) {
                                  return true;
                                }
                                return e.name.toLowerCase().contains(search) ||
                                    e.id.toLowerCase().contains(search);
                              }).toList() ??
                              [];
                      return ListView.builder(
                        itemCount: mentions.length,
                        padding: EdgeInsets.fromLTRB(
                          0,
                          16,
                          0,
                          16 + context.mediaQuery.viewPadding.bottom,
                        ),
                        itemBuilder: (context, index) {
                          final mention = mentions[index];
                          return GestureDetector(
                            onTap: () {
                              // メンションの追加
                              _mentionSetting?.focusNode.unfocus();
                              controller.insertMention(mention);
                              deleteMode();
                              controller.focusNode.requestFocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircleAvatar(
                                      backgroundImage: mention.avatar,
                                      backgroundColor:
                                          widget.style?.borderColor ??
                                              theme.colorScheme.outline,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      mention.name.trim().trimString("@"),
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                  Text(
                                    "@${mention.id.trim().trimString("@")}",
                                    textAlign: TextAlign.end,
                                    style: theme.textTheme.bodyMedium
                                        ?.withColor(widget.style?.subColor ??
                                            theme.disabledColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _mentionSetting?.focusNode.unfocus();
                      deleteMode();
                      controller.focusNode.requestFocus();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: FormTextField(
                      focusNode: _mentionSetting!.focusNode,
                      controller: _mentionSetting!.textEditingController,
                      hintText: widget.mentionHintText,
                      style: FormStyle(
                        borderStyle: FormInputBorderStyle.outline,
                        borderRadius: BorderRadius.circular(32),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        backgroundColor: widget.style?.subBackgroundColor ??
                            widget.style?.backgroundColor ??
                            theme.colorTheme?.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockTools(
    BuildContext context,
    ThemeData theme,
    List<MarkdownBlockTools> tools,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: (widget.style?.borderColor ??
                      theme.colorTheme?.outline ??
                      theme.colorScheme.outline)
                  .withAlpha(128),
            ),
          ),
        ),
        height: _blockMenuHeight,
        width: double.infinity,
        child: GridView.extent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3,
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + context.mediaQuery.viewPadding.bottom,
          ),
          children: [
            ...tools.map((e) {
              return InkWell(
                onTap: () {
                  e.onTap(context, this);
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.style?.subBackgroundColor ??
                        widget.style?.backgroundColor ??
                        theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: e.icon(context, this),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DefaultTextStyle(
                          style:
                              theme.textTheme.labelMedium ?? const TextStyle(),
                          child: e.label(context, this),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // collapsed時はオーバーフローを避けるために空のコンテナを返す
    if (widget.collapsed) {
      return const Empty();
    }

    _handledOnKeyboardStateChanged();
    final theme = Theme.of(context);

    // 追加コンテンツがない場合の最小高さはツールバーの高さのみ
    var height = _blockMenuHeight;
    if (_linkSetting != null) {
      height += _kLinkDialogHeight;
    } else if (_currentTool is MentionMarkdownPrimaryTools) {
      height += context.mediaQuery.size.height -
          _blockMenuHeight -
          _kToolbarHeight -
          _kMentionDialogSpaceHeight -
          context.mediaQuery.viewPadding.bottom -
          context.mediaQuery.viewPadding.top;
      if (_blockMenuToggleDuration != null) {
        height -= _blockMenuHeight;
      }
    }

    // ツールバーの高さのみを追加し、ブロックメニューの高さは含めない
    height += _kToolbarHeight;

    final inlineTools = _currentTool is MarkdownPrimaryTools
        ? (_currentTool as MarkdownPrimaryTools).inlineTools
        : null;
    final blockTools = _currentTool is MarkdownPrimaryTools
        ? (_currentTool as MarkdownPrimaryTools).blockTools
        : null;

    return IconTheme(
      data: IconThemeData(
        color: widget.style?.color ?? theme.colorTheme?.onBackground,
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.style?.color ?? theme.colorTheme?.onBackground,
            ) ??
            TextStyle(
              color: widget.style?.color ?? theme.colorTheme?.onBackground,
            ),
        child: AnimatedContainer(
          duration: _blockMenuToggleDuration ?? Duration.zero,
          curve: Curves.easeInOut,
          color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
          height: height,
          child: Stack(
            children: [
              if (blockTools != null) ...[
                _buildBlockTools(context, theme, blockTools),
              ],
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  color: widget.style?.backgroundColor ??
                      theme.colorTheme?.background,
                  height: _kToolbarHeight,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.controller.isShowingCustomTools) ...[
                                ..._buildCustomTools(context, theme),
                              ] else if (!(field?.selectInMentionLink ??
                                      false) &&
                                  inlineTools != null) ...[
                                ..._buildInlineTools(
                                    context, theme, inlineTools),
                              ] else ...[
                                ..._buildPrimaryTools(context, theme),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (!widget.controller.isShowingCustomTools) ...[
                        ..._buildSecondaryTools(context, theme),
                      ],
                    ],
                  ),
                ),
              ),
              if (_currentTool is MentionMarkdownPrimaryTools) ...[
                _buildMentionDialog(context, theme),
              ] else if (_linkSetting != null) ...[
                _buildLinkDialog(context, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A reference class for Markdown tools.
///
/// マークダウンのツールの参照クラス。
abstract class MarkdownToolRef {
  const MarkdownToolRef._();

  /// Toggle the mode.
  ///
  /// モードを切り替えます。
  void toggleMode(MarkdownPrimaryTools tool);

  /// Delete the mode.
  ///
  /// モードを削除します。
  void deleteMode();

  /// Close the keyboard.
  ///
  /// キーボードを閉じます。
  void closeKeyboard();

  /// Check if the text is selected.
  ///
  /// テキストが選択されているかどうかを確認します。
  bool get isTextSelected;

  /// Get the current mode.
  ///
  /// 現在のモードを取得します。
  MarkdownTools? get currentTool;

  /// Get the controller.
  ///
  /// コントローラーを取得します。
  MarkdownController get controller;

  /// Get the selection.
  ///
  /// 選択範囲を取得します。
  TextSelection? get selection;

  /// Get the field.
  ///
  /// フィールドを取得します。
  MarkdownFieldState? get field;

  /// Check if the keyboard should be shown.
  ///
  /// キーボードが表示されているかどうかを確認します。
  bool get isKeyboardShowing;

  /// Check if the clipboard can be pasted.
  ///
  /// クリップボードに貼り付け可能かどうかを確認します。
  bool get canPaste;

  /// Open the link dialog.
  ///
  /// リンクダイアログを開きます。
  void toggleLinkDialog([String? initialUrl]);

  /// Get the mention builder.
  ///
  /// メンションビルダーを取得します。
  List<MarkdownMention> Function(BuildContext context)? get mentionBuilder;

  /// Insert image.
  ///
  /// 画像を挿入します。
  MarkdownImageBlockValue? insertImage(Uri uri);

  /// Insert video.
  ///
  /// ビデオを挿入します。
  void insertVideo(Uri uri);

  /// Inserts a block at the specified offset.
  ///
  /// 指定されたオフセット位置にブロックを挿入します。
  TValue? insertBlock<TValue extends MarkdownBlockValue>(
    TValue block, {
    int? offset,
  });

  /// Exchanges a block at the specified index.
  ///
  /// 指定されたインデックスのブロックを交換します。
  TValue? exchangeBlock<TValue extends MarkdownBlockValue>(
    TValue block, {
    int? index,
  });
}

class _LinkSetting {
  _LinkSetting({
    required this.field,
    required this.controller,
    String? initialUrl,
  }) {
    // 現在選択されているテキストとリンクURLで初期化
    final selection = field._selection;

    if (selection.isValid && !selection.isCollapsed) {
      final text = controller.rawText;

      final selectedText = selection.textInside(text);

      titleController.text = selectedText;

      // initialUrlが提供されている場合は使用し、そうでない場合は既存のリンクを検索
      if (initialUrl != null) {
        _currentLinkUrl = initialUrl;
        urlController.text = initialUrl;
      } else {
        // 選択範囲内の既存のリンクプロパティを検索
        _currentLinkUrl = _getLinkUrlFromSelection();

        if (_currentLinkUrl != null) {
          urlController.text = _currentLinkUrl!;
        }
      }
    } else {
      markdownDebugPrint("Selection is invalid or collapsed");
    }
  }

  final MarkdownFieldState field;
  final MarkdownController controller;
  final FocusNode focusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  String? _currentLinkUrl;

  String? _getLinkUrlFromSelection() {
    final selection = field._selection;
    if (!selection.isValid || selection.isCollapsed) {
      return null;
    }

    final selectionStart = selection.start;
    final selectionEnd = selection.end;

    if (controller.value?.isEmpty ?? true) {
      return null;
    }

    final fieldValue = controller.value!.first;
    var currentOffset = 0;

    for (final block in fieldValue.children) {
      if (block is MarkdownMultiLineBlockValue) {
        for (final line in block.children) {
          for (final span in line.children) {
            final spanStart = currentOffset;
            final spanEnd = currentOffset + span.value.length;

            // このスパンが選択範囲と重複しているかをチェック
            if (selectionEnd > spanStart && selectionStart < spanEnd) {
              // リンクプロパティを検索
              for (final property in span.properties) {
                if (property is LinkMarkdownSpanProperty) {
                  return property.link;
                }
              }
            }

            currentOffset += span.value.length;
          }
        }
        currentOffset += 1; // 改行
      }
    }

    return null;
  }

  void updateTitle(String title) {
    controller.updateLinkTitle(title);
  }

  void updateUrl(String? url) {
    _currentLinkUrl = url;
    controller.updateLinkUrl(url);
  }

  void submit() {
    // URLが空でない場合はリンクを適用
    if (urlController.text.isNotEmpty) {
      updateUrl(urlController.text);
    }
  }

  void cancel() {
    focusNode.dispose();
    titleController.dispose();
    urlController.dispose();
  }
}

class _MentionSetting {
  _MentionSetting({
    required this.field,
  });

  final MarkdownFieldState field;
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void cancel() {
    textEditingController.dispose();
    focusNode.dispose();
  }
}
