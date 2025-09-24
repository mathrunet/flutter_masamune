part of "/masamune_painter.dart";

const _kToolbarHeight = kToolbarHeight;

/// Markdown toolbar.
///
/// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
///
/// Design and wording can be changed via [MarkdownMasamuneAdapter.toolsConfig].
///
/// By specifying [mentionBuilder], a list of mentions can be displayed.
///
/// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
/// You can insert image and video media.
/// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
///
/// Painter用のツールバー。
///
/// [PainterController]を渡し同じコントローラーを[FormPainterField]に渡してください。
///
/// デザイン及び文言は[MarkdownMasamuneAdapter.toolsConfig]経由で変更されます。
///
/// [mentionBuilder]を指定することでメンションのリストを表示することができます。
///
/// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
/// 画像や映像のメディアを挿入することができます。
/// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
class FormPainterToolbar extends StatefulWidget {
  /// Markdown toolbar.
  ///
  /// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
  ///
  /// Design and wording can be changed via [MarkdownMasamuneAdapter.toolsConfig].
  ///
  /// By specifying [mentionBuilder], a list of mentions can be displayed.
  ///
  /// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
  /// You can insert image and video media.
  /// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
  ///
  /// Markdown用のツールバー。
  ///
  /// [MarkdownController]を渡し同じコントローラーを[FormMarkdownField]に渡してください。
  ///
  /// デザイン及び文言は[MarkdownMasamuneAdapter.toolsConfig]経由で変更されます。
  ///
  /// [mentionBuilder]を指定することでメンションのリストを表示することができます。
  ///
  /// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
  /// 画像や映像のメディアを挿入することができます。
  /// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
  const FormPainterToolbar({
    required this.controller,
    this.primaryTools,
    this.secondaryTools,
    super.key,
    this.style,
  });

  /// Primary tools for the toolbar.
  ///
  /// ツールバーのプライマリーツール。
  final List<PainterPrimaryTools>? primaryTools;

  /// Secondary tools for the toolbar.
  ///
  /// ツールバーのセカンダリーツール。
  final List<PainterSecondaryTools>? secondaryTools;

  /// [PainterController] for the toolbar.
  ///
  /// Pass the same one to [FormPainterField].
  ///
  /// ツールバー用の[PainterController]。
  ///
  /// 同じものを[FormPainterField]に渡します。
  final PainterController controller;

  /// Style of the toolbar.
  ///
  /// ツールバーのスタイル。
  final FormStyle? style;

  @override
  State<FormPainterToolbar> createState() => _FormPainterToolbarState();
}

class _FormPainterToolbarState extends State<FormPainterToolbar>
    implements PainterToolRef {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerStateOnChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerStateOnChanged);
    super.dispose();
  }

  @override
  bool get canPaste => false;

  @override
  PaintingValue? get currentValue => widget.controller._currentValue;

  @override
  PainterTools? get currentTool => _currentTool;
  PainterTools? _currentTool;

  @override
  void toggleMode(PainterTools tool) {
    setState(() {
      _currentTool = tool;
    });
  }

  @override
  void deleteMode() {
    setState(() {
      _currentTool = null;
    });
  }

  void _handleControllerStateOnChanged() {}

  Iterable<Widget> _buildPrimaryTools(BuildContext context, ThemeData theme) {
    final primaryTools =
        widget.primaryTools ?? widget.controller.adapter.defaultPrimaryTools;
    return primaryTools.mapAndRemoveEmpty((e) {
      if (!e.shown(context, this)) {
        return null;
      }
      if (!e.enabled(context, this)) {
        return IconButton(
          onPressed: null,
          icon: e.icon(context, this),
        );
      } else if (e.actived(context, this)) {
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
    });
  }

  Iterable<Widget> _buildSecondaryTools(BuildContext context, ThemeData theme) {
    final secondaryTools = widget.secondaryTools ??
        widget.controller.adapter.defaultSecondaryTools;
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
    List<PainterInlineTools> tools,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inlineTools =
        _currentTool != null && _currentTool is PainterPrimaryTools
            ? (_currentTool as PainterPrimaryTools).tools
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
        child: Container(
          color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
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
                      if (inlineTools != null) ...[
                        ..._buildInlineTools(context, theme, inlineTools),
                      ] else ...[
                        ..._buildPrimaryTools(context, theme),
                      ],
                    ],
                  ),
                ),
              ),
              ..._buildSecondaryTools(context, theme),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reference class for Painter tools.
///
/// 描画ツールの参照クラス。
abstract class PainterToolRef {
  const PainterToolRef._();

  /// Toggle the mode.
  ///
  /// モードを切り替えます。
  void toggleMode(PainterTools tool);

  /// Delete the mode.
  ///
  /// モードを削除します。
  void deleteMode();

  /// Get the current mode.
  ///
  /// 現在のモードを取得します。
  PainterTools? get currentTool;

  /// Get the current value.
  ///
  /// 現在の値を取得します。
  PaintingValue? get currentValue;

  /// Check if the clipboard can be pasted.
  ///
  /// クリップボードに貼り付け可能かどうかを確認します。
  bool get canPaste;
}
