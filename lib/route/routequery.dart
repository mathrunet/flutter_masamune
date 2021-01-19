part of masamune;

/// Define a query for routing.
///
/// You can pass it as [arguments] with [pageNamed()] and so on.
class RouteQuery {
  final PageTransition _transition;
  final IDataDocument _document;
  final Map<String, dynamic> _data;

  /// Define a query for routing.
  ///
  /// You can pass it as [arguments] with [pageNamed()] and so on.
  ///
  /// [transition]: True when transitioning type.
  /// [document]: Document for routing.
  /// [data]: Data for routing.
  const RouteQuery(
      {PageTransition transition = PageTransition.initial,
      IDataDocument document,
      Map<String, dynamic> data})
      : this._transition = transition,
        this._document = document,
        this._data = data;

  /// View the page as a full screen.
  static RouteQuery get fullscreen =>
      const RouteQuery(transition: PageTransition.fullscreen);

  /// Display the page with no animation.
  static RouteQuery get immediately =>
      const RouteQuery(transition: PageTransition.none);

  /// Display the page with fade animation.
  static RouteQuery get fade =>
      const RouteQuery(transition: PageTransition.fade);
}

/// Types of page transitions.
enum PageTransition {
  /// Normal.
  initial,

  /// No animation.
  none,

  /// Full Screen.
  fullscreen,

  /// Fade animation.
  fade
}
