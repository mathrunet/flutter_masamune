part of katana_module;

/// Base class for all modules.
///
/// You can enable or disable the module by specifying [enabled].
///
/// The [id] is given to restore the same when the module is saved to the server.
@immutable
abstract class Module {
  const Module({
    this.id,
    this.enabled = true,
  });

  static final List<Module> _registeredModules = [];
  static final List<ModuleHook> _registeredHooks = [];

  /// Register the [modules] to be used.
  static void registerModules(List<Module> modules) {
    for (final module in modules) {
      if (_registeredModules.contains(module)) {
        continue;
      }
      _registeredModules.add(module);
      if (module is ModuleHook) {
        _registeredHooks.add(module as ModuleHook);
      }
    }
  }

  /// Get the registered [ModuleHook].
  static List<ModuleHook> get registeredHooks =>
      _registeredHooks.toList(growable: false);

  /// ID of the module.
  final String? id;

  /// `true` if Module is enabled.
  final bool enabled;

  /// Module Type.
  String get type => runtimeType.toString();
}
