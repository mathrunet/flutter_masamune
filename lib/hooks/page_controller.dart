part of masamune;

extension WidgetRefPageControllerExtensions on WidgetRef {
  PageController usePageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) {
    return valueBuilder<PageController, _PageControllerValue>(
      key: "pageController",
      builder: () {
        return _PageControllerValue(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );
      },
    );
  }
}

@immutable
class _PageControllerValue extends ScopedValue<PageController> {
  const _PageControllerValue({
    this.initialPage = 0,
    this.keepPage = true,
    this.viewportFraction = 1.0,
  });
  final int initialPage;
  final bool keepPage;
  final double viewportFraction;

  @override
  ScopedValueState<PageController, _PageControllerValue> createState() {
    return _PageControllerValueState();
  }
}

class _PageControllerValueState
    extends ScopedValueState<PageController, _PageControllerValue> {
  late final PageController _controller;

  @override
  void initValue() {
    super.initValue();
    _controller = PageController(
      initialPage: value.initialPage,
      keepPage: value.keepPage,
      viewportFraction: value.viewportFraction,
    );
    _controller.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  PageController build() => _controller;
}
