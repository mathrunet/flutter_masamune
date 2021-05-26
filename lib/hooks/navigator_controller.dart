part of masamune;

class _NavigatorControllerHookCreator {
  const _NavigatorControllerHookCreator();
  NavigatorController call([String? initialRoute]) {
    return use(_NavigatorControllerHook(initialRoute));
  }
}

const useNavigatorController = _NavigatorControllerHookCreator();

class _NavigatorControllerHook extends Hook<NavigatorController> {
  const _NavigatorControllerHook([this.initialRoute]);
  final String? initialRoute;

  @override
  _NavigatorControllerHookState createState() {
    return _NavigatorControllerHookState(initialRoute);
  }
}

class _NavigatorControllerHookState
    extends HookState<NavigatorController, _NavigatorControllerHook> {
  _NavigatorControllerHookState(String? initialRoute)
      : _controller = NavigatorController(initialRoute);
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
