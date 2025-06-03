part of "/katana_scoped.dart";

class _AppScopedScope extends InheritedWidget {
  const _AppScopedScope({
    required this.state,
    required super.child,
  });

  final _AppScopedState state;

  static _AppScopedState of(BuildContext context) {
    final scoped = context
        .getElementForInheritedWidgetOfExactType<_AppScopedScope>()
        ?.widget as _AppScopedScope?;
    assert(
      scoped != null,
      "AppScoped could not be found. Please place [AppScoped] in the root.",
    );
    return scoped!.state;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class _PageScopedScope extends InheritedWidget {
  const _PageScopedScope({
    required this.state,
    required super.child,
  });

  final _PageScopedWidgetState state;

  static _PageScopedWidgetState of(BuildContext context) {
    final scoped = context
        .getElementForInheritedWidgetOfExactType<_PageScopedScope>()
        ?.widget as _PageScopedScope?;
    assert(
      scoped != null,
      "PageScopedWidget is not defined in the parent widget. Be sure to place it below the PageScopedWidget.",
    );
    return scoped!.state;
  }

  static _PageScopedWidgetState? maybeOf(BuildContext context) {
    final scoped = context
        .getElementForInheritedWidgetOfExactType<_PageScopedScope>()
        ?.widget as _PageScopedScope?;
    return scoped?.state;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
