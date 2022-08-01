part of katana_module;

extension ModuleTagsWidgetRefExtensions on WidgetRef {
  static final _converter = RegExp(r"\{([^\{\}]+?)\}");

  /// Convert specific module tags.
  ///
  /// ```
  /// {context:[key]}: Replaced by the value of [key] in the data in the page.
  /// {user:id}: Replaced by the user ID.
  /// {user:[key]}: Replaced by the value of [key] in the data in the user.
  /// {document:[path]:[key]}: Replaced by the value of [key] in the data in the document of [path].
  /// {collection:[path]:[key]}: The data in [key] of all documents in the [path] collection will be replaced with a comma-joined string.
  /// ```
  String applyModuleTag(String path) {
    final context = this as BuildContext;
    final tags = _ModuleTagScope.of(context);

    int i = 0;
    while (path.contains("{") || path.contains("}")) {
      path = path.replaceAllMapped(
        _converter,
        (match) {
          final command = match.group(1);
          if (command.isEmpty || !command!.contains(":")) {
            return "";
          }
          final split = command.split(":");
          final key = split.first;
          final param = split..removeAt(0);
          for (final tag in tags) {
            if (tag.id != key) {
              continue;
            }
            return tag.parse(key, param, context, this);
          }
          return "";
        },
      );
      i++;
      if (i > 10) {
        break;
      }
    }
    return path;
  }
}
