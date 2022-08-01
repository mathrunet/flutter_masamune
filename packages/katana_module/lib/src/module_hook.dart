part of katana_module;

/// Set the module for Hook.
class HookModule extends Module implements ModuleHook {
  const HookModule({
    Future<void> Function(BuildContext context)? onInit,
    Future<void> Function(BuildContext context)? onRestoreAuth,
    Future<void> Function(BuildContext context)? onAfterAuth,
    Future<void> Function(BuildContext context)? onBeforeFinishBoot,
    Future<void> Function(BuildContext context)? onAfterFinishBoot,
    bool enabled = true,
  })  : _onInit = onInit,
        _onRestoreAuth = onRestoreAuth,
        _onAfterAuth = onAfterAuth,
        _onBeforeFinishBoot = onBeforeFinishBoot,
        _onAfterFinishBoot = onAfterFinishBoot,
        super(enabled: enabled);

  final Future<void> Function(BuildContext context)? _onInit;

  final Future<void> Function(BuildContext context)? _onRestoreAuth;

  final Future<void> Function(BuildContext context)? _onAfterAuth;

  final Future<void> Function(BuildContext context)? _onBeforeFinishBoot;

  final Future<void> Function(BuildContext context)? _onAfterFinishBoot;

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) async {
    _onInit?.call(context);
  }

  /// Runs when restoring authentication.
  @override
  @mustCallSuper
  Future<void> onRestoreAuth(BuildContext context) async {
    _onRestoreAuth?.call(context);
  }

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) async {
    _onAfterAuth?.call(context);
  }

  /// It is executed after the boot process is finished and
  /// before transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onBeforeFinishBoot(BuildContext context) async {
    _onBeforeFinishBoot?.call(context);
  }

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context) async {
    _onAfterFinishBoot?.call(context);
  }
}

/// Abstract class for defining the behavior hooks of a module.
abstract class ModuleHook {
  /// Run it the first time the app is launched.
  @mustCallSuper
  Future<void> onInit(BuildContext context);

  /// Runs when restoring authentication.
  @mustCallSuper
  Future<void> onRestoreAuth(BuildContext context);

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context);

  /// It is executed after the boot process is finished and
  /// before transitioning to another page.
  @mustCallSuper
  Future<void> onBeforeFinishBoot(BuildContext context);

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context);
}
