part of "/masamune_markdown.dart";

/// Controller for [FormMarkdownField].
///
/// By passing this, you can integrate with [FormMarkdownToolbar] tools.
///
/// Also, you can control multiple [FormMarkdownField] instances with a single [FormMarkdownToolbar] tool.
///
/// [FormMarkdownField]用のコントローラー。
///
/// これを渡すことで[FormMarkdownToolbar]のツールと連携することができます。
///
/// また、複数の[FormMarkdownField]を一つの[FormMarkdownToolbar]のツールでコントロールすることができます。
class MarkdownController extends MasamuneControllerBase<List<TextEditingValue>,
    MarkdownMasamuneAdapter> {
  /// Controller for [FormMarkdownField].
  ///
  /// By passing this, you can integrate with [FormMarkdownToolbar] tools.
  ///
  /// Also, you can control multiple [FormMarkdownField] instances with a single [FormMarkdownToolbar] tool.
  ///
  /// [FormMarkdownField]用のコントローラー。
  ///
  /// これを渡すことで[FormMarkdownToolbar]のツールと連携することができます。
  ///
  /// また、複数の[FormMarkdownField]を一つの[FormMarkdownToolbar]のツールでコントロールすることができます。
  MarkdownController({super.adapter});

  /// Query for MarkdownController.
  ///
  /// ```dart
  /// appRef.controller(MarkdownController.query(parameters));     // Get from application scope.
  /// ref.app.controller(MarkdownController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(MarkdownController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$MarkdownControllerQuery();

  @override
  MarkdownMasamuneAdapter get primaryAdapter => MarkdownMasamuneAdapter.primary;

  @override
  List<TextEditingValue>? get value => [
        ..._states.map(
          (state) => TextEditingValue(
              text: state._text ?? "", selection: state._controller.selection),
        ),
      ];

  final Set<FormMarkdownFieldState> _states = {};
  FormMarkdownFieldState? _latestState;

  /// Get the last state.
  ///
  /// 最後にフォーカスした状態を取得します。
  FormMarkdownFieldState? get lastState {
    return _latestState;
  }

  /// Get the last controller.
  ///
  /// 最後にフォーカスしたコントローラーを取得します。
  QuillController? get lastController {
    return _latestState?._controller;
  }

  /// Get the last focus node.
  ///
  /// 最後にフォーカスしたフォーカスノードを取得します。
  FocusNode? get lastFocusNode {
    return _latestState?._effectiveFocusNode;
  }

  /// Get the focused state.
  ///
  /// フォーカスされている状態を取得します。
  FormMarkdownFieldState? get focuedState {
    return _states.firstWhereOrNull(
      (state) => state._effectiveFocusNode.hasFocus,
    );
  }

  /// Get the controller.
  ///
  /// コントローラーを取得します。
  QuillController? get focusedController {
    return focuedState?._controller;
  }

  /// Get the focused focus node.
  ///
  /// フォーカスされているフォーカスノードを取得します。
  FocusNode? get focusedFocusNode {
    return focuedState?._effectiveFocusNode;
  }

  /// Get the focused selection.
  ///
  /// フォーカスされている選択範囲を取得します。
  TextSelection? get focusedSelection {
    return focuedState?._controller.selection;
  }

  /// This is used to control the focus of the markdown controller.
  ///
  /// これは、markdownコントローラーのフォーカスを制御するために使用されます。
  final FocusNode focusNode = FocusNode();

  void _registerState(FormMarkdownFieldState state) {
    _states.add(state);
    state._controller.addListener(_handleQuillControllerOnChanged);
  }

  void _unregisterState(FormMarkdownFieldState state) {
    state._controller.removeListener(_handleQuillControllerOnChanged);
    _states.remove(state);
  }

  void _handleQuillControllerOnChanged() {
    notifyListeners();
  }

  /// Focus the last field.
  ///
  /// 最後のフィールドにフォーカスを当てます。
  Future<void> focusLastField() async {
    await Future.delayed(const Duration(milliseconds: 50));
    lastState?.quillEditorState?.editableTextKey.currentState?.renderEditor
      ?..selectPosition(cause: SelectionChangedCause.tap)
      ..onSelectionCompleted();
    lastState?.quillEditorState?.editableTextKey.currentState
        ?.requestKeyboard();
    // フォーカスがあたっても編集できないため回避のためにもう１回実行
    await Future.delayed(const Duration(milliseconds: 50));
    lastState?.quillEditorState?.editableTextKey.currentState?.renderEditor
      ?..selectPosition(cause: SelectionChangedCause.tap)
      ..onSelectionCompleted();
    lastState?.quillEditorState?.editableTextKey.currentState
        ?.requestKeyboard();
  }

  /// Insert image.
  ///
  /// 画像を挿入します。
  void insertImage(Uri uri) {
    final state = lastState;
    if (state == null) {
      return;
    }
    state._controller.insertImage(uri);
  }

  /// Insert video.
  ///
  /// ビデオを挿入します。
  void insertVideo(Uri uri) {
    final state = lastState;
    if (state == null) {
      return;
    }
    state._controller.insertVideo(uri);
  }
}

@immutable
class _$MarkdownControllerQuery {
  const _$MarkdownControllerQuery();

  @useResult
  _$_MarkdownControllerQuery call({MarkdownMasamuneAdapter? adapter}) =>
      _$_MarkdownControllerQuery(
        hashCode.toString(),
        adapter: adapter,
      );
}

@immutable
class _$_MarkdownControllerQuery
    extends ControllerQueryBase<MarkdownController> {
  const _$_MarkdownControllerQuery(this._name, {this.adapter});

  final String _name;

  final MarkdownMasamuneAdapter? adapter;

  @override
  MarkdownController Function() call(Ref ref) {
    return () => MarkdownController(adapter: adapter);
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
