part of flutter_runtime_database;

/// Base class for handling page transitions.
///
/// Since it inherits from [StatefulHookWidget],
/// you can use [useProvider] or other methods to get the state.
///
/// Between pages,
/// you can use [this.data] to get the data on that page in document format.
///
/// You can use Hooks just like normal HookWidget.
abstract class UIPage extends StatefulHookWidget with UIPageDataMixin {
  /// Root observer.
  ///
  /// ```dart
  /// return new MaterialApp(
  ///   ...
  ///   navigatorObservers: <NavigatorObserver>[UIPage.routeObserver],
  ///   ...
  /// );
  /// ```
  static RouteObserver<PageRoute> get routeObserver => _routeObserver;
  static RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

  /// The closest instance of this class that encloses the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// UIPageState state = UIPage.of(context);
  /// ```
  ///
  /// [context]: Build context.
  static UIPageState of(BuildContext context) {
    final _UIPageScope scope =
        context.getElementForInheritedWidgetOfExactType<_UIPageScope>()?.widget;
    return scope?.state;
  }

  final BuildEvent _init;
  final BuildEvent _didInit;
  final BuildEvent _dispose;
  final WidgetBuilder _child;
  final BuildEvent _pause;
  final BuildEvent _unpause;
  final BuildEvent _quit;
  final BuildEvent _didPush;
  final BuildEvent _didPushNext;
  final BuildEvent _didPop;
  final BuildEvent _didPopNext;

  /// Base class for handling page transitions.
  ///
  /// Since it inherits from [StatefulHookWidget],
  /// you can use [useProvider] or other methods to get the state.
  ///
  /// Between pages,
  /// you can use [this.data] to get the data on that page in document format.
  ///
  /// You can use Hooks just like normal HookWidget.
  ///
  /// [key]: Widget key.
  /// [init]: Callback for widget initializing.
  /// [didInit]: Callback for widget initializing.
  /// [dispose]: Callback for Widget disposing.
  /// [child]: Callback when creating a widget.
  /// [pause]: Callback for Application paused.
  /// [unpause]: Callback for Application unpaused.
  /// [quit]: Callback for Application quit.
  /// [didPop]: Callback when the widget is pop.
  /// [didPush]: Callback when the widget is push.
  /// [didPopNext]: Callback when the next widget is pop.
  /// [didPushNext]: Callback when the next widget is push.
  const UIPage(
      {Key key,
      BuildEvent init,
      BuildEvent didInit,
      BuildEvent load,
      BuildEvent dispose,
      BuildEvent pause,
      BuildEvent unpause,
      BuildEvent quit,
      BuildEvent didPop,
      BuildEvent didPush,
      BuildEvent didPopNext,
      BuildEvent didPushNext,
      WidgetBuilder child})
      : this._init = init,
        this._didInit = didInit,
        this._dispose = dispose,
        this._pause = pause,
        this._unpause = unpause,
        this._quit = quit,
        this._didPop = didPop,
        this._didPush = didPush,
        this._didPopNext = didPopNext,
        this._didPushNext = didPushNext,
        this._child = child,
        super(key: key);

  /// Build context.
  ///
  /// Only available in Hook timings.
  BuildContext get context => useContext();

  /// True to apply safe area to Body.
  @protected
  bool get applySafeArea => true;

  /// Creating a body.
  ///
  /// [context]: Build context.
  @protected
  Widget body(BuildContext context);

  /// Callback for building.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.unfocus(),
        child: this.applySafeArea
            ? SafeArea(child: this.body(context))
            : this.body(context));
  }

  /// Create a state.
  ///
  /// Do not use from outside.
  @override
  @protected
  State createState() => UIPageState._();

  /// Executed when the widget is initialized.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void onInit(BuildContext context) {}

  /// Executed after the widget is initialized.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void onDidInit(BuildContext context) {}

  /// Executed when the widget is disposed.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void onDispose(BuildContext context) {}

  /// Executed when the widget is pause.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void onPause(BuildContext context) {}

  /// Executed when the widget is unpause.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void onUnpause(BuildContext context) {}

  /// Executed when the widget is quit.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void onQuit(BuildContext context) {}

  /// Executed when the widget is push.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void didPush(BuildContext context) {}

  /// Executed when the widget is pop.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void didPop(BuildContext context) {}

  /// Executed when the next widget is push.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void didPushNext(BuildContext context) {}

  /// Executed when the next widget is pop.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  @mustCallSuper
  void didPopNext(BuildContext context) {}
}

/// State class of [UIPage].
///
/// It monitors route changes and app status.
///
/// You can update the widget by executing [refresh()].
class UIPageState extends State<UIPage>
    with WidgetsBindingObserver, RouteAware {
  UIPageState._();

  /// List of paths to dispose of when the widget is disposed.
  PathList get willDisposePathList => this._willDisposePathList;
  PathList _willDisposePathList = PathList();
  List<IPath> _listenPathList = [];

  void _addListener(IPath path) {
    if (path == null) return;
    if (this._listenPathList.any((e) => e == path || e.path == path.path))
      return;
    path.watch(this._listener);
    this._listenPathList.add(path);
  }

  void _removeListener(IPath path) {
    if (path == null) return;
    path.unwatch(this._listener);
    this._listenPathList.removeWhere((e) => e == path || e.path == path.path);
  }

  void _listener(IPath path) => this.refresh();

  /// Updates the content of the widget.
  void refresh() => this.setState(() {});

  /// True if the widget is valid.
  bool get enabled => this._enabled && (this._parent?.enabled ?? true);

  bool _enabled = true;
  bool _markNeedsRebuild = false;
  _UIInternalPageState _parent;

  /// Initializes the widget.
  @override
  @protected
  void initState() {
    super.initState();
    this.widget._init?.call(this.context);
    this.widget.onInit(this.context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.widget._didInit?.call(this.context);
      this.widget.onDidInit(this.context);
    });
  }

  /// Called when the widget parent is updated.
  ///
  /// Changes the contents of the route monitoring.
  @override
  @protected
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._parent = _UIInternalPageScope.of(context);
    ModalRoute route = ModalRoute.of(this.context);
    if (route != null) UIPage.routeObserver.subscribe(this, route);
    this._parent?._addDidPushListener(this.didPush);
    this._parent?._addDidPopNextListener(this._didPopNextInternal);
    this._parent?._addDidPushNextListener(this.didPushNext);
  }

  /// Called when the widget is disposed.
  @override
  @protected
  void dispose() {
    super.dispose();
    this.widget._dispose?.call(context);
    this.widget.onDispose(context);
    WidgetsBinding.instance.removeObserver(this);
    UIPage.routeObserver.unsubscribe(this);
    this._parent?._removeDidPushListener(this.didPush);
    this._parent?._removeDidPopNextListener(this._didPopNextInternal);
    this._parent?._removeDidPushNextListener(this.didPushNext);
    this._willDisposePathList?.dispose();
    this._listenPathList?.forEach((path) => this._removeListener(path));
    this._listenPathList?.release();
  }

  /// Called when the state of the app is changed.
  ///
  /// [state]: AppLifecycleState.
  @override
  @protected
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        this.widget._quit?.call(this.context);
        this.widget.onQuit(this.context);
        break;
      case AppLifecycleState.paused:
        this.widget._pause?.call(this.context);
        this.widget.onPause(this.context);
        break;
      case AppLifecycleState.resumed:
        this.widget._unpause?.call(this.context);
        this.widget.onUnpause(this.context);
        break;
      default:
        break;
    }
  }

  /// The widget is called when it is popped.
  @override
  @protected
  void didPop() {
    this.widget._didPop?.call(this.context);
    this.widget.didPop(this.context);
  }

  /// Called when the next widget is popped.
  @override
  @protected
  void didPopNext() {
    this._enabled = true;
    if (this._markNeedsRebuild) {
      this.setState(() {});
      this._markNeedsRebuild = false;
    }
    this.widget._didPopNext?.call(this.context);
    this.widget.didPopNext(this.context);
  }

  void _didPopNextInternal() {
    ModalRoute route = ModalRoute.of(this.context);
    final data = route?.settings?.arguments;
    if (data is IDataDocument) {
      final document = DataDocument(DefaultPath.pageData);
      document.clear();
      for (MapEntry<String, IDataField> tmp in data.entries) {
        if (isEmpty(tmp.key) || tmp.value == null || tmp.value.data == null)
          continue;
        document[tmp.key] = tmp.value.data;
        PathTag.set(tmp.key, tmp.value.data.toString());
      }
    }
    this.didPopNext();
  }

  /// Called when the next widget is pushed.
  @override
  @protected
  void didPushNext() {
    this._enabled = false;
    this.widget._didPushNext?.call(this.context);
    this.widget.didPushNext(this.context);
  }

  /// Called when this widget is pushed.
  @override
  @protected
  void didPush() {
    this._enabled = true;
    this.widget._didPush?.call(this.context);
    this.widget.didPush(this.context);
  }

  /// Callback for building.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  @protected
  Widget build(BuildContext context) {
    if (!this.enabled) this._markNeedsRebuild = true;
    return _UIPageScope(
      state: this,
      child: this.widget._child != null
          ? this.widget._child(context)
          : this.widget.build(context),
    );
  }
}

class _UIPageScope extends InheritedWidget {
  final UIPageState state;
  const _UIPageScope({@required Widget child, this.state, Key key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_UIPageScope old) {
    return true;
  }
}
