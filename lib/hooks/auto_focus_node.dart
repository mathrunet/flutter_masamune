part of masamune;

FocusNode useAutoFocusNode() {
  final focusNode = useFocusNode();
  useEffect(
    () {
      focusNode.requestFocus();
      return () {};
    },
    [focusNode],
  );
  return focusNode;
}
