part of masamune;

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
