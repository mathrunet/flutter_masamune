part of masamune;

/// NavigatorState extension methods.
extension NavigatorStateExtension on NavigatorState {
  /// Pops the page to the page with the specified path.
  ///
  /// [name]: Page path.
  Future popUntilNamed(String name) async {
    if (isEmpty(name)) return null;
    name = name.applyTags();
    this.popUntil((route) {
      return route.settings.name.applyTags() == name;
    });
  }

  /// Reset all history and go to a specific page.
  ///
  /// Ideal for moving after logging out.
  ///
  /// [newRouteName]: New root path.
  /// [arguments]: An array to pass to the new page.
  Future<T> resetAndPushNamed<T extends Object>(String newRouteName,
          {Object arguments}) =>
      this.pushNamedAndRemoveUntil(newRouteName, (route) => false,
          arguments: arguments);
}
