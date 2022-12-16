part of katana_cli;

/// Templates for creating forms for listing, detailing, adding, and editing data.
///
/// データの一覧、詳細、追加、編集のフォームを作成するためのテンプレート。
class TmpBasicCliCode extends CliCode {
  /// Templates for creating forms for listing, detailing, adding, and editing data.
  ///
  /// データの一覧、詳細、追加、編集のフォームを作成するためのテンプレート。
  const TmpBasicCliCode();

  @override
  String get name => "basic";

  @override
  String get prefix => "basic";

  @override
  String get directory => "lib/pages";

  @override
  String get description =>
      "Create a page template to create forms for listing, detailing, adding, and editing data. The page name will be [(filename)Page]. データの一覧、詳細、追加、編集のフォームを作成するためのページテンプレートを作成します。ページ名は[(ファイル名)Page]となります。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import '/main.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
part '$baseName.page.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
@immutable
// TODO: Set the path for the page.
@PagePath("\${1:$path}")
class ${className}Page extends PageScopedWidget {
  const ${className}Page({
    super.key,
    // TODO: Set parameters for the page.
  });

  // TODO: Set parameters for the page in the form [final String xxx].

  /// Used to transition to the ${className}Page screen.
  ///
  /// ```dart
  /// router.push(${className}Page.query(parameters));    // Push page to ${className}Page.
  /// router.replace(${className}Page.query(parameters)); // Push page to ${className}Page.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}PageQuery();

  /// Used to transition to the ${className}DetailPage screen.
  ///
  /// ```dart
  /// router.push(${className}Form.detailQuery(parameters));    // Push page to ${className}AddPage.
  /// router.replace(${className}Form.detailQuery(parameters)); // Push page to ${className}AddPage.
  /// ```
  static const detailQuery = ${className}DetailPage.query;

  /// Used to transition to the ${className}AddPage screen.
  ///
  /// ```dart
  /// router.push(${className}Form.addQuery(parameters));    // Push page to ${className}AddPage.
  /// router.replace(${className}Form.addQuery(parameters)); // Push page to ${className}AddPage.
  /// ```
  static const addQuery = ${className}AddPage.query;

  /// Used to transition to the ${className}EditPage screen.
  ///
  /// ```dart
  /// router.push(${className}Form.editQuery(parameters));    // Push page to ${className}EditPage.
  /// router.replace(${className}Form.editQuery(parameters)); // Push page to ${className}EditPage.
  /// ```
  static const editQuery = ${className}EditPage.query;

  @override
  Widget build(BuildContext context, PageRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    // TODO: Implement the variable loading process.
    \${2}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return \${3:Scaffold()};
  }
}

@immutable
// TODO: Set the path for the page.
@PagePath("\${4:$path}/{view_id}")
class ${className}DetailPage extends PageScopedWidget {
  const ${className}DetailPage({
    super.key,
    // TODO: Set parameters for the page.
    @PageParam("view_id") required this.viewId,
  });

  /// ViewId for Detail.
  ///
  /// Detail用のViewId.
  final String viewId;

  // TODO: Set parameters for the page in the form [final String xxx].

  /// Used to transition to the ${className}DetailPage screen.
  ///
  /// ```dart
  /// router.push(${className}DetailPage.query(parameters));    // Push page to ${className}DetailPage.
  /// router.replace(${className}DetailPage.query(parameters)); // Push page to ${className}DetailPage.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}DetailPageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    // Describes the process of loading
    // and defining variables required for the page.
    // TODO: Implement the variable loading process.
    \${5}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return \${6:Scaffold()};
  }
}

/// Page for forms to add data.
@immutable
@PagePath("\${7:$path}/add")
class ${className}AddPage extends FormAddPageScopedWidget {
  const ${className}AddPage({
    super.key,
  });

  /// Used to transition to the ${className}AddPage screen.
  ///
  /// ```dart
  /// router.push(${className}AddPage.query(parameters));    // Push page to ${className}AddPage.
  /// router.replace(${className}AddPage.query(parameters)); // Push page to ${className}AddPage.
  /// ```
  @pageRouteQuery
  static const query = _\$${className}AddPageQuery();

  @override
  FormScopedWidget build(BuildContext context, PageRef ref) =>
      const ${className}Form();
}

/// Page for forms to edit data.
@immutable
@PagePath("\${8:$path}/{edit_id}/edit")
class ${className}EditPage extends FormEditPageScopedWidget {
  const ${className}EditPage({
    super.key,
    @PageParam("edit_id") required super.editId,
  });

  /// Used to transition to the ${className}EditPage screen.
  ///
  /// ```dart
  /// router.push(${className}EditPage.query(parameters));    // Push page to ${className}EditPage.
  /// router.replace(${className}EditPage.query(parameters)); // Push page to ${className}EditPage.
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
  const ${className}Form({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, FormContext form) {
    // Describes the process of loading
    // and defining variables required for the page.
    // 
    // You can use [form.isAdding] or [form.isEditing] to determine if the form is currently adding new data or editing data.
    //
    // If editing is in progress, it is possible to get the ID of the item being edited with [form.editId].
    // TODO: Implement the variable loading process.
    \${9}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return \${10:Scaffold()};
  }
}
""";
  }
}
