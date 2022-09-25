part of masamune;

@deprecated
extension WidgetRefScrollControllerExtensions on WidgetRef {
  @Deprecated(
    "It will not be available from the next version. Use [ScrollControllerProvider] instead.",
  )
  ScrollController useScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) {
    return valueBuilder<ScrollController, _ScrollControllerValue>(
      key: "scrollController",
      builder: () {
        return _ScrollControllerValue(
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
          debugLabel: debugLabel,
        );
      },
    );
  }
}

@deprecated
@immutable
class _ScrollControllerValue extends ScopedValue<ScrollController> {
  const _ScrollControllerValue({
    this.initialScrollOffset = 0.0,
    this.keepScrollOffset = true,
    this.debugLabel,
  });
  final double initialScrollOffset;
  final bool keepScrollOffset;
  final String? debugLabel;
  @override
  ScopedValueState<ScrollController, ScopedValue<ScrollController>>
      createState() => _ScrollControllerValueState();
}

@deprecated
class _ScrollControllerValueState
    extends ScopedValueState<ScrollController, _ScrollControllerValue> {
  late final ScrollController _controller;

  @override
  void initValue() {
    super.initValue();
    _controller = ScrollController(
      initialScrollOffset: value.initialScrollOffset,
      keepScrollOffset: value.keepScrollOffset,
      debugLabel: value.debugLabel,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  ScrollController build() => _controller;
}
