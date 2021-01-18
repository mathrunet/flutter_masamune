part of flutter_runtime_database;

/// BuildContext extension methods.
extension BuildContextExtension on BuildContext {
  /// Updates the content of the widget.
  void refresh() {
    UIPage.of(this)?.refresh();
  }
  /// Outputs the theme related to the context.
  ThemeData get theme => Theme.of(this);

  /// Get the Navigator related to context.
  NavigatorState get navigator => Navigator.of(this);

  /// Get the Root navigator related to context.
  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);

  /// Get the Flavor.
  String get flavor => FlavorScope.of(this)?.flavor;

  /// Get the data passed to the page.
  IDataDocument get data =>
      (ModalRoute.of(this)?.settings?.arguments as IDataDocument) ??
      TemporaryDocument();

  /// Get the media qury related to context
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Releases focus such as text field.
  void unfocus() {
    FocusScope.of(this).requestFocus(FocusNode());
  }
}

/// Extension methods of IPath.
extension IPathExtension<TPath extends IPath> on TPath {
  /// Listen for the path with the Widget.
  ///
  /// [context]: BuildContext.
  TPath watchWidget(BuildContext context) {
    if (this == null) return this;
    UIPage.of(context)?._addListener(this);
    return this;
  }

  /// Set to dispose when the widget related to [context] is destroyed.
  ///
  /// [context]: BuildContext.
  TPath willDispose(BuildContext context) {
    UIPage.of(context)?.willDisposePathList?.add(this);
    return this;
  }
}

/// Extension methods of IPath.
extension IPathFutureExtension<TPath extends IPath> on Future<TPath> {
  /// Listen for the path with the Widget.
  ///
  /// [context]: BuildContext.
  Future<TPath> watchWidget(BuildContext context) {
    this?.then((value) {
      if (value == null) return value;
      UIPage.of(context)?._addListener(value);
      return value;
    });
    return this;
  }

  /// Set to dispose when the widget related to [context] is destroyed.
  ///
  /// [context]: BuildContext.
  Future<TPath> willDispose(BuildContext context) {
    if (this == null) return this;
    UIPage.of(context)?.willDisposePathList?.add(this);
    return this;
  }
}