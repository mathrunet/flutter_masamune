part of "code.dart";

/// Create a base class for the modal.
///
/// モーダルのベースクラスを作成します。
class CodeModalCliCommand extends CliCodeCommand {
  /// Create a base class for the modal.
  ///
  /// モーダルのベースクラスを作成します。
  const CodeModalCliCommand();

  @override
  String get name => "modal";

  @override
  String get prefix => "modal";

  @override
  String get directory => "lib/modals";

  @override
  String get description =>
      "Create a base class for the modal in `$directory/(filepath).dart`. モーダルのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code modal [modal_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code modal [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code modal [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    label("Create a modal class in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode(
      "$directory/$path",
      path,
    );
  }

  @override
  String import(String path, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
// ignore: unused_import, unnecessary_import
import "package:flutter/material.dart";
// ignore: unused_import, unnecessary_import
import "package:masamune/masamune.dart";
import "package:masamune_universal_ui/masamune_universal_ui.dart";

// ignore: unused_import, unnecessary_import
import "package:$packageName/main.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Modal widget for $className.
@immutable
class ${className}Modal extends Modal {
  /// Modal widget for $className.
  const ${className}Modal();

  @override
  Widget build(BuildContext context, ModalRef ref) {
    // Describes the structure of the modal.
    // TODO: Implement the view.
    return \${1:const Empty()};
  }
}
""";
  }
}
