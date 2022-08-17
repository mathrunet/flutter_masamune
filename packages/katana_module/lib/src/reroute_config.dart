part of katana_module;

/// Class for handling reroute definitions.
///
/// Set [value] to configure the route settings.
@immutable
abstract class RerouteConfig implements ModuleHook {
  const RerouteConfig();

  /// Reroute settings that are tied to.
  ///
  /// If [value] is `true`, the route will be changed to the path of [key].
  Map<String, bool Function(BuildContext context)> get value;

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) => Future.value();

  /// Runs when restoring authentication.
  @override
  @mustCallSuper
  Future<void> onRestoreAuth(BuildContext context) => Future.value();

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) => Future.value();

  /// It is executed after the boot process is finished and
  /// before transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onBeforeFinishBoot(BuildContext context) => Future.value();

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context) => Future.value();

  /// This is called if you want to redirect to a specific URL when Boot redirects.
  ///
  /// If null or non-empty is returned, it is ignored.
  @override
  @mustCallSuper
  Future<String?> retrieveRedirectUriOnBoot(BuildContext context) =>
      Future.value(null);
}
