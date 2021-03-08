part of masamune;

mixin UIPageScaffoldMixin on PageHookWidget {
  /// Key for Scaffold.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// State for Scaffold.
  ScaffoldState get scaffold => scaffoldKey.currentState!;
}
