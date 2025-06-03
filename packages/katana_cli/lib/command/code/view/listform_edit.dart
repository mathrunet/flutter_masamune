part of "view.dart";

/// Create a template for the list form page (when editing).
///
/// リストフォームページ（既存編集時）のテンプレートを作成します。
class CodeViewListFormEditCliCommand extends CliTestableCodeCommand {
  /// Create a template for the list form page (when editing).
  ///
  /// リストフォームページ（既存編集時）のテンプレートを作成します。
  const CodeViewListFormEditCliCommand();

  @override
  String get name => "template_listform_edit";

  @override
  String get prefix => "templateListFormEdit";

  @override
  String get directory => "lib/pages";

  @override
  String get testDirectory => "test/pages";

  @override
  String get description =>
      "Create a template for the list form page (when editing) in `$directory/(filepath).dart`. リストフォームページ（既存編集時）のテンプレートを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code tmp listform_edit [page_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code tmp form [path]\r\n",
      );
      return;
    }
    final existsMain = File("lib/main.dart").existsSync();
    label("Create a form template in `$directory/$path.dart`.");
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
/// Page for forms to edit data.
@immutable
@PagePath("\${3:$path}/:edit_id/edit")
class ${className}Page extends FormEditPageScopedWidget {
  const ${className}Page({
    super.key,
    @PageParam("edit_id") required super.editId,
  });

  /// Used to transition to the ${className}Page screen.
  ///
  /// ```dart
  /// router.push(${className}Page.query(parameters));    // Push page to ${className}Page.
  /// router.replace(${className}Page.query(parameters)); // Replace page to ${className}Page.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}PageQuery();

  @override
  FormScopedWidget build(BuildContext context, PageRef ref) =>
      const _${className}Form();
}

/// Widgets for form views.
@immutable
class _${className}Form extends FormScopedWidget {
  const _${className}Form({super.key});

  @override
  Widget build(BuildContext context, FormRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    // 
    // You can use [ref.isAdding] or [ref.isEditing] to determine if the form is currently adding new data or editing data.
    //
    // If editing is in progress, it is possible to get the ID of the item being edited with [ref.editId].
    // TODO: Implement the variable loading process.
    \${4}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return UniversalScaffold(
      appBar: UniversalAppBar(
        // TODO: Implement the app bar.
        \${5}
      ),
      body: UniversalListView(
        children: [
          // TODO: Implement the list view.
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
    name: "$className",
    builder: (context, ref) {
      // TODO: Write test code.
      return const ${className}Page();      
    },
  );
}
""";
  }
}
