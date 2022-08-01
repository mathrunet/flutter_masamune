part of katana_module;

/// Abstract class for defining module tags.
@immutable
abstract class ModuleTag {
  const ModuleTag();

  /// ID of the module tag.
  String get id;

  /// Methods for parsing and retrieving tags.
  ///
  /// It is used internally.
  String parse(
    String id,
    List<String> param,
    BuildContext context,
    WidgetRef ref,
  );
}
