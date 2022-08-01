part of masamune;

extension WidgetRefFocusNodeExtensions on WidgetRef {
  FocusNode useFocusNode(
    String key, [
    bool autoFocus = true,
    List<FutureOr<dynamic>?>? waitingFutures,
  ]) {
    return valueBuilder<FocusNode, _FocusNodeValue>(
      key: "focusNode:$key",
      builder: () {
        return _FocusNodeValue(
          autoFocus: autoFocus,
          waitingFutures: waitingFutures,
        );
      },
    );
  }
}

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
