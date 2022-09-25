part of masamune;

@deprecated
extension WidgetRefNavigatorControllerExtensions on WidgetRef {
  @Deprecated(
    "It will not be available from the next version. Use [NavigatorControllerProvider] instead.",
  )
  NavigatorController useNavigatorController([
    String? initialRoute,
    bool Function(String routeName)? showEmptyPage,
  ]) {
    return valueBuilder<NavigatorController, _NavigatorControllerValue>(
      key: "navigatorController",
      builder: () {
        return _NavigatorControllerValue(
          initialRoute: initialRoute,
          showEmptyPage: showEmptyPage,
        );
      },
    );
  }
}

@deprecated
@immutable
class _NavigatorControllerValue extends ScopedValue<NavigatorController> {
  const _NavigatorControllerValue({
    required this.initialRoute,
    required this.showEmptyPage,
  });
  final String? initialRoute;
  final bool Function(String routeName)? showEmptyPage;
  @override
  ScopedValueState<NavigatorController, ScopedValue<NavigatorController>>
      createState() => _NavigatorControllerValueState();
}

@deprecated
class _NavigatorControllerValueState
    extends ScopedValueState<NavigatorController, _NavigatorControllerValue> {
  late final NavigatorController _controller;
  @override
  void initValue() {
    super.initValue();
    _controller = NavigatorController(value.initialRoute, value.showEmptyPage);
    _controller.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  @override
  NavigatorController build() => _controller;

  void _handledOnUpdate() {
    setState(() {});
  }
}
