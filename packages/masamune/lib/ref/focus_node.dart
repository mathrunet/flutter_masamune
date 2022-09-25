part of masamune;

@deprecated
extension WidgetRefFocusNodeExtensions on WidgetRef {
  @Deprecated(
    "It will not be available from the next version. Use [FocusNodeProvider] instead.",
  )
  FocusNode useFocusNode({
    bool autoFocus = true,
    String hookId = "",
    List<FutureOr<dynamic>?>? waitingFutures,
  }) {
    return valueBuilder<FocusNode, _FocusNodeValue>(
      key: "focusNode:$hookId",
      builder: () {
        return _FocusNodeValue(
          autoFocus: autoFocus,
          waitingFutures: waitingFutures,
        );
      },
    );
  }
}

@deprecated
@immutable
class _FocusNodeValue extends ScopedValue<FocusNode> {
  const _FocusNodeValue({
    this.autoFocus = true,
    this.waitingFutures,
  });

  final bool autoFocus;
  final List<FutureOr<dynamic>?>? waitingFutures;
  @override
  ScopedValueState<FocusNode, ScopedValue<FocusNode>> createState() =>
      _FocusNodeValueState();
}

@deprecated
class _FocusNodeValueState
    extends ScopedValueState<FocusNode, _FocusNodeValue> {
  final FocusNode focusNode = FocusNode();

  @override
  void initValue() {
    super.initValue();
    if (value.autoFocus) {
      _autoFocus();
    }
  }

  Future<void> _autoFocus() async {
    if (value.waitingFutures != null) {
      await Future.wait(
        value.waitingFutures!.whereType<Future>().removeEmpty(),
      );
    }
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  FocusNode build() => focusNode;
}
