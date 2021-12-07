part of masamune;

extension WidgetRefNavigatorControllerExtensions on WidgetRef {
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

class _NavigatorControllerHookCreator {
  const _NavigatorControllerHookCreator();
  NavigatorController call([
    String? initialRoute,
    bool Function(String routeName)? showEmptyPage,
  ]) {
    return use(_NavigatorControllerHook(initialRoute, showEmptyPage));
  }
}

const useNavigatorController = _NavigatorControllerHookCreator();

class _NavigatorControllerHook extends Hook<NavigatorController> {
  _NavigatorControllerHook([
    this.initialRoute,
    this.showEmptyPage,
  ]) : super(keys: [initialRoute]);
  final String? initialRoute;
  final bool Function(String routeName)? showEmptyPage;

  @override
  _NavigatorControllerHookState createState() {
    return _NavigatorControllerHookState(initialRoute, showEmptyPage);
  }
}

class _NavigatorControllerHookState
    extends HookState<NavigatorController, _NavigatorControllerHook> {
  _NavigatorControllerHookState(
      String? initialRoute, bool Function(String routeName)? showEmptyPage)
      : _controller = NavigatorController(initialRoute, showEmptyPage);
  final NavigatorController _controller;
  @override
  void initHook() {
    super.initHook();
    _controller.addListener(_handleOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handleOnUpdate);
  }

  @override
  NavigatorController build(BuildContext context) => _controller;

  void _handleOnUpdate() {
    setState(() {});
  }

  @override
  String get debugLabel => 'useNavigatorController';
}
