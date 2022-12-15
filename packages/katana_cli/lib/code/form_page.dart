part of katana_cli;

/// Base code for the page.
///
/// ページのベースコード。
class FormPageCliCode extends CliCode {
  /// Base code for the page.
  ///
  /// ページのベースコード。
  const FormPageCliCode();

  @override
  String get name => "page";

  @override
  String get prefix => "page";

  @override
  String get directory => "lib/pages";

  @override
  String get description =>
      "Create the code necessary to create the page. The name of the page will be [(filename)Page]. ページ作成に必要なコードを作成します。ページ名は[(ファイル名)Page]となります。";

  @override
  String import(String path, String baseName, String className) {
    return """
// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:masamune/masamune.dart';

// ignore: unused_import
import '/main.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import 'package:freezed_annotation/freezed_annotation.dart';

part '$baseName.m.dart';
part '$baseName.g.dart';
part '$baseName.page.dart';
part '$baseName.freezed.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Value for form.
@freezed
@formValue
class ${className}Value with _\$${className}Value {
  const factory ${className}Value({
     // TODO: Set the data schema.
     \${1}
  }) = _${className}Value;
  const ${className}Value._();

  factory ${className}Value.fromJson(Map<String, Object?> json) => _\$${className}ValueFromJson(json);

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(${className}Value.form());     // Get the form controller.
  /// ```
  static const form = _\$${className}ValueFormQuery();
}

/// Page for forms to add data.
@immutable
@PagePath("\${2:$path}/add")
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
@PagePath("\${3:$path}/{edit_id}/edit")
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
  Widget build(BuildContext context, WidgetRef ref, FormContext form) {
    // Describes the process of loading
    // and defining variables required for the page.
    // 
    // You can use [form.isAdding] or [form.isEditing] to determine if the form is currently adding new data or editing data.
    //
    // If editing is in progress, it is possible to get the ID of the item being edited with [form.editId].
    // TODO: Implement the variable loading process.
    \${4}

    // Describes the structure of the page.
    // TODO: Implement the view.
    return \${5};
  }
}
""";
  }
}
