part of "/masamune_markdown.dart";

/// A field for editing Markdown content with block-based structure.
///
/// ブロックベースの構造でMarkdownコンテンツを編集するフィールド。
class MarkdownField extends StatefulWidget {
  /// Creates a [MarkdownField].
  ///
  /// [MarkdownField]を作成します。
  const MarkdownField({
    required this.controller,
    super.key,
    this.focusNode,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.scrollable = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionControls,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.scrollController,
    this.scrollPhysics,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.onTapLink,
    this.onTapMention,
    this.enabled,
    this.rendererIgnoresPointer = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.contextMenuBuilder,
    this.onLongPress,
    this.onDoubleTap,
  });

  /// Controller for the markdown editor.
  ///
  /// Markdownエディタのコントローラー。
  final MarkdownController controller;

  /// Focus node for the editor.
  ///
  /// エディタのフォーカスノード。
  final FocusNode? focusNode;

  /// Whether the text field is read-only.
  ///
  /// テキストフィールドが読み取り専用かどうか。
  final bool readOnly;

  /// Whether the text field should be autofocused.
  ///
  /// テキストフィールドがオートフォーカスされるべきかどうか。
  final bool autofocus;

  /// Whether to obscure the text being edited.
  ///
  /// 編集中のテキストを隠すかどうか。
  final bool obscureText;

  /// Whether to enable autocorrect.
  ///
  /// オートコレクトを有効にするかどうか。
  final bool autocorrect;

  /// Whether to enable suggestions.
  ///
  /// サジェストを有効にするかどうか。
  final bool enableSuggestions;

  /// Maximum number of lines.
  ///
  /// 最大行数。
  final int? maxLines;

  /// Minimum number of lines.
  ///
  /// 最小行数。
  final int? minLines;

  /// Whether the field should expand to fill the parent.
  ///
  /// フィールドが親を埋めるように拡張すべきかどうか。
  final bool expands;

  /// Whether the field should be scrollable.
  ///
  /// フィールドがスクロール可能かどうか。
  final bool scrollable;

  /// Text alignment.
  ///
  /// テキストの配置。
  final TextAlign textAlign;

  /// Text direction.
  ///
  /// テキストの方向。
  final TextDirection? textDirection;

  /// Cursor width.
  ///
  /// カーソルの幅。
  final double cursorWidth;

  /// Cursor height.
  ///
  /// カーソルの高さ。
  final double? cursorHeight;

  /// Cursor radius.
  ///
  /// カーソルの半径。
  final Radius? cursorRadius;

  /// Cursor color.
  ///
  /// カーソルの色。
  final Color? cursorColor;

  /// Selection color.
  ///
  /// 選択色。
  final Color? selectionColor;

  /// Selection controls.
  ///
  /// 選択コントロール。
  final TextSelectionControls? selectionControls;

  /// Keyboard type.
  ///
  /// キーボードタイプ。
  final TextInputType? keyboardType;

  /// Text input action.
  ///
  /// テキスト入力アクション。
  final TextInputAction? textInputAction;

  /// Text capitalization.
  ///
  /// テキストの大文字化。
  final TextCapitalization textCapitalization;

  /// Text style.
  ///
  /// テキストスタイル。
  final TextStyle? style;

  /// Strut style.
  ///
  /// ストラットスタイル。
  final StrutStyle? strutStyle;

  /// Text width basis.
  ///
  /// テキスト幅の基準。
  final TextWidthBasis textWidthBasis;

  /// Text height behavior.
  ///
  /// テキストの高さの動作。
  final TextHeightBehavior? textHeightBehavior;

  /// Scroll controller.
  ///
  /// スクロールコントローラー。
  final ScrollController? scrollController;

  /// Scroll physics.
  ///
  /// スクロール物理演算。
  final ScrollPhysics? scrollPhysics;

  /// Called when the text changes.
  ///
  /// テキストが変更されたときに呼ばれます。
  final ValueChanged<List<MarkdownFieldValue>>? onChanged;

  /// Called when editing is complete.
  ///
  /// 編集が完了したときに呼ばれます。
  final VoidCallback? onEditingComplete;

  /// Called when the user submits.
  ///
  /// ユーザーが送信したときに呼ばれます。
  final ValueChanged<List<MarkdownFieldValue>>? onSubmitted;

  /// Called when the user taps.
  ///
  /// ユーザーがタップしたときに呼ばれます。
  final VoidCallback? onTap;

  /// Called when the user taps a link.
  ///
  /// ユーザーがリンクをタップしたときに呼ばれます。
  final void Function(Uri link)? onTapLink;

  /// Called when the user taps a mention.
  ///
  /// ユーザーがメンションをタップしたときに呼ばれます。
  final void Function(MarkdownMention mention)? onTapMention;

  /// Called when the user taps outside.
  ///
  /// ユーザーが外側をタップしたときに呼ばれます。
  final TapRegionCallback? onTapOutside;

  /// Whether the field is enabled.
  ///
  /// フィールドが有効かどうか。
  final bool? enabled;

  /// Whether the renderer ignores pointer events.
  ///
  /// レンダラーがポインタイベントを無視するかどうか。
  final bool rendererIgnoresPointer;

  /// Padding for scrolling to reveal the cursor.
  ///
  /// カーソルを表示するためのスクロール時のパディング。
  final EdgeInsets scrollPadding;

  /// Whether to enable interactive selection.
  ///
  /// インタラクティブ選択を有効にするかどうか。
  final bool enableInteractiveSelection;

  /// Builder for the context menu.
  ///
  /// コンテキストメニューのビルダー。
  final Widget Function(
    BuildContext context,
    TextSelectionDelegate delegate,
  )? contextMenuBuilder;

  /// Called when a long press is detected.
  ///
  /// 長押しが検出されたときに呼ばれます。
  final void Function(Offset globalPosition)? onLongPress;

  /// Called when a double tap is detected.
  ///
  /// ダブルタップが検出されたときに呼ばれます。
  final void Function(Offset globalPosition)? onDoubleTap;

  @override
  State<MarkdownField> createState() => MarkdownFieldState();
}

/// State for MarkdownField.
///
/// MarkdownFieldのステート。
class MarkdownFieldState extends State<MarkdownField>
    with TickerProviderStateMixin
    implements TextInputClient, TextSelectionDelegate {
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  TextInputConnection? _textInputConnection;

  /// Whether to cursor in link.
  ///
  /// カーソルがリンク内にあるかどうか。
  bool get cursorInLink {
    if (_selection.isCollapsed) {
      final cursorOffset = _selection.baseOffset;
      final linkRange = _getLinkRangeAtOffset(cursorOffset);
      return linkRange != null;
    }
    return false;
  }

  /// Whether to select in mention link.
  ///
  /// メンションリンクを選択するかどうか。
  bool get selectInMentionLink {
    if (_selection.isCollapsed) {
      final cursorOffset = _selection.baseOffset;
      final mentionRange = _getMentionRangeAtOffset(cursorOffset);
      return mentionRange != null;
    }
    return false;
  }

  bool get _hasInputConnection =>
      _textInputConnection != null && _textInputConnection!.attached;

  // 選択状態
  TextSelection _selection = const TextSelection.collapsed(offset: 0);
  TextSelection? _composingRegion;

  // IME入力中の変換テキストを追跡
  String? _composingText;

  /// Returns the current composing text during IME input, or null if not composing.
  ///
  /// IME入力中の変換テキストを返します。変換中でない場合はnullを返します。
  String? get composingText => _composingText;

  // カーソルの点滅を追跡するため
  bool _showCursor = true;
  AnimationController? _cursorBlinkController;

  // コンテキストメニューオーバーレイ
  OverlayEntry? _contextMenuOverlay;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? widget.controller.focusNode;
    _scrollController = widget.scrollController ?? ScrollController();
    widget.controller._registerField(this);

    // readonly時は入力関連の処理をスキップ
    if (!widget.readOnly) {
      _focusNode.addListener(_handleFocusChanged);
    }
    widget.controller.addListener(_handleControllerChanged);

    // readonly時はカーソル点滅を無効化
    if (!widget.readOnly) {
      _cursorBlinkController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..addListener(_onCursorBlink);
    }
  }

  @override
  void didUpdateWidget(MarkdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      _focusNode = widget.focusNode ?? widget.controller.focusNode;
      _focusNode.addListener(_handleFocusChanged);
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller._unregisterField(this);
      widget.controller._registerField(this);
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _hideContextMenu();
    _closeInputConnectionIfNeeded();
    // readonly時はカーソルコントローラーが存在しない
    _cursorBlinkController?.dispose();
    widget.controller._unregisterField(this);
    // readonly時はリスナーが登録されていない
    if (!widget.readOnly) {
      _focusNode.removeListener(_handleFocusChanged);
    }
    widget.controller.removeListener(_handleControllerChanged);
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _hideContextMenu() {
    _contextMenuOverlay?.remove();
    _contextMenuOverlay = null;
  }

  void _showContextMenu(Offset globalPosition) {
    _hideContextMenu();

    if (widget.contextMenuBuilder == null) {
      return;
    }

    final overlay = Overlay.of(context);

    _contextMenuOverlay = OverlayEntry(
      builder: (context) {
        return widget.contextMenuBuilder!(
          context,
          this,
        );
      },
    );

    overlay.insert(_contextMenuOverlay!);
  }

  void _onCursorBlink() {
    setState(() {
      _showCursor = (_cursorBlinkController?.value ?? 0) < 0.5;
    });
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _openInputConnection();
      _showCursor = true;
      _cursorBlinkController?.reset();
      _cursorBlinkController?.repeat();
    } else {
      _closeInputConnectionIfNeeded();
      _cursorBlinkController?.stop();
      _showCursor = false;
    }
    setState(() {});
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  void _openInputConnection() {
    // readonly時は入力接続を開かない
    if (widget.readOnly) {
      return;
    }

    if (!_hasInputConnection) {
      final textInputConfiguration = TextInputConfiguration(
        inputType: widget.keyboardType ?? TextInputType.multiline,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        inputAction: widget.textInputAction ?? TextInputAction.newline,
        textCapitalization: widget.textCapitalization,
        keyboardAppearance: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
      );
      _textInputConnection = TextInput.attach(this, textInputConfiguration);
      _textInputConnection!.show();
      _updateRemoteEditingValue();
    }
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection!.close();
      _textInputConnection = null;
    }
  }

  void _updateRemoteEditingValue() {
    if (!_hasInputConnection) {
      return;
    }

    final text = _getPlainText();
    final textLength = text.length;

    // リンク/メンションと部分的に重なる場合は選択を自動調整
    // ダブルタップとハンドルドラッグ操作による選択変更をキャッチ
    var adjustedSelection = _selection;
    if (!_selection.isCollapsed) {
      final adjusted = _adjustSelectionForLinksAndMentions(_selection);
      if (adjusted != _selection) {
        adjustedSelection = adjusted;
        _selection = adjusted; // Update internal state
      }
    }

    // 選択と変換領域を有効なテキスト範囲にクランプ
    // IME状態を保持するため、実際に範囲外の場合のみクランプ
    final clampedSelection = TextSelection(
      baseOffset: adjustedSelection.baseOffset.clamp(0, textLength),
      extentOffset: adjustedSelection.extentOffset.clamp(0, textLength),
    );

    final clampedComposing = _composingRegion != null &&
            _composingRegion!.start <= textLength &&
            _composingRegion!.end <= textLength
        ? TextRange(
            start: _composingRegion!.start,
            end: _composingRegion!.end,
          )
        : (_composingRegion != null
            ? TextRange(
                start: _composingRegion!.start.clamp(0, textLength),
                end: _composingRegion!.end.clamp(0, textLength),
              )
            : TextRange.empty);

    _textInputConnection!.setEditingState(
      TextEditingValue(
        text: text,
        selection: clampedSelection,
        composing: clampedComposing,
      ),
    );
  }

  /// Adjusts the selection to ensure links and mentions are selected as a whole
  /// or not at all. If the selection partially overlaps with a link or mention,
  /// it will be expanded to include the entire link/mention or contracted to exclude it.
  ///
  /// リンクやメンションが全体として選択されるか、まったく選択されないように選択範囲を調整します。
  TextSelection _adjustSelectionForLinksAndMentions(TextSelection selection) {
    if (selection.isCollapsed || widget.controller.value == null) {
      return selection;
    }

    var adjustedStart = selection.start;
    var adjustedEnd = selection.end;
    var adjusted = false;

    // ドキュメント内のすべてのリンクとメンション範囲を取得
    final ranges = <TextRange>[];

    // ドキュメントを走査してすべてのリンクとメンションを検索
    if (widget.controller.value!.isNotEmpty) {
      final field = widget.controller.value!.first;
      final blocks = field.children;
      var currentOffset = 0;

      for (final block in blocks) {
        if (block is MarkdownMultiLineBlockValue) {
          for (final line in block.children) {
            for (final span in line.children) {
              final spanStart = currentOffset;
              final spanEnd = currentOffset + span.value.length;

              // このスパンがリンクまたはメンションプロパティを持つかチェック
              var hasLinkOrMention = false;
              for (final property in span.properties) {
                if (property is LinkMarkdownSpanProperty ||
                    property is MentionMarkdownSpanProperty) {
                  hasLinkOrMention = true;
                  break;
                }
              }

              if (hasLinkOrMention) {
                ranges.add(TextRange(start: spanStart, end: spanEnd));
              }

              currentOffset += span.value.length;
            }
          }
          currentOffset += 1; // newline
        }
      }
    }

    // 各リンク/メンション範囲をチェック
    for (final range in ranges) {
      // 選択がこの範囲と部分的に重なるかチェック
      final selectionOverlapsRange =
          selection.end > range.start && selection.start < range.end;

      if (selectionOverlapsRange) {
        final isFullySelected =
            selection.start <= range.start && selection.end >= range.end;

        if (!isFullySelected) {
          // 部分的な重なり - 拡張するか縮小するか決定

          // 重なり量を計算
          final overlapStart =
              selection.start > range.start ? selection.start : range.start;
          final overlapEnd =
              selection.end < range.end ? selection.end : range.end;
          final overlapLength = overlapEnd - overlapStart;
          final rangeLength = range.end - range.start;

          // 半分以上が選択されている場合、全範囲を含むように拡張
          // それ以外の場合は、除外するために縮小
          if (overlapLength > rangeLength / 2) {
            // リンク/メンション全体を含むように選択を拡張
            if (range.start < adjustedStart) {
              adjustedStart = range.start;
              adjusted = true;
            }
            if (range.end > adjustedEnd) {
              adjustedEnd = range.end;
              adjusted = true;
            }
          } else {
            // リンク/メンションを除外するために選択を縮小
            if (selection.start < range.end && selection.start >= range.start) {
              // 選択が範囲内から始まる - 開始を範囲の後に移動
              adjustedStart = range.end;
              adjusted = true;
            }
            if (selection.end > range.start && selection.end <= range.end) {
              // 選択が範囲内で終わる - 終了を範囲の前に移動
              adjustedEnd = range.start;
              adjusted = true;
            }
          }
        }
      }
    }

    if (adjusted) {
      return TextSelection(
        baseOffset: adjustedStart,
        extentOffset: adjustedEnd,
      );
    }

    return selection;
  }

  /// Reopens the input connection even if one already exists.
  /// This is useful when the connection was hidden but not closed (e.g., by TextInput.hide).
  ///
  /// 既存の接続がある場合でも入力接続を再開します。
  /// 接続が非表示になったが閉じられていない場合（例: TextInput.hideによる）に便利です。
  void reopenInputConnection() {
    // 既存の接続がある場合は閉じる
    _closeInputConnectionIfNeeded();
    // 新しい接続を開く
    _openInputConnection();
  }

  /// Clears the IME composing state.
  ///
  /// This should be called when operations like undo/redo need to
  /// completely reset the IME state.
  ///
  /// IME変換状態をクリアします。
  ///
  /// Undo/Redoのような操作でIME状態を完全にリセットする必要がある場合に呼び出します。
  void clearComposingState() {
    _composingText = null;
    _composingRegion = null;
  }

  // TextInputClientの実装
  @override
  void updateEditingValue(TextEditingValue value) {
    if (widget.readOnly) {
      return;
    }

    // 実際の現在のテキストを取得
    // IME変換中は_composingTextが利用可能な場合はそれを使用
    // そうでない場合はコントローラーのテキストを使用
    final oldText = _composingText ?? widget.controller.rawText;
    final newText = value.text;

    // 現在変換中かチェック
    final isComposing = value.composing.isValid && value.composing.start != -1;

    if (oldText != newText) {
      // テキストが変更された

      if (isComposing) {
        // IME変換中は_composingTextとコントローラーの両方を更新
        // これによりIME入力中のブロック構造が保持される
        _composingText = newText;
        _selection = value.selection;
        _composingRegion = TextSelection(
          baseOffset: value.composing.start,
          extentOffset: value.composing.end,
        );

        // 差分を見つけてコントローラーを更新
        final diff = _findTextDifference(
          oldText: oldText,
          newText: newText,
          selection: value.selection,
        );

        final replacementText = newText.substring(diff.start, diff.newEnd);

        // ブロック構造を維持するためにコントローラーを更新
        widget.controller.replaceText(diff.start, diff.oldEnd, replacementText);

        // 変換テキストを表示するために再構築をトリガー
        setState(() {});
      } else {
        // 変換終了または通常のテキスト入力 - コントローラーを更新

        // 差分を見つける - カーソル位置を考慮した改善版
        final diff = _findTextDifference(
          oldText: oldText,
          newText: newText,
          selection: value.selection,
        );

        // diffから変数を展開
        var start = diff.start;
        final oldEnd = diff.oldEnd;
        final newEnd = diff.newEnd;

        final replacementText = newText.substring(start, newEnd);

        // 置換テキストに改行が含まれているかチェック
        if (replacementText.contains("\n")) {
          // 改行で分割して一つずつ挿入
          final lines = replacementText.split("\n");

          // まず、古いテキストがある場合は削除
          if (oldEnd > start) {
            widget.controller.replaceText(start, oldEnd, "");
          }

          // カーソル位置に最初の行を挿入
          if (lines.isNotEmpty && lines.first.isNotEmpty) {
            widget.controller.replaceText(start, start, lines.first);
            start += lines.first.length;
          }

          // 追加の各行に対して新しい段落を挿入
          for (var i = 1; i < lines.length; i++) {
            widget.controller.insertNewLine(start);

            if (lines[i].isNotEmpty) {
              // テキストがある場合、改行の後に挿入
              start++; // 改行文字の分だけ進める
              widget.controller.replaceText(start, start, lines[i]);
              start += lines[i].length;
            } else {
              // 空行の場合
              // 改行のみの挿入の場合も、カーソルは改行の後（新しいブロックの先頭）に移動する
              start++; // 改行文字の分だけ進める
            }
          }

          // カーソル位置を挿入されたテキストの末尾に更新
          _selection = TextSelection.collapsed(offset: start);
          // 改行後に変換領域をクリア
          _composingRegion = null;
        } else {
          // リンクの末尾でのバックスペース/削除操作かチェック
          final isDeletion = replacementText.isEmpty && oldEnd > start;

          // 値から新しいカーソル位置を使用、または現在の選択にフォールバック
          final cursorOffset = value.selection.isCollapsed
              ? value.selection.baseOffset
              : value.selection.end;

          // カーソルが折りたたまれている場合のみリンク/メンション削除をチェック（選択なし）
          // かつ、まだリンク/メンション範囲を選択していない
          if (isDeletion && value.selection.isCollapsed) {
            // まず、カーソルの直前の文字がプレーンテキストかチェック
            // その場合、リンク/メンションチェックをスキップして通常の削除を許可
            var isPlainTextBeforeCursor = false;

            if (cursorOffset > 0) {
              // カーソルがリンクまたはメンション内または末尾にあるかチェック
              final linkRange =
                  widget.controller.getLinkRangeBeforeCursor(cursorOffset);
              final mentionRange =
                  widget.controller.getMentionRangeBeforeCursor(cursorOffset);
              final totalTextLength = widget.controller.rawText.length;
              final charBeforeCursor = cursorOffset - 1;

              // カーソルがリンク/メンションの末尾境界にあるかチェック
              final isCursorAtEndOfLink =
                  linkRange != null && cursorOffset == linkRange.end;
              final isCursorAtEndOfMention =
                  mentionRange != null && cursorOffset == mentionRange.end;

              // カーソルの前の文字がリンク/メンション範囲内にあるかチェック
              final isCharInsideLink = linkRange != null &&
                  charBeforeCursor >= linkRange.start &&
                  charBeforeCursor < linkRange.end;
              final isCharInsideMention = mentionRange != null &&
                  charBeforeCursor >= mentionRange.start &&
                  charBeforeCursor < mentionRange.end;

              // カーソルが末尾境界にある場合のみカーソル後のテキストをチェック
              // カーソルが末尾でかつ後にテキストがある場合、通常の削除を許可
              // カーソルが内部にある場合（末尾でない）、常にリンク/メンションを選択
              final hasTextAfterCursor = cursorOffset < totalTextLength;

              final isAtEndOfLink = isCursorAtEndOfLink &&
                  isCharInsideLink &&
                  !hasTextAfterCursor; // Only select if at end with no text after
              final isAtEndOfMention = isCursorAtEndOfMention &&
                  isCharInsideMention &&
                  !hasTextAfterCursor; // Only select if at end with no text after

              // カーソルがリンク/メンション内にある場合（末尾でない）、常に選択
              final isInsideLink = !isCursorAtEndOfLink && isCharInsideLink;
              final isInsideMention =
                  !isCursorAtEndOfMention && isCharInsideMention;

              // 末尾境界になくリンク/メンション内にない場合のみプレーンテキスト
              isPlainTextBeforeCursor = !isAtEndOfLink &&
                  !isAtEndOfMention &&
                  !isInsideLink &&
                  !isInsideMention;
            }

            // カーソルの前の文字がある場合のみリンク/メンション境界をチェック
            // is not plain text (i.e., it has link/mention properties)
            if (!isPlainTextBeforeCursor) {
              // カーソルがリンクの末尾にあるかチェック
              final linkRange =
                  widget.controller.getLinkRangeBeforeCursor(cursorOffset);
              if (linkRange != null) {
                // 現在の選択が既にリンク範囲と一致するかチェック
                // その場合、削除を続行を許可
                final alreadySelected =
                    _selection.baseOffset == linkRange.start &&
                        _selection.extentOffset == linkRange.end;

                if (!alreadySelected) {
                  // 削除する代わりにリンク全体を選択
                  _selection = TextSelection(
                    baseOffset: linkRange.start,
                    extentOffset: linkRange.end,
                  );
                  _composingRegion = null;
                  _updateRemoteEditingValue();
                  setState(() {});
                  return; // Don't delete, just select
                }
              }

              // カーソルがメンションの末尾にあるかチェック
              final mentionRange =
                  widget.controller.getMentionRangeBeforeCursor(cursorOffset);
              if (mentionRange != null) {
                // 現在の選択が既にメンション範囲と一致するかチェック
                // その場合、削除の続行を許可
                final alreadySelected =
                    _selection.baseOffset == mentionRange.start &&
                        _selection.extentOffset == mentionRange.end;

                if (!alreadySelected) {
                  // 削除する代わりにメンション全体を選択
                  _selection = TextSelection(
                    baseOffset: mentionRange.start,
                    extentOffset: mentionRange.end,
                  );
                  _composingRegion = null;
                  _updateRemoteEditingValue();
                  setState(() {});
                  return; // Don't delete, just select
                }
              }
            }
          }

          // バックスペースでブロックが削除されたかチェック
          final blockCountBefore =
              widget.controller.value?.firstOrNull?.children.length ?? 0;

          // 通常のテキスト置換
          widget.controller.replaceText(start, oldEnd, replacementText);

          final blockCountAfter =
              widget.controller.value?.firstOrNull?.children.length ?? 0;

          // ブロックが削除された場合（空ブロック開始時のバックスペース）
          if (blockCountAfter < blockCountBefore &&
              oldEnd > start &&
              replacementText.isEmpty) {
            // ブロックが削除/マージされた
            // カーソル位置を設定
            _selection = TextSelection.collapsed(offset: start);
            _composingRegion = null;
          } else {
            // カーソル位置と変換領域を更新
            _selection = value.selection;
            _composingRegion = null;
          }
        }

        widget.onChanged?.call(widget.controller.value ?? []);

        // コントローラー更新後に変換テキストをクリア
        _composingText = null;

        // 変換終了後にリモート値を更新
        _updateRemoteEditingValue();

        // 変更を反映するために再構築をトリガー
        setState(() {});
      }
    } else {
      // 選択または変換領域のみが変更された
      _selection = value.selection;

      // リンク/メンションと部分的に重なる場合は選択を自動調整
      // リンクとメンションは全体として選択するか、まったく選択しないか
      if (!_selection.isCollapsed) {
        final adjustedSelection =
            _adjustSelectionForLinksAndMentions(_selection);
        if (adjustedSelection != _selection) {
          _selection = adjustedSelection;
          _updateRemoteEditingValue();
        }
      }

      // 変換が終了したかチェック（変換テキストがあったが今は変換が無効）
      if (_composingText != null &&
          (!value.composing.isValid || value.composing.start == -1)) {
        // 変換が終了
        final textToCommit = _composingText!;
        final currentText = widget.controller.rawText;

        // テキストが既にコミットされている場合（textToCommit == currentText）、
        // no need to call replaceText, just clear composing state
        if (textToCommit == currentText) {
          // テキストは既に一致、変換状態をクリアするだけ
          _composingText = null;
          _composingRegion = null;

          // カーソルをテキストの末尾に更新
          _selection = TextSelection.collapsed(offset: textToCommit.length);

          // リモート値を更新
          _updateRemoteEditingValue();

          setState(() {});
        } else {
          // コミット前にカーソルを開始位置に設定
          // これにより履歴が正しいカーソル位置（0）を保存
          _selection = TextSelection.collapsed(offset: currentText.length);

          // コミットされたテキストですべてのテキストを置換
          widget.controller.replaceText(0, currentText.length, textToCommit);

          widget.onChanged?.call(widget.controller.value ?? []);

          // 変換状態をクリア
          _composingText = null;
          _composingRegion = null;

          // カーソルをコミットされたテキストの末尾に更新
          _selection = TextSelection.collapsed(offset: textToCommit.length);

          // リモート値を更新
          _updateRemoteEditingValue();

          setState(() {});
        }
      } else if (!value.composing.isValid || value.composing.start == -1) {
        // 変換は終了したが変換テキストはなかった
        _composingRegion = null;
        _updateRemoteEditingValue();
        setState(() {});
      } else {
        // まだ変換中
        _composingRegion = TextSelection(
          baseOffset: value.composing.start,
          extentOffset: value.composing.end,
        );
        setState(() {});
      }
    }
  }

  @override
  void performAction(TextInputAction action) {
    switch (action) {
      case TextInputAction.newline:
        if (!widget.readOnly) {
          // 現在のカーソル位置に新しい段落を挿入
          widget.controller.insertNewLine(_selection.baseOffset);

          // カーソルを次の行に移動
          _selection =
              TextSelection.collapsed(offset: _selection.baseOffset + 1);

          // 改行挿入時に変換状態をクリア
          _composingText = null;
          _composingRegion = null;

          _updateRemoteEditingValue();
          widget.onChanged?.call(widget.controller.value ?? []);
          setState(() {});
        }
        break;
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.search:
      case TextInputAction.send:
        widget.onEditingComplete?.call();
        break;
      default:
        break;
    }
  }

  @override
  void connectionClosed() {
    if (_hasInputConnection) {
      _textInputConnection!.connectionClosedReceived();
      _textInputConnection = null;
    }
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue get currentTextEditingValue => TextEditingValue(
        text: _getPlainText(),
        selection: _selection,
        composing: _composingRegion != null
            ? TextRange(
                start: _composingRegion!.start,
                end: _composingRegion!.end,
              )
            : TextRange.empty,
      );

  @override
  TextEditingValue get textEditingValue => currentTextEditingValue;

  set textEditingValue(TextEditingValue value) {
    updateEditingValue(value);
  }

  @override
  void copySelection(SelectionChangedCause cause) {
    final text = _selection.textInside(_getPlainText());
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  void cutSelection(SelectionChangedCause cause) {
    if (widget.readOnly) {
      return;
    }
    widget.controller.clipboard.cut();
  }

  @override
  Future<void> pasteText(SelectionChangedCause cause) => Future.value();

  @override
  void selectAll(SelectionChangedCause cause) {
    final text = _getPlainText();
    _selection = TextSelection(
      baseOffset: 0,
      extentOffset: text.length,
    );
    setState(() {});
    _updateRemoteEditingValue();
  }

  @override
  void bringIntoView(TextPosition position) {}

  @override
  void didChangeInputControl(
      TextInputControl? oldControl, TextInputControl? newControl) {}

  @override
  void insertContent(KeyboardInsertedContent content) {}

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void performSelector(String selectorName) {}
  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  void insertTextPlaceholder(Size size) {}

  @override
  void removeTextPlaceholder() {}

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}

  @override
  void showToolbar() {}

  @override
  void hideToolbar([bool hideHandles = true]) {}

  @override
  bool get cutEnabled => !widget.readOnly && _selection.isValid;

  @override
  bool get copyEnabled => _selection.isValid;

  @override
  bool get pasteEnabled => !widget.readOnly;

  @override
  bool get selectAllEnabled => true;

  @override
  bool get liveTextInputEnabled => false;

  @override
  bool get lookUpEnabled => true;

  @override
  bool get searchWebEnabled => true;

  @override
  bool get shareEnabled => true;

  @override
  void userUpdateTextEditingValue(
    TextEditingValue value,
    SelectionChangedCause cause,
  ) {
    updateEditingValue(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = widget.style ?? theme.textTheme.bodyLarge;
    final cursorColor = widget.cursorColor ?? theme.colorScheme.primary;
    final selectionColor = widget.selectionColor ??
        theme.textSelectionTheme.selectionColor ??
        theme.colorScheme.primary.withValues(alpha: 0.4);

    // readonly時はカーソル・選択を無効化
    final showCursor =
        widget.readOnly ? false : (_focusNode.hasFocus && _showCursor);
    final effectiveSelection =
        widget.readOnly ? const TextSelection.collapsed(offset: 0) : _selection;

    Widget child = _MarkdownRenderObjectWidget(
      onTapLink: widget.onTapLink,
      onTapMention: widget.onTapMention,
      controller: widget.controller,
      focusNode: _focusNode,
      selection: effectiveSelection,
      composingRegion: widget.readOnly ? null : _composingRegion,
      composingText: widget.readOnly ? null : _composingText,
      showCursor: showCursor,
      expands: widget.expands,
      style: defaultStyle!,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: cursorColor,
      theme: theme,
      selectionColor: selectionColor,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection ?? Directionality.of(context),
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      strutStyle: widget.strutStyle,
      onSelectionChanged: widget.readOnly
          ? (_, __) {} // readonly時は選択処理を無効化
          : (selection, cause) {
              setState(() {
                _selection = selection;
                _cursorBlinkController?.reset();
                _cursorBlinkController?.repeat();
              });

              // タップ/ドラッグで選択が変わる場合、IMEテキストをコミットするために変換領域をクリア
              // タップやドラッグでカーソルが移動した場合、コンポージングをクリアしてIMEテキストを確定
              if (cause == SelectionChangedCause.tap ||
                  cause == SelectionChangedCause.drag ||
                  cause == SelectionChangedCause.toolbar) {
                _composingRegion = null;
              }

              _updateRemoteEditingValue();
              // ツールバーが選択状態に基づいて更新できるようにコントローラーリスナーに通知
              // ツールバーが選択状態に基づいて更新できるようにコントローラーのリスナーに通知
              widget.controller.notifySelectionChanged();
            },
      onTap: () {
        _hideContextMenu();
        if (!_focusNode.hasFocus) {
          // First unfocus any current focus, then request focus for this field
          // This helps when another widget (like toolbar) has focus
          FocusManager.instance.primaryFocus?.unfocus();
          // Use a microtask to ensure unfocus completes before requesting focus
          Future.microtask(() {
            if (mounted && !_focusNode.hasFocus) {
              _focusNode.requestFocus();
            }
          });
        }
        widget.onTap?.call();
      },
      onLongPress: (globalPosition) {
        widget.onLongPress?.call(globalPosition);
        if (widget.contextMenuBuilder != null) {
          _showContextMenu(globalPosition);
        }
      },
      onDoubleTap: (globalPosition) {
        widget.onDoubleTap?.call(globalPosition);
      },
      enabled: widget.enabled ?? true,
      readOnly: widget.readOnly,
      selectionAdjuster: _adjustSelectionForLinksAndMentions,
    );

    if (widget.scrollable &&
        (widget.scrollController != null || !widget.expands)) {
      child = SingleChildScrollView(
        controller: _scrollController,
        physics: widget.scrollPhysics,
        padding: widget.scrollPadding,
        child: child,
      );
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: child,
    );
  }

  String _getPlainText() {
    // IME変換中に更新されるコントローラーのテキストを常に使用
    final plainText = widget.controller.rawText;
    return plainText;
  }

  /// Find the difference between old and new text, considering cursor position.
  ///
  /// カーソル位置を考慮して、古いテキストと新しいテキストの差分を見つけます。
  ///
  /// Returns a record containing (start, oldEnd, newEnd) positions.
  ({int start, int oldEnd, int newEnd}) _findTextDifference({
    required String oldText,
    required String newText,
    required TextSelection selection,
  }) {
    var start = 0;
    var oldEnd = oldText.length;
    var newEnd = newText.length;

    // 純粋な挿入の場合（テキストが追加されただけ）
    if (newText.length > oldText.length && selection.isCollapsed) {
      final insertedLength = newText.length - oldText.length;
      final cursorPos = selection.baseOffset;

      // カーソル位置から挿入位置を逆算
      // 挿入後のカーソル位置 = 挿入位置 + 挿入した文字数
      final insertionPoint = cursorPos - insertedLength;

      if (insertionPoint >= 0 && insertionPoint <= oldText.length) {
        // 挿入位置の前後でテキストが一致するか確認
        final beforeInsertion =
            insertionPoint > 0 ? newText.substring(0, insertionPoint) : "";
        final afterInsertion =
            insertionPoint < oldText.length ? newText.substring(cursorPos) : "";
        final oldBefore =
            insertionPoint > 0 ? oldText.substring(0, insertionPoint) : "";
        final oldAfter = insertionPoint < oldText.length
            ? oldText.substring(insertionPoint)
            : "";

        if (beforeInsertion == oldBefore && afterInsertion == oldAfter) {
          // カーソル位置から判定した挿入位置が正しい
          return (
            start: insertionPoint,
            oldEnd: insertionPoint,
            newEnd: cursorPos
          );
        }
      }
    }

    // 挿入以外の場合、またはカーソル位置から判定できない場合は従来のアルゴリズムを使用
    while (start < oldText.length &&
        start < newText.length &&
        oldText[start] == newText[start]) {
      start++;
    }

    while (oldEnd > start &&
        newEnd > start &&
        oldText[oldEnd - 1] == newText[newEnd - 1]) {
      oldEnd--;
      newEnd--;
    }

    return (start: start, oldEnd: oldEnd, newEnd: newEnd);
  }

  /// Get the text range of a link at the given offset.
  ///
  /// 指定されたオフセットにあるリンクのテキスト範囲を取得します。
  TextRange? _getLinkRangeAtOffset(int targetOffset) {
    final controllerValue = widget.controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;
    String? targetLinkUrl;
    int? linkStart;
    int? linkEnd;

    // 第1パス: ターゲットオフセットでリンクURLを検索
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // ターゲットオフセットがこのスパン内にあるかチェック
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // このスパンがリンクプロパティを持つかチェック
                for (final property in span.properties) {
                  if (property is LinkMarkdownSpanProperty) {
                    targetLinkUrl = property.link;
                    break;
                  }
                }
                if (targetLinkUrl != null) {
                  break;
                }
              }

              currentOffset += spanLength;
            }
            if (targetLinkUrl != null) {
              break;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetLinkUrl != null) {
            break;
          }
          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
      if (targetLinkUrl != null) {
        break;
      }
    }

    // ターゲットオフセットでリンクが見つからない場合、nullを返す
    if (targetLinkUrl == null) {
      return null;
    }

    // 第2パス: 同じリンクURLを持つ連続したスパンの完全な範囲を検索
    currentOffset = 0;
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // このスパンが同じリンクURLを持つかチェック
              var hasTargetLink = false;
              for (final property in span.properties) {
                if (property is LinkMarkdownSpanProperty &&
                    property.link == targetLinkUrl) {
                  hasTargetLink = true;
                  break;
                }
              }

              if (hasTargetLink) {
                // リンク範囲を拡張
                linkStart ??= spanStart;
                linkEnd = spanEnd;
              } else if (linkStart != null) {
                // 連続したリンクスパンの終わりを見つけた
                if (currentOffset > targetOffset) {
                  return TextRange(start: linkStart, end: linkEnd!);
                }
                // 次の潜在的なリンク範囲のためにリセット
                linkStart = null;
                linkEnd = null;
              }

              currentOffset += spanLength;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    // 範囲が見つかった場合は返す
    if (linkStart != null && linkEnd != null) {
      return TextRange(start: linkStart, end: linkEnd);
    }

    return null;
  }

  /// Get the text range of a mention at the given offset.
  ///
  /// 指定されたオフセットにあるメンションのテキスト範囲を取得します。
  TextRange? _getMentionRangeAtOffset(int targetOffset) {
    final controllerValue = widget.controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;
    MarkdownMention? targetMention;
    int? mentionStart;
    int? mentionEnd;

    // 第1パス: ターゲットオフセットでメンションを検索
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // ターゲットオフセットがこのスパン内にあるかチェック
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // このスパンがメンションプロパティを持つかチェック
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty) {
                    targetMention = property.mention;
                    break;
                  }
                }
                if (targetMention != null) {
                  break;
                }
              }

              currentOffset += spanLength;
            }
            if (targetMention != null) {
              break;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetMention != null) {
            break;
          }
          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
      if (targetMention != null) {
        break;
      }
    }

    // ターゲットオフセットでメンションが見つからない場合、nullを返す
    if (targetMention == null) {
      return null;
    }

    // 第2パス: 同じメンションを持つ連続したスパンの完全な範囲を検索
    // ただし同じブロック内のみ（メンションはブロック境界を越えられない）
    currentOffset = 0;
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          final blockStartOffset = currentOffset;
          var blockEndOffset = currentOffset;

          // ブロック終了オフセットを計算
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              blockEndOffset += span.value.length;
            }
            if (lineIndex < lines.length - 1) {
              blockEndOffset += 1; // newline within block
            }
          }

          // ターゲットオフセットがこのブロック内にあるかチェック
          final isTargetInThisBlock =
              targetOffset >= blockStartOffset && targetOffset < blockEndOffset;

          if (isTargetInThisBlock) {
            // このブロック内のみ検索
            var blockLocalOffset = currentOffset;
            for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
              final line = lines[lineIndex];
              for (final span in line.children) {
                final spanLength = span.value.length;
                final spanStart = blockLocalOffset;
                final spanEnd = blockLocalOffset + spanLength;

                // このスパンが同じメンションを持つかチェック
                var hasTargetMention = false;
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty &&
                      property.mention.id == targetMention.id) {
                    hasTargetMention = true;
                    break;
                  }
                }

                if (hasTargetMention) {
                  // メンション範囲を拡張
                  mentionStart ??= spanStart;
                  mentionEnd = spanEnd;
                } else if (mentionStart != null) {
                  // このブロック内の連続したメンションスパンの終わりを見つけた
                  return TextRange(start: mentionStart, end: mentionEnd!);
                }

                blockLocalOffset += spanLength;
              }
              if (lineIndex < lines.length - 1) {
                blockLocalOffset += 1;
              }
            }

            // ブロックの終わりに達してもメンション範囲がある場合、それを返す
            if (mentionStart != null && mentionEnd != null) {
              return TextRange(start: mentionStart, end: mentionEnd);
            }
          }

          // 次のブロックに移動
          currentOffset = blockEndOffset;
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1; // newline between blocks
          }
        }
      }
    }

    // 範囲が見つかった場合は返す
    if (mentionStart != null && mentionEnd != null) {
      return TextRange(start: mentionStart, end: mentionEnd);
    }

    return null;
  }
}

/// Internal RenderObjectWidget for markdown editing.
///
/// Markdown編集用の内部RenderObjectWidget。
class _MarkdownRenderObjectWidget extends LeafRenderObjectWidget {
  const _MarkdownRenderObjectWidget({
    required this.controller,
    required this.focusNode,
    required this.selection,
    required this.showCursor,
    required this.expands,
    required this.style,
    required this.cursorWidth,
    required this.cursorColor,
    required this.selectionColor,
    required this.theme,
    required this.textAlign,
    required this.textDirection,
    required this.textWidthBasis,
    required this.onSelectionChanged,
    required this.onTap,
    required this.enabled,
    required this.readOnly,
    this.composingRegion,
    this.composingText,
    this.cursorHeight,
    this.cursorRadius,
    this.textHeightBehavior,
    this.strutStyle,
    this.onLongPress,
    this.onDoubleTap,
    this.onTapLink,
    this.onTapMention,
    this.selectionAdjuster,
  });

  final MarkdownController controller;
  final FocusNode focusNode;
  final TextSelection selection;
  final TextSelection? composingRegion;
  final String? composingText;
  final bool showCursor;
  final bool expands;
  final TextStyle style;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color cursorColor;
  final Color selectionColor;
  final ThemeData theme;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final StrutStyle? strutStyle;
  final SelectionChangedCallback onSelectionChanged;
  final VoidCallback? onTap;
  final void Function(Offset globalPosition)? onLongPress;
  final void Function(Offset globalPosition)? onDoubleTap;
  final void Function(Uri link)? onTapLink;
  final void Function(MarkdownMention mention)? onTapMention;
  final bool enabled;
  final bool readOnly;
  final TextSelection Function(TextSelection selection)? selectionAdjuster;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMarkdownEditor(
      controller: controller,
      focusNode: focusNode,
      selection: selection,
      composingRegion: composingRegion,
      composingText: composingText,
      showCursor: showCursor,
      expands: expands,
      style: style,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      theme: theme,
      textAlign: textAlign,
      textDirection: textDirection,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      strutStyle: strutStyle,
      onSelectionChanged: onSelectionChanged,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      enabled: enabled,
      readOnly: readOnly,
      onTapLink: onTapLink,
      onTapMention: onTapMention,
      selectionAdjuster: selectionAdjuster,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMarkdownEditor renderObject,
  ) {
    renderObject
      ..controller = controller
      ..focusNode = focusNode
      ..selection = selection
      ..composingRegion = composingRegion
      ..composingText = composingText
      ..showCursor = showCursor
      ..expands = expands
      ..style = style
      ..cursorWidth = cursorWidth
      ..cursorHeight = cursorHeight
      ..cursorRadius = cursorRadius
      ..cursorColor = cursorColor
      ..selectionColor = selectionColor
      ..theme = theme
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..strutStyle = strutStyle
      .._onSelectionChanged = onSelectionChanged
      .._onTap = onTap
      .._onLongPress = onLongPress
      .._onDoubleTap = onDoubleTap
      ..enabled = enabled
      ..readOnly = readOnly
      .._onTapLink = onTapLink
      .._onTapMention = onTapMention
      .._selectionAdjuster = selectionAdjuster;
  }
}

/// RenderBox for markdown editor.
///
/// Markdownエディタ用のRenderBox。
class _RenderMarkdownEditor extends RenderBox implements RenderContext {
  _RenderMarkdownEditor({
    required MarkdownController controller,
    required FocusNode focusNode,
    required TextSelection selection,
    required bool showCursor,
    required bool expands,
    required TextStyle style,
    required double cursorWidth,
    required Color cursorColor,
    required Color selectionColor,
    required ThemeData theme,
    required TextAlign textAlign,
    required TextDirection textDirection,
    required TextWidthBasis textWidthBasis,
    required SelectionChangedCallback onSelectionChanged,
    required VoidCallback? onTap,
    required bool enabled,
    required bool readOnly,
    TextSelection? composingRegion,
    String? composingText,
    double? cursorHeight,
    Radius? cursorRadius,
    TextHeightBehavior? textHeightBehavior,
    StrutStyle? strutStyle,
    void Function(Offset globalPosition)? onLongPress,
    void Function(Offset globalPosition)? onDoubleTap,
    void Function(Uri link)? onTapLink,
    void Function(MarkdownMention mention)? onTapMention,
    TextSelection Function(TextSelection selection)? selectionAdjuster,
  })  : _controller = controller,
        _focusNode = focusNode,
        _selection = selection,
        _composingRegion = composingRegion,
        _composingText = composingText,
        _showCursor = showCursor,
        _expands = expands,
        _style = style,
        _cursorWidth = cursorWidth,
        _cursorHeight = cursorHeight,
        _cursorRadius = cursorRadius,
        _cursorColor = cursorColor,
        _theme = theme,
        _selectionColor = selectionColor,
        _textAlign = textAlign,
        _textDirection = textDirection,
        _textWidthBasis = textWidthBasis,
        _textHeightBehavior = textHeightBehavior,
        _strutStyle = strutStyle,
        _onSelectionChanged = onSelectionChanged,
        _onTap = onTap,
        _onLongPress = onLongPress,
        _onDoubleTap = onDoubleTap,
        _enabled = enabled,
        _readOnly = readOnly,
        _onTapLink = onTapLink,
        _onTapMention = onTapMention,
        _selectionAdjuster = selectionAdjuster;

  MarkdownController _controller;
  MarkdownController get controller => _controller;
  set controller(MarkdownController value) {
    if (_controller == value) {
      return;
    }
    _controller.removeListener(_handleControllerChanged);
    _controller = value;
    _controller.addListener(_handleControllerChanged);
    markNeedsPaint();
  }

  @override
  FocusNode get focusNode => _focusNode;
  set focusNode(FocusNode value) {
    if (_focusNode == value) {
      return;
    }
    _focusNode = value;
  }

  FocusNode _focusNode;

  @override
  TextSelection get selection => _selection;
  set selection(TextSelection value) {
    if (_selection == value) {
      return;
    }
    // コールバックが提供されている場合は選択を調整 - これは選択変更を傍受
    // from double-tap and handle drag operations
    final adjustedValue = _selectionAdjuster?.call(value) ?? value;
    _selection = adjustedValue;
    markNeedsPaint();
  }

  TextSelection _selection;

  @override
  TextSelection? get composingRegion => _composingRegion;
  set composingRegion(TextSelection? value) {
    if (_composingRegion == value) {
      return;
    }
    _composingRegion = value;
    markNeedsPaint();
  }

  TextSelection? _composingRegion;

  String? get composingText => _composingText;
  set composingText(String? value) {
    if (_composingText == value) {
      return;
    }
    _composingText = value;
    _blockLayouts = []; // Clear cache when composing text changes
    markNeedsLayout();
  }

  String? _composingText;

  @override
  bool get showCursor => _showCursor;
  set showCursor(bool value) {
    if (_showCursor == value) {
      return;
    }
    _showCursor = value;
    markNeedsPaint();
  }

  bool _showCursor;

  @override
  bool get expands => _expands;
  set expands(bool value) {
    if (_expands == value) {
      return;
    }
    _expands = value;
  }

  bool _expands;

  @override
  TextStyle get style => _style;
  set style(TextStyle value) {
    if (_style == value) {
      return;
    }
    _style = value;
    _blockLayouts = [];
    markNeedsLayout();
  }

  TextStyle _style;

  @override
  double get cursorWidth => _cursorWidth;
  set cursorWidth(double value) {
    if (_cursorWidth == value) {
      return;
    }
    _cursorWidth = value;
    markNeedsPaint();
  }

  double _cursorWidth;

  @override
  double? get cursorHeight => _cursorHeight;
  set cursorHeight(double? value) {
    if (_cursorHeight == value) {
      return;
    }
    _cursorHeight = value;
    markNeedsPaint();
  }

  double? _cursorHeight;

  @override
  Radius? get cursorRadius => _cursorRadius;
  set cursorRadius(Radius? value) {
    if (_cursorRadius == value) {
      return;
    }
    _cursorRadius = value;
    markNeedsPaint();
  }

  Radius? _cursorRadius;

  @override
  Color get cursorColor => _cursorColor;
  set cursorColor(Color value) {
    if (_cursorColor == value) {
      return;
    }
    _cursorColor = value;
    markNeedsPaint();
  }

  Color _cursorColor;

  @override
  Color get selectionColor => _selectionColor;
  set selectionColor(Color value) {
    if (_selectionColor == value) {
      return;
    }
    _selectionColor = value;
    markNeedsPaint();
  }

  Color _selectionColor;

  @override
  ThemeData get theme => _theme;
  set theme(ThemeData value) {
    if (_theme == value) {
      return;
    }
    _theme = value;
    markNeedsPaint();
  }

  ThemeData _theme;

  @override
  TextAlign get textAlign => _textAlign;
  set textAlign(TextAlign value) {
    if (_textAlign == value) {
      return;
    }
    _textAlign = value;
    markNeedsLayout();
  }

  TextAlign _textAlign;

  @override
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;

  @override
  TextWidthBasis get textWidthBasis => _textWidthBasis;
  set textWidthBasis(TextWidthBasis value) {
    if (_textWidthBasis == value) {
      return;
    }
    _textWidthBasis = value;
    markNeedsLayout();
  }

  TextWidthBasis _textWidthBasis;

  @override
  TextHeightBehavior? get textHeightBehavior => _textHeightBehavior;
  set textHeightBehavior(TextHeightBehavior? value) {
    if (_textHeightBehavior == value) {
      return;
    }
    _textHeightBehavior = value;
    markNeedsLayout();
  }

  TextHeightBehavior? _textHeightBehavior;

  @override
  StrutStyle? get strutStyle => _strutStyle;
  set strutStyle(StrutStyle? value) {
    if (_strutStyle == value) {
      return;
    }
    _strutStyle = value;
    markNeedsLayout();
  }

  StrutStyle? _strutStyle;

  SelectionChangedCallback _onSelectionChanged;

  VoidCallback? _onTap;

  void Function(Offset globalPosition)? _onLongPress;

  void Function(Offset globalPosition)? _onDoubleTap;

  void Function(Uri link)? _onTapLink;

  void Function(MarkdownMention mention)? _onTapMention;

  TextSelection Function(TextSelection selection)? _selectionAdjuster;

  bool _enabled;
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (_enabled == value) {
      return;
    }
    _enabled = value;
    markNeedsPaint();
  }

  bool _readOnly;
  bool get readOnly => _readOnly;
  set readOnly(bool value) {
    if (_readOnly == value) {
      return;
    }
    _readOnly = value;
    markNeedsPaint();
  }

  // ブロックレイアウト情報
  List<BlockLayout> _blockLayouts = [];

  // タップ追跡
  Offset? _lastTapDownPosition;
  int? _lastTapTime;
  Timer? _longPressTimer;
  bool _longPressDetected = false;

  // 重複呼び出しを防ぐために最後のリンクダイアログ表示時刻を追跡
  int _lastLinkDialogShowTime = 0;
  bool _doubleTapDetected = false;

  // 選択ハンドル追跡
  Offset? _startHandlePosition;
  Offset? _endHandlePosition;
  bool _isDraggingStartHandle = false;
  bool _isDraggingEndHandle = false;

  // ダブルタップ追跡
  static const _doubleTapTimeout = Duration(milliseconds: 300);
  static const _longPressTimeout = Duration(milliseconds: 500);
  static const _handleRadius = 8.0;

  void _handleControllerChanged() {
    _blockLayouts = []; // Clear cache when controller changes
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void detach() {
    _longPressTimer?.cancel();
    _controller.removeListener(_handleControllerChanged);
    super.detach();
  }

  List<BlockLayout> _buildBlockLayouts() {
    if (_blockLayouts.isNotEmpty) {
      return _blockLayouts;
    }

    // 重要: IME変換中でも常にコントローラーのブロック構造を使用
    // 変換テキストはコントローラーの構造を使用してレンダリングされる
    // これによりIME入力中の複数行構造が保持される

    final fields = _controller.value ?? [];
    final layouts = <BlockLayout>[];
    var textOffset = 0;

    // フィールドやブロックがない場合、カーソルレンダリング用のダミー空段落ブロックを作成
    if (fields.isEmpty || fields.every((f) => f.children.isEmpty)) {
      // コントローラーからブロックスタイルを取得
      final padding = (_controller.style.paragraph.padding ?? EdgeInsets.zero)
          as EdgeInsets;
      final margin =
          (_controller.style.paragraph.margin ?? EdgeInsets.zero) as EdgeInsets;

      // テキストスタイルを構築
      final baseStyle = _controller.style.paragraph.textStyle ?? _style;
      final textStyle = baseStyle.copyWith(
        color: _controller.style.paragraph.foregroundColor ?? baseStyle.color,
      );

      // 空ブロック用のテキストペインターを作成
      final painter = TextPainter(
        text: TextSpan(text: "", style: textStyle),
        textAlign: _textAlign,
        textDirection: _textDirection,
        textWidthBasis: _textWidthBasis,
        textHeightBehavior: _textHeightBehavior,
        strutStyle: _strutStyle,
      );

      layouts.add(BlockLayout(
        block: MarkdownBlockValue.createEmpty(),
        painter: painter,
        textOffset: 0,
        textLength: 0,
        padding: padding,
        margin: margin,
        spans: const [],
      ));

      _blockLayouts = layouts;
      return layouts;
    }

    for (final field in fields) {
      for (final block in field.children) {
        final layout = block.build(this, _controller, textOffset);
        if (layout == null) {
          continue;
        }
        layouts.add(layout);
        textOffset += layout.textLength + 1; // +1 for newline between blocks
      }
    }

    _blockLayouts = layouts;
    return layouts;
  }

  @override
  void performLayout() {
    final layouts = _buildBlockLayouts();

    var totalHeight = 0.0;
    final maxWidth = constraints.maxWidth;

    for (var i = 0; i < layouts.length; i++) {
      final layout = layouts[i];

      // マージン上部を追加
      totalHeight += layout.margin.top;

      // パディング上部を追加
      totalHeight += layout.padding.top;

      // パディング付きでテキストペインターをレイアウト
      final contentWidth = maxWidth - layout.padding.horizontal;
      layout.painter.layout(
        minWidth: contentWidth,
        maxWidth: contentWidth,
      );

      // テキストコンテンツが始まるオフセットを保存（パディング後）
      layout.offset = Offset(0, totalHeight);

      // 子ブロックのレイアウトを計算
      var childrenHeight = 0.0;
      if (layout.children != null && layout.children!.isNotEmpty) {
        childrenHeight = _layoutChildren(layout.children!, contentWidth);
      }

      // パディング付きのブロック全体の高さを計算（子ブロックを含む）
      final blockContentHeight = layout.painter.height + childrenHeight;
      final blockHeight =
          blockContentHeight + layout.padding.vertical + layout.margin.bottom;
      layout.height = blockHeight;

      // totalHeightをこのブロックの終わりに移動
      totalHeight +=
          blockContentHeight + layout.padding.bottom + layout.margin.bottom;
    }

    // expandsがtrueで maxHeightが有限の場合、利用可能な最大の高さを使用
    // それ以外の場合は実際のコンテンツの高さを使用
    final height = _expands && constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : totalHeight;

    size = constraints.constrain(Size(
      constraints.maxWidth,
      height,
    ));
  }

  /// Layout child blocks recursively.
  ///
  /// 子ブロックを再帰的にレイアウトします。
  double _layoutChildren(List<BlockLayout> children, double maxWidth) {
    var totalHeight = 0.0;

    for (var i = 0; i < children.length; i++) {
      final child = children[i];

      // マージン上部を追加
      totalHeight += child.margin.top;

      // パディング上部を追加
      totalHeight += child.padding.top;

      // パディング付きでテキストペインターをレイアウト
      final contentWidth = maxWidth - child.padding.horizontal;
      child.painter.layout(
        minWidth: contentWidth,
        maxWidth: contentWidth,
      );

      // テキストコンテンツが始まるオフセットを保存（パディング後）
      child.offset = Offset(0, totalHeight);

      // 子の子ブロックのレイアウトを計算（再帰）
      var grandchildrenHeight = 0.0;
      if (child.children != null && child.children!.isNotEmpty) {
        grandchildrenHeight = _layoutChildren(child.children!, contentWidth);
      }

      // パディング付きのブロック全体の高さを計算（孫ブロックを含む）
      final childContentHeight = child.painter.height + grandchildrenHeight;
      final childHeight =
          childContentHeight + child.padding.vertical + child.margin.bottom;
      child.height = childHeight;

      // totalHeightをこの子ブロックの終わりに移動
      totalHeight +=
          childContentHeight + child.padding.bottom + child.margin.bottom;
    }

    return totalHeight;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    // performLayoutから既に計算されたレイアウトを使用
    final layouts = _blockLayouts;

    var currentTextOffset = 0;

    // readonly時は選択ハンドルを描画しないのでリセット不要だが、一貫性のため保持
    _startHandlePosition = null;
    _endHandlePosition = null;

    // スクロール最適化: 画面外のブロックをスキップするため、ビューポート範囲を計算
    // offsetは親からの描画オフセット（通常はスクロール位置に基づく）
    final viewportTop = -offset.dy;
    final viewportBottom = viewportTop + size.height;

    for (var i = 0; i < layouts.length; i++) {
      final layout = layouts[i];

      // スクロール最適化: 画面外のブロックはスキップ
      final blockTop = layout.offset.dy - layout.padding.top;
      final blockBottom = blockTop + layout.height;

      // ブロックが完全に画面外にある場合はスキップ（選択描画は例外）
      final isVisible =
          blockBottom >= viewportTop && blockTop <= viewportBottom;
      final hasSelection = !_readOnly &&
          _selection.isValid &&
          !_selection.isCollapsed &&
          _selection.start < (currentTextOffset + layout.textLength + 1) &&
          _selection.end > currentTextOffset;

      if (!isVisible && !hasSelection) {
        currentTextOffset += layout.textLength + 1;
        continue;
      }

      // layout.offset.dy points to where text content starts (after padding top)
      final blockOffset =
          offset + layout.offset + Offset(layout.padding.left, 0);

      // ブロック背景がある場合は描画
      final blockStyle = layout.block.style(this, controller);
      final backgroundColor = blockStyle.backgroundColor;
      if (backgroundColor != null) {
        // 背景はパディングを含むブロック全体をカバー
        final blockRect = Rect.fromLTWH(
          offset.dx,
          offset.dy + layout.offset.dy - layout.padding.top,
          size.width,
          layout.height,
        );
        canvas.drawRect(
          blockRect,
          Paint()..color = backgroundColor,
        );
      }

      // ブロックボーダーがある場合は描画
      final border = blockStyle.border;
      if (border != null) {
        // ボーダーはパディングを含むブロック全体をカバー
        final blockRect = Rect.fromLTWH(
          offset.dx,
          offset.dy + layout.offset.dy - layout.padding.top,
          size.width,
          layout.height,
        );
        border.paint(
          canvas,
          blockRect,
        );
      }

      // このブロックの選択を計算
      final blockStart = currentTextOffset;
      final blockEnd = currentTextOffset + layout.textLength;

      // このブロックの選択を描画（readonly時はスキップ）
      if (!_readOnly && _selection.isValid && !_selection.isCollapsed) {
        if (_selection.start < blockEnd && _selection.end > blockStart) {
          final localStart =
              (_selection.start - blockStart).clamp(0, layout.textLength);
          final localEnd =
              (_selection.end - blockStart).clamp(0, layout.textLength);

          final localSelection = TextSelection(
            baseOffset: localStart,
            extentOffset: localEnd,
          );

          final boxes = layout.painter.getBoxesForSelection(localSelection);
          final paint = Paint()..color = _selectionColor;

          // TextPainterが返す選択ボックスを描画
          // これによりブロック内のテキストの折り返しが正しく処理される
          for (final box in boxes) {
            final boxRect = box.toRect().shift(blockOffset);
            canvas.drawRect(boxRect, paint);
          }

          // 選択の開始/終了でハンドル位置を計算
          // ローカル座標（オフセットなし）で位置を保存
          // このブロックが選択の実際の開始を含む場合のみ開始ハンドルを表示
          if (_selection.start >= blockStart && _selection.start < blockEnd) {
            // 開始ハンドル - Y座標を含む実際のキャレット位置を使用
            final startOffset = layout.painter.getOffsetForCaret(
              TextPosition(offset: localStart),
              Rect.zero,
            );
            _startHandlePosition =
                Offset(layout.padding.left, layout.offset.dy) + startOffset;
          }
          // このブロックが選択の実際の終了を含む場合のみ終了ハンドルを表示
          if (_selection.end > blockStart && _selection.end <= blockEnd) {
            // 終了ハンドル - Y座標を含む実際のキャレット位置を使用
            final endOffset = layout.painter.getOffsetForCaret(
              TextPosition(offset: localEnd),
              Rect.zero,
            );
            _endHandlePosition =
                Offset(layout.padding.left, layout.offset.dy) + endOffset;
          }
        }
      }

      // スパンの背景装飾を描画
      // 同じ装飾タイプの隣接スパンをマージ
      final decorationGroups = <_DecorationGroup>[];
      BoxDecoration? currentDecoration;
      int? groupStart;
      int? groupEnd;

      for (var i = 0; i < layout.spans.length; i++) {
        final spanInfo = layout.spans[i];
        final decoration =
            spanInfo.span.backgroundDecoration(this, _controller, null);

        // このスパンがコード装飾を持つかチェック
        final hasCodeDecoration = spanInfo.span.properties
            .any((p) => p is CodeFontMarkdownSpanProperty);

        if (hasCodeDecoration && decoration != null) {
          if (currentDecoration == null) {
            // 新しいグループを開始
            currentDecoration = decoration;
            groupStart = spanInfo.localOffset;
            groupEnd = spanInfo.localOffset + spanInfo.length;
          } else {
            // 現在のグループを拡張
            groupEnd = spanInfo.localOffset + spanInfo.length;
          }
        } else {
          // 現在のグループがあれば終了
          if (currentDecoration != null &&
              groupStart != null &&
              groupEnd != null) {
            decorationGroups.add(_DecorationGroup(
              decoration: currentDecoration,
              start: groupStart,
              end: groupEnd,
            ));
            currentDecoration = null;
            groupStart = null;
            groupEnd = null;
          }
        }
      }

      // 最後のグループがあれば追加
      if (currentDecoration != null && groupStart != null && groupEnd != null) {
        decorationGroups.add(_DecorationGroup(
          decoration: currentDecoration,
          start: groupStart,
          end: groupEnd,
        ));
      }

      // マージされた装飾グループを描画
      for (final group in decorationGroups) {
        final spanSelection = TextSelection(
          baseOffset: group.start,
          extentOffset: group.end,
        );
        final boxes = layout.painter.getBoxesForSelection(spanSelection);
        for (final box in boxes) {
          var boxRect = box.toRect().shift(blockOffset);
          // 2pxのパディングを追加
          boxRect = boxRect.inflate(2.0);
          final paint = Paint();
          if (group.decoration.color != null) {
            paint.color = group.decoration.color!;
          }
          if (group.decoration.borderRadius != null) {
            final rRect = (group.decoration.borderRadius as BorderRadius)
                .toRRect(boxRect);
            canvas.drawRRect(rRect, paint);
          } else {
            canvas.drawRect(boxRect, paint);
          }
        }
      }

      // リストブロックのマーカーを描画（テキストの前）
      if (layout.marker != null) {
        // マーカー位置を計算（テキストの左側）
        final markerOffset = Offset(
          offset.dx +
              layout.offset.dx +
              layout.padding.left -
              layout.marker!.width,
          offset.dy + layout.offset.dy,
        );

        // マーカーペインターを作成
        layout.marker?.markerBuilder?.call(
          canvas,
          markerOffset +
              Offset(layout.marker!.width / 3,
                  layout.painter.preferredLineHeight / 2),
        );
      }

      // テキストを描画
      layout.painter.paint(canvas, blockOffset);

      // 子ブロックを描画
      if (layout.children != null && layout.children!.isNotEmpty) {
        // 子ブロックはテキストの後に描画される
        final childrenOffset = Offset(
          offset.dx + layout.padding.left,
          offset.dy + layout.offset.dy + layout.painter.height,
        );
        _paintChildren(context, childrenOffset, layout.children!, offset);
      }

      // このブロックのカーソルを描画（readonly時はスキップ）
      if (!_readOnly &&
          _showCursor &&
          _selection.isValid &&
          _selection.isCollapsed &&
          _selection.baseOffset >= blockStart &&
          _selection.baseOffset <= blockEnd) {
        final localOffset = _selection.baseOffset - blockStart;
        final cursorOffset = layout.painter.getOffsetForCaret(
          TextPosition(offset: localOffset),
          Rect.zero,
        );
        final cursorHeight =
            _cursorHeight ?? layout.painter.preferredLineHeight;
        final cursorRect = Rect.fromLTWH(
          blockOffset.dx + cursorOffset.dx,
          blockOffset.dy + cursorOffset.dy,
          _cursorWidth,
          cursorHeight,
        );

        final paint = Paint()..color = _cursorColor;
        if (_cursorRadius != null) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(cursorRect, _cursorRadius!),
            paint,
          );
        } else {
          canvas.drawRect(cursorRect, paint);
        }
      }

      currentTextOffset = blockEnd + 1; // +1 for newline between blocks
    }

    // 選択ハンドルを描画（readonly時はスキップ）
    if (!_readOnly && _selection.isValid && !_selection.isCollapsed) {
      final handlePaint = Paint()
        ..color = _cursorColor
        ..style = PaintingStyle.fill;

      // 開始ハンドルを描画（描画用のオフセットを追加）
      if (_startHandlePosition != null) {
        _drawSelectionHandle(
          canvas,
          offset + _startHandlePosition!,
          handlePaint,
          isLeft: true,
        );
      }

      // 終了ハンドルを描画（描画用のオフセットを追加）
      if (_endHandlePosition != null) {
        _drawSelectionHandle(
          canvas,
          offset + _endHandlePosition!,
          handlePaint,
          isLeft: false,
        );
      }
    }
  }

  void _drawSelectionHandle(
    Canvas canvas,
    Offset position,
    Paint paint, {
    required bool isLeft,
  }) {
    // 上部に円形ハンドルを描画
    canvas.drawCircle(position, _handleRadius, paint);

    // ハンドルから下に伸びる線を描画
    final lineStart = position;
    final lineEnd = Offset(position.dx, position.dy + _handleRadius * 3);
    canvas.drawLine(
      lineStart,
      lineEnd,
      paint..strokeWidth = 2.0,
    );
  }

  /// Paint child blocks recursively.
  ///
  /// 子ブロックを再帰的に描画します。
  void _paintChildren(
    PaintingContext context,
    Offset offset,
    List<BlockLayout> children,
    Offset rootOffset,
  ) {
    final canvas = context.canvas;

    for (var i = 0; i < children.length; i++) {
      final child = children[i];

      // 子ブロックのオフセットを計算
      final childBlockOffset =
          offset + child.offset + Offset(child.padding.left, 0);

      // 子ブロック背景を描画
      final childBlockStyle = child.block.style(this, controller);
      final childBackgroundColor = childBlockStyle.backgroundColor;
      if (childBackgroundColor != null) {
        final childBlockRect = Rect.fromLTWH(
          offset.dx,
          offset.dy + child.offset.dy - child.padding.top,
          size.width - (offset.dx - rootOffset.dx),
          child.height,
        );
        canvas.drawRect(
          childBlockRect,
          Paint()..color = childBackgroundColor,
        );
      }

      // 子ブロックボーダーを描画
      final childBorder = childBlockStyle.border;
      if (childBorder != null) {
        final childBlockRect = Rect.fromLTWH(
          offset.dx,
          offset.dy + child.offset.dy - child.padding.top,
          size.width - (offset.dx - rootOffset.dx),
          child.height,
        );
        childBorder.paint(
          canvas,
          childBlockRect,
        );
      }

      // 子ブロックのスパン背景装飾を描画
      final childDecorationGroups = <_DecorationGroup>[];
      BoxDecoration? currentDecoration;
      int? groupStart;
      int? groupEnd;

      for (var j = 0; j < child.spans.length; j++) {
        final spanInfo = child.spans[j];
        final decoration =
            spanInfo.span.backgroundDecoration(this, _controller, null);

        final hasCodeDecoration = spanInfo.span.properties
            .any((p) => p is CodeFontMarkdownSpanProperty);

        if (hasCodeDecoration && decoration != null) {
          if (currentDecoration == null) {
            currentDecoration = decoration;
            groupStart = spanInfo.localOffset;
            groupEnd = spanInfo.localOffset + spanInfo.length;
          } else {
            groupEnd = spanInfo.localOffset + spanInfo.length;
          }
        } else {
          if (currentDecoration != null &&
              groupStart != null &&
              groupEnd != null) {
            childDecorationGroups.add(_DecorationGroup(
              decoration: currentDecoration,
              start: groupStart,
              end: groupEnd,
            ));
            currentDecoration = null;
            groupStart = null;
            groupEnd = null;
          }
        }
      }

      if (currentDecoration != null && groupStart != null && groupEnd != null) {
        childDecorationGroups.add(_DecorationGroup(
          decoration: currentDecoration,
          start: groupStart,
          end: groupEnd,
        ));
      }

      for (final group in childDecorationGroups) {
        final spanSelection = TextSelection(
          baseOffset: group.start,
          extentOffset: group.end,
        );
        final boxes = child.painter.getBoxesForSelection(spanSelection);
        for (final box in boxes) {
          var boxRect = box.toRect().shift(childBlockOffset);
          boxRect = boxRect.inflate(2.0);
          final paint = Paint();
          if (group.decoration.color != null) {
            paint.color = group.decoration.color!;
          }
          if (group.decoration.borderRadius != null) {
            final rRect = (group.decoration.borderRadius as BorderRadius)
                .toRRect(boxRect);
            canvas.drawRRect(rRect, paint);
          } else {
            canvas.drawRect(boxRect, paint);
          }
        }
      }

      // 子ブロックのマーカーを描画
      if (child.marker != null) {
        final markerOffset = Offset(
          offset.dx +
              child.offset.dx +
              child.padding.left -
              child.marker!.width,
          offset.dy + child.offset.dy,
        );

        child.marker?.markerBuilder?.call(
          canvas,
          markerOffset +
              Offset(child.marker!.width / 3,
                  child.painter.preferredLineHeight / 2),
        );
      }

      // 子ブロックのテキストを描画
      child.painter.paint(canvas, childBlockOffset);

      // 孫ブロックを描画（再帰）
      if (child.children != null && child.children!.isNotEmpty) {
        final grandchildrenOffset = Offset(
          offset.dx + child.padding.left,
          offset.dy + child.offset.dy + child.painter.height,
        );
        _paintChildren(
            context, grandchildrenOffset, child.children!, rootOffset);
      }
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry), "");

    // readonly時はリンク/メンションタップのみ処理し、それ以外はスキップ
    if (_readOnly) {
      if (event is PointerUpEvent) {
        _handleReadonlyTap(event);
      }
      return;
    }

    if (event is PointerDownEvent) {
      _handleTapDown(event);
    } else if (event is PointerUpEvent) {
      _handleTapUp(event);
    } else if (event is PointerMoveEvent) {
      _handleDragUpdate(event);
    } else if (event is PointerCancelEvent) {
      _handlePointerCancel(event);
    }
  }

  // readonly時のタップ処理（リンク/メンションのみ）
  void _handleReadonlyTap(PointerUpEvent event) {
    final position = globalToLocal(event.position);
    final textOffset = _getTextOffsetForPosition(position);

    if (textOffset == null) {
      return;
    }

    // リンクをタップしたかチェック
    final linkUrl = _getLinkAtOffset(textOffset);
    if (linkUrl != null && linkUrl.isNotEmpty) {
      _launchUrl(linkUrl);
      return;
    }

    // メンションをタップしたかチェック
    final mention = _getMentionAtOffset(textOffset);
    if (mention != null) {
      _onTapMention?.call(mention);
      return;
    }

    // readonly時は通常のタップも処理
    _onTap?.call();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _lastTapDownPosition = null;
    _longPressDetected = false;
    _doubleTapDetected = false;
    _isDraggingStartHandle = false;
    _isDraggingEndHandle = false;
  }

  int? _getTextOffsetForPosition(Offset position) {
    final layouts = _blockLayouts;
    var currentTextOffset = 0;

    // Always check x bounds to prevent out-of-bounds taps
    if (position.dx < 0 || position.dx > size.width) {
      return null;
    }

    // When expands is false, also check y bounds strictly
    // When expands is true, allow taps anywhere in the y direction to enable
    // full-area tapping even when content height is less than container height
    if (!_expands && (position.dy < 0 || position.dy > size.height)) {
      return null;
    }

    for (final layout in layouts) {
      // layout.offset.dy is where text content starts (after padding top)
      final blockOffset = layout.offset + Offset(layout.padding.left, 0);
      final blockBottom = blockOffset.dy + layout.painter.height;
      // ブロック上部はテキストの上のパディングエリアを含む
      final blockTop = layout.offset.dy - layout.padding.top;

      if (position.dy >= blockOffset.dy && position.dy <= blockBottom) {
        // 位置がこのブロックのテキストエリア内にある
        // BulletedListブロックの場合、位置がマーカーエリアにあるかチェック
        if (layout.marker != null) {
          final markerLeft =
              layout.offset.dx + layout.padding.left - layout.marker!.width;
          final markerRight = layout.offset.dx + layout.padding.left;
          // マーカーエリアをクリックした場合、テキストの開始として扱う
          if (position.dx >= markerLeft && position.dx < markerRight) {
            return currentTextOffset;
          }
        }

        // TextPainter.getPositionForOffsetはテキストの折り返しを正しく処理
        final localPosition = position - blockOffset;
        final textPosition = layout.painter.getPositionForOffset(localPosition);
        return currentTextOffset + textPosition.offset;
      } else if (position.dy >= blockTop &&
          position.dy <
              layout.offset.dy +
                  layout.painter.height +
                  layout.padding.bottom) {
        // 位置が垂直パディングエリア内にある
        // expandsがtrueの場合、テキストの終了として扱う
        if (_expands) {
          return currentTextOffset + layout.textLength;
        } else {
          return null;
        }
      }

      currentTextOffset +=
          layout.textLength + 1; // +1 for newline between blocks
    }

    // 位置がすべてのブロックの後、または空白領域(ブロック間など)にある
    // expandsがtrueの場合、x座標が範囲内であれば(上でチェック済み)
    // テキストの末尾にカーソルを配置する
    // expandsがfalseの場合、nullを返して選択解除
    if (_expands) {
      final lastOffset = currentTextOffset > 0 ? currentTextOffset - 1 : 0;
      return lastOffset;
    } else {
      return null;
    }
  }

  void _handleTapDown(PointerDownEvent event) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final position = globalToLocal(event.position);

    // マーカーのタップをチェック
    for (final layout in _blockLayouts) {
      if (layout.marker?.onTapMarker != null) {
        // マーカーの位置を計算
        final markerOffset = Offset(
          layout.offset.dx - layout.marker!.width,
          layout.offset.dy,
        );
        final markerRect = Rect.fromLTWH(
          markerOffset.dx,
          markerOffset.dy,
          layout.marker!.width,
          layout.painter.preferredLineHeight,
        );

        // マーカー領域内でタップされた場合
        if (markerRect.contains(position)) {
          layout.marker!.onTapMarker!();
          return;
        }
      }
    }

    // 選択ハンドルをタップしているかチェック
    // 両方のハンドルをチェックし、両方が範囲内の場合は近い方を選択
    final startDistance = _startHandlePosition != null
        ? (position - _startHandlePosition!).distance
        : double.infinity;
    final endDistance = _endHandlePosition != null
        ? (position - _endHandlePosition!).distance
        : double.infinity;

    if (startDistance < _handleRadius * 3 || endDistance < _handleRadius * 3) {
      // 近い方のハンドルを選択
      if (startDistance < endDistance) {
        _isDraggingStartHandle = true;
      } else {
        _isDraggingEndHandle = true;
      }
      return;
    }

    // フラグをリセット
    _longPressDetected = false;
    _doubleTapDetected = false;
    _isDraggingStartHandle = false;
    _isDraggingEndHandle = false;

    // ダブルタップをチェック
    if (_lastTapTime != null &&
        _lastTapDownPosition != null &&
        now - _lastTapTime! < _doubleTapTimeout.inMilliseconds &&
        (position - _lastTapDownPosition!).distance < 20) {
      // ダブルタップ検出
      _doubleTapDetected = true;
      _handleDoubleTapDetected(event.position);
      _lastTapTime = null;
      _lastTapDownPosition = null;
      _longPressTimer?.cancel();
      return;
    }

    _lastTapDownPosition = position;
    _lastTapTime = now;

    // ロングプレスタイマーを開始
    _longPressTimer?.cancel();
    _longPressTimer = Timer(_longPressTimeout, () {
      _longPressDetected = true;
      _handleLongPressDetected(event.position);
    });
  }

  String? _getLinkAtOffset(int targetOffset) {
    final controllerValue = _controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;

    // MarkdownFieldValue項目を走査
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      // 各MarkdownFieldValue内のブロックを走査
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        // 現時点では段落ブロックのみ処理
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          // 行を走査
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            // スパンを走査
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // ターゲットオフセットがこのスパン内にあるかチェック
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // このスパンがリンクプロパティを持つかチェック
                for (final property in span.properties) {
                  if (property is LinkMarkdownSpanProperty) {
                    return property.link;
                  }
                }
                return null;
              }

              currentOffset += spanLength;
            }

            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }

          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    return null;
  }

  /// Get the mention at the given offset.
  ///
  /// 指定されたオフセットにあるメンションを取得します。
  MarkdownMention? _getMentionAtOffset(int targetOffset) {
    final controllerValue = _controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;

    // MarkdownFieldValue項目を走査
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      // 各MarkdownFieldValue内のブロックを走査
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        // 現時点では段落ブロックのみ処理
        if (blockValue is MarkdownMultiLineBlockValue) {
          final multiLineBlock = blockValue;
          final lines = multiLineBlock.children;
          // 行を走査
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            // スパンを走査
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // ターゲットオフセットがこのスパン内にあるかチェック
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // このスパンがメンションプロパティを持つかチェック
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty) {
                    return property.mention;
                  }
                }
                return null;
              }

              currentOffset += spanLength;
            }

            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }

          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    return null;
  }

  /// Get the text range of a link at the given offset.
  ///
  /// 指定されたオフセットにあるリンクのテキスト範囲を取得します。
  TextRange? _getLinkRangeAtOffset(int targetOffset) {
    final controllerValue = _controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;
    String? targetLinkUrl;
    int? linkStart;
    int? linkEnd;

    // 第1パス: ターゲットオフセットでリンクURLを検索
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // ターゲットオフセットがこのスパン内にあるかチェック
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // このスパンがリンクプロパティを持つかチェック
                for (final property in span.properties) {
                  if (property is LinkMarkdownSpanProperty) {
                    targetLinkUrl = property.link;
                    break;
                  }
                }
                if (targetLinkUrl != null) {
                  break;
                }
              }

              currentOffset += spanLength;
            }
            if (targetLinkUrl != null) {
              break;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetLinkUrl != null) {
            break;
          }
          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
      if (targetLinkUrl != null) {
        break;
      }
    }

    // ターゲットオフセットでリンクが見つからない場合、nullを返す
    if (targetLinkUrl == null) {
      return null;
    }

    // 第2パス: 同じリンクURLを持つ連続したスパンの完全な範囲を検索
    currentOffset = 0;
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // このスパンが同じリンクURLを持つかチェック
              var hasTargetLink = false;
              for (final property in span.properties) {
                if (property is LinkMarkdownSpanProperty &&
                    property.link == targetLinkUrl) {
                  hasTargetLink = true;
                  break;
                }
              }

              if (hasTargetLink) {
                // リンク範囲を拡張
                linkStart ??= spanStart;
                // リンク範囲に末尾の改行を含めない
                linkEnd = spanEnd;
              } else if (linkStart != null) {
                // 連続したリンクスパンの終わりを見つけた
                // ただし、既にターゲットオフセットを通過している場合のみ返す
                if (currentOffset > targetOffset) {
                  return TextRange(start: linkStart, end: linkEnd!);
                }
                // 次の潜在的なリンク範囲のためにリセット
                linkStart = null;
                linkEnd = null;
              }

              currentOffset += spanLength;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    // 範囲が見つかった場合は返す
    if (linkStart != null && linkEnd != null) {
      return TextRange(start: linkStart, end: linkEnd);
    }

    return null;
  }

  /// Get the text range of a mention at the given offset.
  ///
  /// 指定されたオフセットにあるメンションのテキスト範囲を取得します。
  TextRange? _getMentionRangeAtOffset(int targetOffset) {
    final controllerValue = _controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;
    MarkdownMention? targetMention;
    int? mentionStart;
    int? mentionEnd;

    // 第1パス: ターゲットオフセットでメンションを検索
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // ターゲットオフセットがこのスパン内にあるかチェック
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // このスパンがメンションプロパティを持つかチェック
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty) {
                    targetMention = property.mention;
                    break;
                  }
                }
                if (targetMention != null) {
                  break;
                }
              }

              currentOffset += spanLength;
            }
            if (targetMention != null) {
              break;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetMention != null) {
            break;
          }
          // 各段落ブロック後に改行分+1（最後を除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
      if (targetMention != null) {
        break;
      }
    }

    // ターゲットオフセットでメンションが見つからない場合、nullを返す
    if (targetMention == null) {
      return null;
    }

    // 第2パス: 同じメンションを持つ連続したスパンの完全な範囲を検索
    // ただし同じブロック内のみ（メンションはブロック境界を越えられない）
    currentOffset = 0;
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          final blockStartOffset = currentOffset;
          var blockEndOffset = currentOffset;

          // ブロック終了オフセットを計算
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              blockEndOffset += span.value.length;
            }
            if (lineIndex < lines.length - 1) {
              blockEndOffset += 1; // newline within block
            }
          }

          // ターゲットオフセットがこのブロック内にあるかチェック
          final isTargetInThisBlock =
              targetOffset >= blockStartOffset && targetOffset < blockEndOffset;

          if (isTargetInThisBlock) {
            // このブロック内のみ検索
            var blockLocalOffset = currentOffset;
            for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
              final line = lines[lineIndex];
              for (final span in line.children) {
                final spanLength = span.value.length;
                final spanStart = blockLocalOffset;
                final spanEnd = blockLocalOffset + spanLength;

                // このスパンが同じメンションを持つかチェック
                var hasTargetMention = false;
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty &&
                      property.mention.id == targetMention.id) {
                    hasTargetMention = true;
                    break;
                  }
                }

                if (hasTargetMention) {
                  // メンション範囲を拡張
                  mentionStart ??= spanStart;
                  mentionEnd = spanEnd;
                } else if (mentionStart != null) {
                  // このブロック内の連続したメンションスパンの終わりを見つけた
                  return TextRange(start: mentionStart, end: mentionEnd!);
                }

                blockLocalOffset += spanLength;
              }
              if (lineIndex < lines.length - 1) {
                blockLocalOffset += 1;
              }
            }

            // ブロックの終わりに達してもメンション範囲がある場合、それを返す
            if (mentionStart != null && mentionEnd != null) {
              return TextRange(start: mentionStart, end: mentionEnd);
            }
          }

          // 次のブロックに移動
          currentOffset = blockEndOffset;
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1; // newline between blocks
          }
        }
      }
    }

    // 範囲が見つかった場合は返す
    if (mentionStart != null && mentionEnd != null) {
      return TextRange(start: mentionStart, end: mentionEnd);
    }

    return null;
  }

  /// Launch URL in the default browser or appropriate application.
  ///
  /// URLをデフォルトのブラウザまたは適切なアプリケーションで開きます。
  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }
    _onTapLink?.call(uri);
  }

  void _handleTapUp(PointerUpEvent event) {
    _longPressTimer?.cancel();
    _longPressTimer = null;

    // ハンドルドラッグフラグをリセット
    if (_isDraggingStartHandle || _isDraggingEndHandle) {
      _isDraggingStartHandle = false;
      _isDraggingEndHandle = false;
      return;
    }

    // ロングプレスまたはダブルタップが検出された場合、通常のタップとして処理しない
    if (_longPressDetected || _doubleTapDetected) {
      _longPressDetected = false;
      _doubleTapDetected = false;
      return;
    }

    if (_lastTapDownPosition == null) {
      return;
    }

    final position = globalToLocal(event.position);

    // ドラッグかチェック（タップダウン位置から離れすぎている）
    if ((position - _lastTapDownPosition!).distance > 10) {
      return;
    }

    final textOffset = _getTextOffsetForPosition(position);

    _onTap?.call();

    if (textOffset != null) {
      // リンクをタップしたかチェック
      final linkUrl = _getLinkAtOffset(textOffset);
      if (linkUrl != null && linkUrl.isNotEmpty) {
        // enabledとreadOnly状態に基づいて動作を決定

        if (!_enabled || _readOnly) {
          // 無効または読み取り専用の場合: リンクを開く
          _launchUrl(linkUrl);
        } else {
          // 有効で読み取り専用でない場合: リンクテキストを選択してダイアログを表示
          final linkRange = _getLinkRangeAtOffset(textOffset);
          if (linkRange != null) {
            // 500ms以内の重複呼び出しを防ぐ
            final now = DateTime.now().millisecondsSinceEpoch;
            if (now - _lastLinkDialogShowTime < 500) {
              return;
            }
            _lastLinkDialogShowTime = now;

            // リンクテキストを選択
            _onSelectionChanged(
              TextSelection(
                baseOffset: linkRange.start,
                extentOffset: linkRange.end,
              ),
              SelectionChangedCause.tap,
            );

            // コントローラーにリンクダイアログ表示を通知
            _controller.showLinkDialog(linkUrl);
          }
        }
        return;
      }

      // メンションをタップしたかチェック
      final mention = _getMentionAtOffset(textOffset);
      if (mention != null) {
        final mentionRange = _getMentionRangeAtOffset(textOffset);
        if (mentionRange != null) {
          // メンションテキストを選択
          _onSelectionChanged(
            TextSelection(
              baseOffset: mentionRange.start,
              extentOffset: mentionRange.end,
            ),
            SelectionChangedCause.tap,
          );

          // onTapMentionコールバックを呼び出す
          _onTapMention?.call(mention);
        }
        return;
      }

      // テキストをタップ、カーソル位置を設定
      _onSelectionChanged(
        TextSelection.collapsed(offset: textOffset),
        SelectionChangedCause.tap,
      );
    } else {
      // 空スペース（パディング/マージン）をタップ、選択をクリア
      _onSelectionChanged(
        const TextSelection.collapsed(offset: 0),
        SelectionChangedCause.tap,
      );
    }
  }

  void _handleDoubleTapDetected(Offset globalPosition) {
    final position = globalToLocal(globalPosition);
    final textOffset = _getTextOffsetForPosition(position);

    if (textOffset != null) {
      // 位置の単語を選択
      // IME入力中の変換テキストを含めるために_getPlainText()を使用
      final text = _getPlainText();

      final wordBoundary = _getWordBoundary(text, textOffset);

      _onSelectionChanged(
        TextSelection(
          baseOffset: wordBoundary.start,
          extentOffset: wordBoundary.end,
        ),
        SelectionChangedCause.doubleTap,
      );
    }
    // 空スペースをタップした場合でもonDoubleTapコールバックを呼び出す
    _onDoubleTap?.call(globalPosition);
  }

  void _handleLongPressDetected(Offset globalPosition) {
    final position = globalToLocal(globalPosition);
    final textOffset = _getTextOffsetForPosition(position);

    if (textOffset != null) {
      // 位置の単語を選択
      // IME入力中の変換テキストを含めるために_getPlainText()を使用
      final text = _getPlainText();

      final wordBoundary = _getWordBoundary(text, textOffset);

      _onSelectionChanged(
        TextSelection(
          baseOffset: wordBoundary.start,
          extentOffset: wordBoundary.end,
        ),
        SelectionChangedCause.longPress,
      );
    }
    // 空スペースを押した場合でもonLongPressコールバックを呼び出す
    _onLongPress?.call(globalPosition);
  }

  TextRange _getWordBoundary(String text, int offset) {
    // 単語境界検出

    // 空テキストまたは無効なオフセットを処理
    if (text.isEmpty || offset < 0 || offset > text.length) {
      return TextRange.empty;
    }

    var start = offset;
    var end = offset;

    // 単語の開始を検索
    while (start > 0 &&
        start <= text.length &&
        !_isWordBoundary(text[start - 1])) {
      start--;
    }

    // 単語の終了を検索
    while (end < text.length && !_isWordBoundary(text[end])) {
      end++;
    }

    return TextRange(start: start, end: end);
  }

  bool _isWordBoundary(String char) {
    // 空白、句読点を単語境界として考慮
    return char == " " ||
        char == "\n" ||
        char == "\t" ||
        char == "." ||
        char == "," ||
        char == "!" ||
        char == "?" ||
        char == ";" ||
        char == ":" ||
        char == "-" ||
        char == "(" ||
        char == ")" ||
        char == "[" ||
        char == "]" ||
        char == "{" ||
        char == "}" ||
        char == "<" ||
        char == ">" ||
        char == "/" ||
        char == "\\" ||
        char == "|" ||
        char == "@" ||
        char == "#" ||
        char == "\$" ||
        char == "%" ||
        char == "^" ||
        char == "&" ||
        char == "*" ||
        char == "+" ||
        char == "=" ||
        char == "~" ||
        char == "`" ||
        char == "\"" ||
        char == "'";
  }

  void _handleDragUpdate(PointerMoveEvent event) {
    final position = globalToLocal(event.position);

    // 選択ハンドルのドラッグを処理
    if (_isDraggingStartHandle || _isDraggingEndHandle) {
      final textOffset = _getTextOffsetForPosition(position);

      if (textOffset != null) {
        if (_isDraggingStartHandle) {
          // 選択の開始を更新
          final newStart = textOffset.clamp(0, _selection.end);
          _onSelectionChanged(
            TextSelection(
              baseOffset: newStart,
              extentOffset: _selection.end,
            ),
            SelectionChangedCause.drag,
          );
        } else if (_isDraggingEndHandle) {
          // 選択の終了を更新
          final newEnd =
              textOffset.clamp(_selection.start, _getPlainText().length);
          _onSelectionChanged(
            TextSelection(
              baseOffset: _selection.start,
              extentOffset: newEnd,
            ),
            SelectionChangedCause.drag,
          );
        }
      }
      // ハンドル位置を更新するために強制的に再描画
      markNeedsPaint();
      return;
    }

    if (_lastTapDownPosition == null) {
      return;
    }

    // 離れすぎた場合はロングプレスをキャンセル
    if ((position - _lastTapDownPosition!).distance > 10) {
      _longPressTimer?.cancel();
      _longPressTimer = null;
    }

    final textOffset = _getTextOffsetForPosition(position);

    // ドラッグがテキストエリア内の場合のみ選択を更新
    if (textOffset != null) {
      if (_selection.isCollapsed) {
        // タップダウン位置から選択を開始
        final downOffset = _getTextOffsetForPosition(_lastTapDownPosition!);
        if (downOffset != null) {
          _onSelectionChanged(
            TextSelection(
              baseOffset: downOffset,
              extentOffset: textOffset,
            ),
            SelectionChangedCause.drag,
          );
        }
      } else {
        // 選択を拡張
        _onSelectionChanged(
          TextSelection(
            baseOffset: _selection.baseOffset,
            extentOffset: textOffset,
          ),
          SelectionChangedCause.drag,
        );
      }
    }
  }

  String _getPlainText() {
    // 変換テキストが存在する場合、IME変換中の表示に使用
    if (_composingText != null && _composingText!.isNotEmpty) {
      return _composingText!;
    }
    return _controller.rawText;
  }
}

/// Layout information for a single markdown block.
///
/// 単一のマークダウンブロックのレイアウト情報。
class BlockLayout {
  /// Layout information for a single markdown block.
  ///
  /// 単一のマークダウンブロックのレイアウト情報。
  BlockLayout({
    required this.block,
    required this.painter,
    required this.textOffset,
    required this.textLength,
    required this.padding,
    required this.margin,
    required this.spans,
    this.children,
    this.marker,
  });

  /// The markdown block.
  ///
  /// マークダウンブロック。
  final MarkdownBlockValue block;

  /// Text painter for this block.
  ///
  /// このブロックのテキストペインター。
  final TextPainter painter;

  /// Text offset in the overall document.
  ///
  /// ドキュメント全体でのテキストオフセット。
  final int textOffset;

  /// Length of text in this block.
  ///
  /// このブロックのテキストの長さ。
  final int textLength;

  /// Padding for this block.
  ///
  /// このブロックのパディング。
  final EdgeInsets padding;

  /// Margin for this block.
  ///
  /// このブロックのマージン。
  final EdgeInsets margin;

  /// Spans with their local offsets and lengths.
  ///
  /// ローカルオフセットと長さを持つスパン。
  final List<SpanInfo> spans;

  /// Marker information for list blocks.
  ///
  /// リストブロックのマーカー情報。
  final MarkerInfo? marker;

  /// Child blocks.
  ///
  /// 子ブロック。
  final List<BlockLayout>? children;

  /// Offset where this block is positioned.
  ///
  /// このブロックが配置されるオフセット。
  Offset offset = Offset.zero;

  /// Height of this block including padding and margin.
  ///
  /// パディングとマージンを含むこのブロックの高さ。
  double height = 0;
}

/// Block style information.
///
/// ブロックスタイル情報。
class BlockStyle {
  /// Block style information.
  ///
  /// ブロックスタイル情報。
  const BlockStyle({
    this.backgroundColor,
    this.border,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.highlightColor,
  });

  /// Background color of the block.
  ///
  /// ブロックの背景色。
  final Color? backgroundColor;

  /// Highlight color of the block.
  ///
  /// ブロックのハイライト色。
  final Color? highlightColor;

  /// Border of the block.
  ///
  /// ブロックの境界線。
  final Border? border;

  /// Text style of the block.
  ///
  /// ブロックのテキストスタイル。
  final TextStyle? textStyle;

  /// Padding of the block.
  ///
  /// ブロックのパディング。
  final EdgeInsetsGeometry padding;

  /// Margin of the block.
  ///
  /// ブロックのマージン。
  final EdgeInsetsGeometry margin;
}

/// Information about a list marker.
///
/// リストマーカーに関する情報。
class MarkerInfo {
  /// Information about a list marker.
  ///
  /// リストマーカーに関する情報。
  const MarkerInfo({
    required this.markerBuilder,
    required this.width,
    this.onTapMarker,
  });

  /// Builder function to draw the marker.
  ///
  /// マーカーを描画するためのビルダーファンクション。
  final void Function(Canvas canvas, Offset offset)? markerBuilder;

  /// The marker symbol (e.g., "• ").
  ///
  /// マーカーシンボル(例: "• ")。
  // final String symbol;

  /// Width of the marker area.
  ///
  /// マーカー領域の幅。
  final double width;

  /// Callback when the marker is tapped.
  ///
  /// マーカーがタップされた時のコールバック。
  final void Function()? onTapMarker;
}

/// Information about a span in a block.
///
/// ブロック内のスパンに関する情報。
class SpanInfo {
  /// Information about a span in a block.
  ///
  /// ブロック内のスパンに関する情報。
  SpanInfo({
    required this.span,
    required this.localOffset,
    required this.length,
  });

  /// The markdown span.
  ///
  /// マークダウンスパン。
  final MarkdownSpanValue span;

  /// Local offset within the block.
  ///
  /// ブロック内のローカルオフセット。
  final int localOffset;

  /// Length of the span text.
  ///
  /// スパンテキストの長さ。
  final int length;
}

/// Information about a merged decoration group.
///
/// マージされた装飾グループに関する情報。
class _DecorationGroup {
  _DecorationGroup({
    required this.decoration,
    required this.start,
    required this.end,
  });

  /// The background decoration.
  ///
  /// 背景装飾。
  final BoxDecoration decoration;

  /// Start offset of the group.
  ///
  /// グループの開始オフセット。
  final int start;

  /// End offset of the group.
  ///
  /// グループの終了オフセット。
  final int end;
}

/// Context for rendering.
///
/// レンダリングのコンテキスト。
abstract class RenderContext {
  /// Context for rendering.
  ///
  /// レンダリングのコンテキスト。
  const RenderContext();

  /// Focus node for the editor.
  ///
  /// エディタのフォーカスノード。
  FocusNode get focusNode;

  /// Selection for the editor.
  ///
  /// エディタの選択。
  TextSelection get selection;

  /// Composing region for the editor.
  ///
  /// エディタのコンポージングリージョン。
  TextSelection? get composingRegion;

  /// Whether to show the cursor.
  ///
  /// カーソルを表示するかどうか。
  bool get showCursor;

  /// Whether to expand the editor.
  ///
  /// エディタを展開するかどうか。
  bool get expands;

  /// Style for the editor.
  ///
  /// エディタのスタイル。
  TextStyle get style;

  /// Width of the cursor.
  ///
  /// カーソルの幅。
  double get cursorWidth;

  /// Height of the cursor.
  ///
  /// カーソルの高さ。
  double? get cursorHeight;

  /// Radius of the cursor.
  ///
  /// カーソルの半径。
  Radius? get cursorRadius;

  /// Color of the cursor.
  ///
  /// カーソルの色。
  Color get cursorColor;

  /// Color of the selection.
  ///
  /// 選択の色。
  Color get selectionColor;

  /// App theme of the editor.
  ///
  /// アプリのテーマ。
  ThemeData get theme;

  /// Alignment of the text.
  ///
  /// テキストの配置。
  TextAlign get textAlign;

  /// Direction of the text.
  ///
  /// テキストの方向。
  TextDirection get textDirection;

  /// Width basis of the text.
  ///
  /// テキストの幅の基準。
  TextWidthBasis get textWidthBasis;

  /// Height behavior of the text.
  ///
  /// テキストの高さの振る舞い。
  TextHeightBehavior? get textHeightBehavior;

  /// Strut style of the text.
  ///
  /// テキストのストライドスタイル。
  StrutStyle? get strutStyle;
}
