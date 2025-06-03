part of "/katana_form.dart";

/// Builder to hold and provide [FocusNode].
///
/// Pass [FormTextField], etc. to [builder].
///
/// [FocusNode]を保持して提供するためのビルダー。
///
/// [builder]に[FormTextField]などを渡してください。
class FormFocusNodeBuilder extends StatefulWidget {
  /// Builder to hold and provide [FocusNode].
  ///
  /// Pass [FormTextField], etc. to [builder].
  ///
  /// [FocusNode]を保持して提供するためのビルダー。
  ///
  /// [builder]に[FormTextField]などを渡してください。
  const FormFocusNodeBuilder({
    super.key,
    required this.builder,
    this.focusNode,
    this.style,
  });

  /// Builder for the field.
  ///
  /// [FocusNode] is passed to [focusNode].
  ///
  /// フィールド用のビルダー。
  ///
  /// [focusNode]に[FocusNode]が渡されます。
  final Widget Function(BuildContext context, FocusNode focusNode) builder;

  /// Focus node to be passed by default.
  ///
  /// If this is specified, this focus node will be used.
  ///
  /// デフォルトで渡すフォーカスノード。
  ///
  /// こちらを指定するとこのフォーカスノードが使われます。
  final FocusNode? focusNode;

  /// Field style.
  ///
  /// フィールドのスタイル。
  final FormStyle? style;

  @override
  State<StatefulWidget> createState() => _FormFocusNodeBuilderState();
}

class _FormFocusNodeBuilderState extends State<FormFocusNodeBuilder> {
  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode {
    if (widget.focusNode != null) {
      return widget.focusNode!;
    }
    return _focusNode ??= FocusNode();
  }

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_onHandledUpdate);
  }

  @override
  void didUpdateWidget(FormFocusNodeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode?.removeListener(_onHandledUpdate);
      oldWidget.focusNode?.removeListener(_onHandledUpdate);
      _effectiveFocusNode.addListener(_onHandledUpdate);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onHandledUpdate);
    super.dispose();
  }

  void _onHandledUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == null) {
      return widget.builder(context, _effectiveFocusNode);
    }
    return FormContainer(
      style: widget.style,
      child: widget.builder(context, _effectiveFocusNode),
    );
  }
}
