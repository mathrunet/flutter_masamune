part of masamune;

FocusNode useAutoFocusNode([bool autoFocus = true]) {
  final focusNode = useFocusNode();
  useEffect(
    () {
      if (autoFocus) {
        focusNode.requestFocus();
      }
      return () {};
    },
    [focusNode],
  );
  return focusNode;
}

extension WidgetRefFocusNodeExtensions on WidgetRef {
  FocusNode useFocusNode(String key, [bool autoFocus = true]) {
    return valueBuilder<FocusNode, _FocusNodeValue>(
      key: "focusNode:$key",
      builder: () {
        return _FocusNodeValue(
          autoFocus: autoFocus,
        );
      },
    );
  }
}

@immutable
class _FocusNodeValue extends ScopedValue<FocusNode> {
  const _FocusNodeValue({this.autoFocus = true});

  final bool autoFocus;
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
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  FocusNode build() => focusNode;
}
