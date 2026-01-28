part of "view.dart";

/// Create a template for the list form page.
///
/// リストフォームページのテンプレートを作成します。
class CodeViewListFormCliCommand extends CliTestableCodeCommand {
  /// Create a template for the list form page.
  ///
  /// リストフォームページのテンプレートを作成します。
  const CodeViewListFormCliCommand();

  @override
  String get name => "template_listform";

  @override
  String get prefix => "templateListForm";

  @override
  String get directory => "lib/pages";

  @override
  String get testDirectory => "test/pages";

  @override
  String get description =>
      "Create a template for the list form page in `$directory/(filepath).dart`. リストフォームページのテンプレートを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code tmp listform [page_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code view listform [path]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code view listform [path]\r\n\r\n([path] must be entered in snake_case; numbers and underscores cannot be used at the beginning or end of the path. Also, you can create directories by using /.)\r\n",
      );
      return;
    }
    final existsMain = File("lib/main.dart").existsSync();
    label("Create a form template in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
      final parentTestDir = Directory("$testDirectory/$parentPath");
      if (!parentTestDir.existsSync()) {
        await parentTestDir.create(recursive: true);
      }
    }
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
///   implementType: ${path.split("/").distinct().join("_").toPascalCase()}AddPageQuery,
/// )
/// class TestPage extends PageScopedWidget {
/// }
/// ```
typedef ${path.split("/").distinct().join("_").toPascalCase()}AddPageQuery = _\$${path.split("/").distinct().join("_").toPascalCase()}AddPageQuery;

/// [RouteQueryBuilder], which is also available externally.
/// 
/// ```dart
/// @PagePath(
///   "test",
///   implementType: ${path.split("/").distinct().join("_").toPascalCase()}EditPageQuery,
/// )
/// class TestPage extends PageScopedWidget {
/// }
/// ```
typedef ${path.split("/").distinct().join("_").toPascalCase()}EditPageQuery = _\$${path.split("/").distinct().join("_").toPascalCase()}EditPageQuery;
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
/// Page widget for $className to add data.
@immutable
@PagePath("\${2:$path}/add")
class ${className}AddPage extends FormAddPageScopedWidget {
  /// Page widget for $className to add data.
  const ${className}AddPage({
    super.key,
  });

  /// Used to transition to the ${className}AddPage screen.
  ///
  /// ```dart
  /// router.push(${className}AddPage.query(parameters));    // Push page to ${className}AddPage.
  /// router.replace(${className}AddPage.query(parameters)); // Replace page to ${className}AddPage.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}AddPageQuery();

  @override
  FormScopedWidget build(BuildContext context, PageRef ref) =>
      const ${className}Form();
}

/// Page widget for $className to edit data.
@immutable
@PagePath("\${3:$path}/:edit_id/edit")
class ${className}EditPage extends FormEditPageScopedWidget {
  /// Page widget for $className to edit data.
  const ${className}EditPage({
    @PageParam("edit_id") required super.editId,
    super.key,
  });

  /// Used to transition to the ${className}EditPage screen.
  ///
  /// ```dart
  /// router.push(${className}EditPage.query(parameters));    // Push page to ${className}EditPage.
  /// router.replace(${className}EditPage.query(parameters)); // Replace page to ${className}EditPage.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}EditPageQuery();

  @override
  FormScopedWidget build(BuildContext context, PageRef ref) =>
      const ${className}Form();
}

/// Widgets for form views.
@immutable
class ${className}Form extends FormScopedWidget {
  /// Widgets for form views.
  const ${className}Form({super.key});

  /// Used to transition to the ${className}AddPage screen.
  ///
  /// ```dart
  /// router.push(${className}Form.addQuery(parameters));    // Push page to ${className}AddPage.
  /// router.replace(${className}Form.addQuery(parameters)); // Replace page to ${className}AddPage.
  /// ```
  static const addQuery = ${className}AddPage.query;

  /// Used to transition to the ${className}EditPage screen.
  ///
  /// ```dart
  /// router.push(${className}Form.editQuery(parameters));    // Push page to ${className}EditPage.
  /// router.replace(${className}Form.editQuery(parameters)); // Replace page to ${className}EditPage.
  /// ```
  static const editQuery = ${className}EditPage.query;

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
    name: "${className}AddPage",
    path: "${sourcePath}_add",
    builder: (context, ref, value) {
      // TODO: Write test code.
      return const ${className}AddPage();
    },
  );
  masamunePageTest(
    name: "${className}EditPage",
    path: "${sourcePath}_edit",
    builder: (context, ref, value) {
      // TODO: Write test code.
      return const ${className}EditPage();
    },
  );
}
""";
  }
}
