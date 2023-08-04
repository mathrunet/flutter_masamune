part of katana_cli.code;

/// Create a base class for the collection model.
///
/// コレクションモデルのベースクラスを作成します。
class CodeCollectionCliCommand extends CliCodeCommand {
  /// Create a base class for the collection model.
  ///
  /// コレクションモデルのベースクラスを作成します。
  const CodeCollectionCliCommand();

  @override
  String get name => "collection_model";

  @override
  String get prefix => "collectionModel";

  @override
  String get directory => "lib/models";

  @override
  String get description =>
      "Create a base class for the collection model in `$directory/(filepath).dart`. コレクションモデルのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code collection [path]\r\n",
      );
      return;
    }
    label("Create a collection class in `$directory/$path.dart`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path);
  }

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
import 'package:freezed_annotation/freezed_annotation.dart';

part '$baseName.m.dart';
part '$baseName.g.dart';
part '$baseName.freezed.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    final paths = path.split("/");
    if (paths.length.isEven) {
      path = paths.sublist(0, paths.length - 1).join("/");
    }
    return """
/// Alias for ModelRef<${className}Model>.
/// 
/// When defining parameters for other Models, you can define them as follows
/// 
/// ```dart
/// @refParam ${className}ModelRef $baseName
/// ```
typedef ${className}ModelRef = ModelRef<${className}Model>?;

/// Value for model.
@freezed
@formValue
@immutable
// TODO: Set the path for the collection.
@CollectionModelPath("\${1:$path}")
class ${className}Model with _\$${className}Model {
  const factory ${className}Model({
     // TODO: Set the data schema.
     \${2}
  }) = _${className}Model;
  const ${className}Model._();

  factory ${className}Model.fromJson(Map<String, Object?> json) => _\$${className}ModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(${className}Model.document(id));      // Get the document.
  /// ref.model(${className}Model.document(id))..load(); // Load the document.
  /// ```
  static const document = _\$${className}ModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(${className}Model.collectoin());      // Get the collection.
  /// ref.model(${className}Model.collection())..load(); // Load the collection.
  /// ref.model(
  ///   ${className}Model.collection().data.equal(
  ///     "data",
  ///   ),
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _\$${className}ModelCollectionQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.page.controller(${className}Model.form());     // Get the form controller.
  /// ```
  static const form = _\$${className}ModelFormQuery();
}
""";
  }
}
