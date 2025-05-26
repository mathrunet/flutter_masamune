part of '/masamune_markdown.dart';

const _kToolbarHeight = kToolbarHeight;
const _kMinChangeSize = 16.0;

class MarkdownToolbar extends StatefulWidget {
  const MarkdownToolbar({
    super.key,
    required this.controller,
    this.exchangeIcon = Icons.repeat,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.mentionBuilder,
  });

  final MarkdownController controller;
  final IconData exchangeIcon;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<MarkdownMention> Function(BuildContext context)? mentionBuilder;

  @override
  State<MarkdownToolbar> createState() => _MarkdownToolbarState();
}

class _MarkdownToolbarState extends State<MarkdownToolbar>
    with WidgetsBindingObserver
    implements MarkdownToolRef {
  bool _isKeyboardHidden = false;
  bool _showSelectedMenu = false;
  bool _showBlockMenu = false;
  double _blockMenuHeight = 0;
  double _lastBottomInset = 0;

  _LinkSetting? _textLink;

  final TextEditingController _mentionController = TextEditingController();
  final ClipboardMonitor _clipboardMonitor = ClipboardMonitor();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerStateOnChanged);
    WidgetsBinding.instance.addObserver(this);
    _clipboardMonitor.monitorClipboard(true, _handledClipboardStateOnChanged);
  }

  @override
  void dispose() {
    _clipboardMonitor.monitorClipboard(false, _handledClipboardStateOnChanged);
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_handleControllerStateOnChanged);
    _mentionController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final currentBottomInset = context.mediaQuery.viewInsets.bottom;
    final isKeyboardShowing =
        _lastBottomInset + _kMinChangeSize < currentBottomInset;
    if (_isKeyboardHidden && _lastBottomInset == 0 && currentBottomInset > 0) {
      _isKeyboardHidden = false;
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

  @override
  MarkdownToolMain? get currentMode => _currentMode;
  MarkdownToolMain? _currentMode;

  @override
  bool get canPaste => _clipboardMonitor.canPaste;

  @override
  bool get isKeyboardShowing =>
      _showBlockMenu || context.mediaQuery.viewInsets.bottom > 0;

  FormMarkdownFieldState? get focuedState {
    return widget.controller._states.firstWhereOrNull(
      (state) => state._effectiveFocusNode.hasFocus,
    );
  }

  @override
  TextSelection? get focusedSelection {
    final state = focuedState;
    if (state == null) {
      return null;
    }
    return state._controller.selection;
  }

  @override
  bool get isTextSelected {
    final selection = focusedSelection;
    if (selection == null) {
      return false;
    }
    return selection.isValid && !selection.isCollapsed;
  }

  @override
  QuillController? get focusedController {
    final state = focuedState;
    if (state == null) {
      return null;
    }
    return state._controller;
  }

  @override
  void toggleMode(MarkdownToolMain mode) {
    setState(() {
      if (mode == _currentMode) {
        if (_showBlockMenu) {
          _showBlockMenu = false;
          SystemChannels.textInput.invokeMethod("TextInput.show");
        } else {
          if (mode.hideKeyboardOnSelected) {
            _showBlockMenu = true;
            SystemChannels.textInput.invokeMethod("TextInput.hide");
          }
        }
        _currentMode = mode;
      } else {
        if (_showBlockMenu) {
          if (!mode.hideKeyboardOnSelected) {
            _showBlockMenu = false;
            SystemChannels.textInput.invokeMethod("TextInput.show");
          }
        } else {
          if (mode.hideKeyboardOnSelected) {
            _showBlockMenu = true;
            SystemChannels.textInput.invokeMethod("TextInput.hide");
          }
        }
        _currentMode = mode;
      }
    });
  }

  @override
  void toggleLinkDialog() {
    if (_textLink != null) {
      setState(() {
        _textLink = null;
      });
    } else {
      final controller = focusedController;
      if (controller == null) {
        return;
      }
      setState(() {
        _textLink = _LinkSetting(controller: controller);
        _textLink?.focusNode.requestFocus();
      });
    }
  }

  @override
  void deleteMode() {
    setState(() {
      _currentMode = null;
    });
  }

  @override
  void closeKeyboard() {
    setState(() {
      _isKeyboardHidden = true;
      _showBlockMenu = false;
      _blockMenuHeight = 0;
      focuedState?._effectiveFocusNode.unfocus();
      SystemChannels.textInput.invokeMethod("TextInput.hide");
    });
  }

  @override
  bool activeAttribute(Attribute attribute) {
    final selection = focusedSelection;
    if (selection == null) {
      return false;
    }
    return focusedController
            ?.getSelectionStyle()
            .values
            .any((e) => e.key == attribute.key) ??
        false;
  }

  void _handleControllerStateOnChanged() {
    if (_showSelectedMenu != isTextSelected) {
      setState(() {
        _showSelectedMenu = isTextSelected;
        if (!isTextSelected) {
          _textLink = null;
        }
      });
    }
    if (_currentMode == MarkdownToolMain.mention &&
        _showBlockMenu &&
        (focuedState?.cursorInLink ?? false)) {
      toggleMode(MarkdownToolMain.mention);
    }
  }

  void _handledClipboardStateOnChanged() {
    setState(() {});
  }

  Iterable<Widget> _buildMainMenu(BuildContext context, ThemeData theme) {
    return MarkdownToolMain.values.map((e) {
      if (!e.enabled(context, this) || !e.active(context, this)) {
        return IconButton(
          onPressed: null,
          icon: Icon(e.icon(context)),
        );
      } else {
        final controller = focuedState?._controller;
        if (e == MarkdownToolMain.mention && controller != null) {
          if (_currentMode == e && _showBlockMenu) {
            return ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  return IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorTheme?.primary ??
                          theme.colorScheme.primary,
                      foregroundColor: theme.colorTheme?.onPrimary ??
                          theme.colorScheme.onPrimary,
                    ),
                    onPressed: (focuedState?.cursorInLink ?? false)
                        ? null
                        : () {
                            e.onTap(context, this);
                          },
                    icon: Icon(e.icon(context)),
                  );
                });
          } else {
            return ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                return IconButton(
                  onPressed: (focuedState?.cursorInLink ?? false)
                      ? null
                      : () {
                          e.onTap(context, this);
                        },
                  icon: Icon(e.icon(context)),
                );
              },
            );
          }
        } else {
          if (_currentMode == e && _showBlockMenu) {
            return IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor:
                    theme.colorTheme?.primary ?? theme.colorScheme.primary,
                foregroundColor:
                    theme.colorTheme?.onPrimary ?? theme.colorScheme.onPrimary,
              ),
              onPressed: () {
                e.onTap(context, this);
              },
              icon: Icon(e.icon(context)),
            );
          } else {
            return IconButton(
              onPressed: () {
                e.onTap(context, this);
              },
              icon: Icon(e.icon(context)),
            );
          }
        }
      }
    });
  }

  Iterable<Widget> _buildSubMenu(BuildContext context, ThemeData theme) {
    final subMenu = MarkdownToolSub.values.mapAndRemoveEmpty((e) {
      if (e.show(context, this)) {
        return IconButton(
          onPressed: () {
            e.onTap(context, this);
          },
          icon: Icon(e.icon(context)),
        );
      }
      return null;
    });
    if (subMenu.isNotEmpty) {
      return [
        VerticalDivider(
          width: 1,
          color: theme.colorScheme.outline.withAlpha(128),
        ),
        ...subMenu,
      ];
    }
    return [];
  }

  Iterable<Widget> _buildFontMenu(BuildContext context, ThemeData theme) {
    return MarkdownToolFont.values.map((e) {
      if (e.active(context, this)) {
        return IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor:
                theme.colorTheme?.primary ?? theme.colorScheme.primary,
            foregroundColor:
                theme.colorTheme?.onPrimary ?? theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            e.onDeactive(context, this);
          },
          icon: Icon(e.icon(context)),
        );
      } else {
        return IconButton(
          onPressed: () {
            e.onActive(context, this);
          },
          icon: Icon(e.icon(context)),
        );
      }
    });
  }

  Widget _buildLinkDialog(BuildContext context, ThemeData theme) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: _blockMenuHeight,
      child: Container(
        color: theme.colorTheme?.background,
        height: _kToolbarHeight * 2,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.title),
                16.sx,
                Expanded(
                  child: FormTextField(
                    initialValue: _textLink?.link.text,
                    style: FormStyle(
                      borderStyle: FormInputBorderStyle.outline,
                    ),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      _textLink?.link = QuillTextLink(
                        value.trim(),
                        _textLink?.link.link?.trim(),
                      );
                    },
                  ),
                ),
                8.sx,
                IconButton(
                  onPressed: () {
                    _textLink?.cancel();
                    _textLink = null;
                  },
                  icon: Icon(Icons.cancel_outlined),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.link),
                16.sx,
                Expanded(
                  child: FormTextField(
                    focusNode: _textLink?.focusNode,
                    initialValue: _textLink?.link.link,
                    style: FormStyle(
                      borderStyle: FormInputBorderStyle.outline,
                    ),
                    onChanged: (value) {
                      _textLink?.link = QuillTextLink(
                        _textLink?.link.text.trim() ?? "",
                        value?.trim(),
                      );
                    },
                  ),
                ),
                8.sx,
                IconButton(
                  onPressed: () {
                    _textLink?.submit();
                    setState(() {
                      _textLink = null;
                    });
                  },
                  icon: Icon(Icons.check_circle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMenu(BuildContext context, ThemeData theme) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: widget.borderColor ??
                  theme.colorTheme?.outline.withAlpha(128) ??
                  theme.colorScheme.outline.withAlpha(128),
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
              16, 16, 16, 16 + context.mediaQuery.viewPadding.bottom),
          children: [
            ...MarkdownToolAdd.values.map((e) {
              return InkWell(
                onTap: () {
                  e.onTap(context, this);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Icon(
                            e.icon(context),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(e.label(context)),
                      ),
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

  Widget _buildExchangeMenu(BuildContext context, ThemeData theme) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: widget.borderColor ??
                  theme.colorTheme?.outline.withAlpha(128) ??
                  theme.colorScheme.outline.withAlpha(128),
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
              16, 16, 16, 16 + context.mediaQuery.viewPadding.bottom),
          children: [
            ...MarkdownToolExchange.values.map((e) {
              return InkWell(
                onTap: () {
                  e.onTap(context, this);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Icon(
                            e.icon(context),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(e.label(context)),
                      ),
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

  Widget _buildMentionMenu(BuildContext context, ThemeData theme) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: widget.borderColor ??
                  theme.colorTheme?.outline.withAlpha(128) ??
                  theme.colorScheme.outline.withAlpha(128),
            ),
          ),
        ),
        height: _blockMenuHeight,
        width: double.infinity,
        child: ListenableBuilder(
            listenable: _mentionController,
            builder: (context, child) {
              final search = _mentionController.text.toLowerCase();
              final mentions = widget.mentionBuilder?.call(context).where((e) {
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
                    0, 16, 0, 16 + context.mediaQuery.viewPadding.bottom),
                itemBuilder: (context, index) {
                  final mention = mentions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: mention.avatar,
                      backgroundColor: theme.colorScheme.outline,
                    ),
                    title: Text(mention.name.trim().trimString("@")),
                    subtitle: Text("@${mention.id.trim().trimString("@")}"),
                    onTap: () {
                      final controller = focusedController;
                      if (controller == null) {
                        return;
                      }
                      controller.insertMention(mention);
                      toggleMode(MarkdownToolMain.mention);
                    },
                  );
                },
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconTheme(
      data: IconThemeData(
        color: widget.color ?? theme.colorTheme?.onBackground,
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.color ?? theme.colorTheme?.onBackground,
            ) ??
            TextStyle(
              color: widget.color ?? theme.colorTheme?.onBackground,
            ),
        child: Container(
          color: widget.backgroundColor ?? theme.colorTheme?.background,
          height: _blockMenuHeight +
              (_textLink != null ? _kToolbarHeight * 2 : _kToolbarHeight),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: _blockMenuHeight,
                child: SizedBox(
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
                              if (!(focuedState?._selectInMentionLink ??
                                      false) &&
                                  (_showSelectedMenu ||
                                      _currentMode ==
                                          MarkdownToolMain.font)) ...[
                                ..._buildFontMenu(context, theme),
                              ] else ...[
                                ..._buildMainMenu(context, theme),
                              ],
                            ],
                          ),
                        ),
                      ),
                      ..._buildSubMenu(context, theme),
                    ],
                  ),
                ),
              ),
              if (_textLink != null) ...[
                _buildLinkDialog(context, theme),
              ],
              if (_currentMode == MarkdownToolMain.add) ...[
                _buildAddMenu(context, theme),
              ] else if (_currentMode == MarkdownToolMain.mention) ...[
                _buildMentionMenu(context, theme),
              ] else if (_currentMode == MarkdownToolMain.exchange) ...[
                _buildExchangeMenu(context, theme),
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
  /// Get the focused selection.
  ///
  /// フォーカスされている選択範囲を取得します。
  TextSelection? get focusedSelection;

  /// Check if the text is selected.
  ///
  /// テキストが選択されているかどうかを確認します。
  bool get isTextSelected;

  /// Toggle the mode.
  ///
  /// モードを切り替えます。
  void toggleMode(MarkdownToolMain mode);

  /// Delete the mode.
  ///
  /// モードを削除します。
  void deleteMode();

  /// Close the keyboard.
  ///
  /// キーボードを閉じます。
  void closeKeyboard();

  /// Get the focused state.
  ///
  /// フォーカスされている状態を取得します。
  FormMarkdownFieldState? get focuedState;

  /// Get the controller.
  ///
  /// コントローラーを取得します。
  QuillController? get focusedController;

  /// Check if the attribute is active.
  ///
  /// 属性がアクティブかどうかを確認します。
  bool activeAttribute(Attribute attribute);

  /// Get the current mode.
  ///
  /// 現在のモードを取得します。
  MarkdownToolMain? get currentMode;

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
  void toggleLinkDialog();
}

class _LinkSetting {
  _LinkSetting({
    required this.controller,
  }) {
    link = QuillTextLink.prepare(controller);
  }

  final QuillController controller;
  late QuillTextLink link;
  final FocusNode focusNode = FocusNode();

  void submit() {
    if (link.link.isEmpty) {
      final index = controller.selection.start;
      final length = controller.selection.end - index;
      controller
        ..replaceText(index, length, link.text, null)
        ..removeFormatSelection(Attribute.link);
    } else {
      link.submit(controller);
    }
  }

  void cancel() {
    focusNode.dispose();
  }
}
