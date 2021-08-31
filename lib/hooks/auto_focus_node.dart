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
