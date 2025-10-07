part of "/katana_form.dart";

/// Builder to hold and provide [FocusNode].
///
/// フォーカスノードを保持して提供するためのビルダー。
/// フォーカス状態を管理し、フォーカスの取得・解放時の処理を実装できます。
///
/// ## ビルダーの使用方法
///
/// Pass [FormTextField], etc. to [builder].
///
/// [builder]に[FormTextField]などを渡してください。
///
/// The [FocusNode] is passed to the builder's [focusNode] parameter.
///
/// ビルダーの[focusNode]パラメータに[FocusNode]が渡されます。
///
/// ## 基本的な使用例
///
/// ```dart
/// FormFocusNodeBuilder(
///   builder: (context, focusNode) {
///     return FormTextField(
///       form: form,
///       focusNode: focusNode,
///       initialValue: form.value.text,
///       onSaved: (value) => form.value.copyWith(text: value),
///     );
///   },
/// );
/// ```
///
/// ## カスタムデザインの使用例
///
/// ```dart
/// FormFocusNodeBuilder(
///   style: const FormStyle(
///     padding: EdgeInsets.all(16.0),
///   ),
///   builder: (context, focusNode) {
///     return FormTextField(
///       form: form,
///       focusNode: focusNode,
///       initialValue: form.value.text,
///       onSaved: (value) => form.value.copyWith(text: value),
///     );
///   },
/// );
/// ```
class FormFocusNodeBuilder extends StatefulWidget {
  /// Builder to hold and provide [FocusNode].
  ///
  /// フォーカスノードを保持して提供するためのビルダー。
  /// フォーカス状態を管理し、フォーカスの取得・解放時の処理を実装できます。
  ///
  /// ## ビルダーの使用方法
  ///
  /// Pass [FormTextField], etc. to [builder].
  ///
  /// [builder]に[FormTextField]などを渡してください。
  ///
  /// The [FocusNode] is passed to the builder's [focusNode] parameter.
  ///
  /// ビルダーの[focusNode]パラメータに[FocusNode]が渡されます。
  ///
  /// ## 基本的な使用例
  ///
  /// ```dart
  /// FormFocusNodeBuilder(
  ///   builder: (context, focusNode) {
  ///     return FormTextField(
  ///       form: form,
  ///       focusNode: focusNode,
  ///       initialValue: form.value.text,
  ///       onSaved: (value) => form.value.copyWith(text: value),
  ///     );
  ///   },
  /// );
  /// ```
  ///
  /// ## カスタムデザインの使用例
  ///
  /// ```dart
  /// FormFocusNodeBuilder(
  ///   style: const FormStyle(
  ///     padding: EdgeInsets.all(16.0),
  ///   ),
  ///   builder: (context, focusNode) {
  ///     return FormTextField(
  ///       form: form,
  ///       focusNode: focusNode,
  ///       initialValue: form.value.text,
  ///       onSaved: (value) => form.value.copyWith(text: value),
  ///     );
  ///   },
  /// );
  /// ```
  const FormFocusNodeBuilder({
    required this.builder,
    super.key,
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
