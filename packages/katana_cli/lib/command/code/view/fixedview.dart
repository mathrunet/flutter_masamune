part of "view.dart";

/// Create a template for the fixed view page.
///
/// 固定ビューページのテンプレートを作成します。
class CodeViewFixedViewCliCommand extends CliTestableCodeCommand {
  /// Create a template for the fixed view page.
  ///
  /// 固定ビューページのテンプレートを作成します。
  const CodeViewFixedViewCliCommand();

  @override
  String get name => "template_fixedview";

  @override
  String get prefix => "templateFixedView";

  @override
  String get directory => "lib/pages";

  @override
  String get testDirectory => "test/pages";

  @override
  String get description =>
      "Create a template for the fixed view page in `$directory/(filepath).dart`. 固定ビューページのテンプレートを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code tmp fixedview [page_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code view fixedview [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code view fixedview [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    final existsMain = File("lib/main.dart").existsSync();
    label("Create a fixed view template in `$directory/$path.dart`.");
    await generateDartCode(
      "$directory/$path",
      path,
      filter: (value) {
        if (existsMain) {
          return value;
        } else {
          return """
$value
/// [RouteQueryBuilder], which is also available externally.
/// 
/// ```dart
/// @PagePath(
///   "test",
///   implementType: ${path.split("/").distinct().join("_").toPascalCase()}PageQuery,
/// )
/// class TestPage extends PageScopedWidget {
/// }
/// ```
typedef ${path.split("/").distinct().join("_").toPascalCase()}PageQuery = _\$${path.split("/").distinct().join("_").toPascalCase()}PageQuery;
""";
        }
      },
    );
    await generateDartTestCode("$testDirectory/$path", path);
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
    return """
part "$baseName.page.dart";
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Page widget for $className.
@immutable
// TODO: Set the path for the page.
@PagePath("\${1:$path}")
class ${className}Page extends PageScopedWidget {
  /// Page widget for $className.
  const ${className}Page({
    super.key,
    // TODO: Set parameters for the page.
    \${2}
  });

  // TODO: Set parameters for the page in the form [final String xxx].
  \${3}

  /// Used to transition to the ${className}Page screen.
  ///
  /// ```dart
  /// router.push(${className}Page.query(parameters));    // Push page to ${className}Page.
  /// router.replace(${className}Page.query(parameters)); // Replace page to ${className}Page.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}PageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    // TODO: Implement the variable loading process.
    \${4}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return UniversalScaffold(
      appBar: UniversalAppBar(
        // TODO: Implement the app bar.
        \${5}
      ),
      body: UniversalColumn(
        children: [
          // TODO: Implement the fixed view.
          \${6}
        ],
      ),
    );
  }
} 
""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
import "package:masamune_test/masamune_test.dart";

import "package:$packageName/pages/$sourcePath.dart";

void main() {
  masamunePageTest(
    name: "${className}Page",
    path: "$sourcePath",
    builder: (context, ref, value) {
      // TODO: Write test code.
      return const ${className}Page();
    },
  );
}
""";
  }
}
