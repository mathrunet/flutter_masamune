part of masamune;

/// A mix-in class for handling the data passed to the page by [pushPath] etc.
mixin UIPageDataMixin on Widget {
  /// The UID passed to this page.
  String get uid => this.data?.uid;

  /// The name passed to this page.
  String get name => this.data?.getString("name");

  /// The text passed to this page.
  String get text => this.data?.getString("text");

  /// Gets the redirect path passed to the page.
  String get redirectTo => this.data?.getString("redirect_to", "/");

  //// True to add a new page.
  bool get additional => this.data?.getBool("additional") ?? false;

  /// The data passed to this page.
  IDataDocument get data {
    try {
      final context = useContext();
      if (context != null) {
        final data = ModalRoute.of(context)?.settings?.arguments;
        if (data is IDataDocument) {
          return data;
        }
      }
    } catch (e) {}
    return PathMap.get<IDataDocument>(UIPage.dataPath) ?? TempDocument();
  }
}
