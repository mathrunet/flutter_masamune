part of katana_cli.code;

/// Create a base class for the document model.
///
/// ドキュメントモデルのベースクラスを作成します。
class CodeDocumentCliCommand extends CliCodeCommand {
  /// Create a base class for the document model.
  ///
  /// ドキュメントモデルのベースクラスを作成します。
  const CodeDocumentCliCommand();

  @override
  String get name => "document_model";

  @override
  String get prefix => "documentModel";

  @override
  String get directory => "lib/models";

  @override
  String get description =>
      "Create a base class for the document model in `$directory/(filepath).dart`. ドキュメントモデルのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code document [path]\r\n",
      );
      return;
    }
    label("Create a document class in `$directory/$path.dart`.");
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
    if (paths.length.isOdd) {
      if (paths.length <= 1) {
        path = (paths..insert(0, "app")).join("/");
      } else {
        path = paths.sublist(0, paths.length - 1).join("/");
      }
    }
    return """
/// Value for model.
@freezed
@formValue
@immutable
// TODO: Set the path for the document.
@DocumentModelPath("\${1:$path}")
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
  /// ${className}Model.document().read(appRef);      // Get the document.
  /// ${className}Model.document().watch(ref); // Load the document.
  /// ```
  static const document = _\$${className}ModelDocumentQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ${className}Model.form(${className}Model()).watch(ref);    // Get the form controller.
  /// ```
  static const form = _\$${className}ModelFormQuery();
}

/// [Enum] of the name of the value defined in ${className}Model.
typedef ${className}ModelKeys = _\$${className}ModelKeys;

/// Alias for ModelRef<${className}Model>.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(${className}ModelDocument) ${className}ModelRef $baseName
/// ```
typedef ${className}ModelRef = ModelRef<${className}Model>?;

/// It can be defined as an empty ModelRef<NoteModel>.
///
/// ```dart
/// NoteModelRefPath() // Define as a path.
/// ```
typedef ${className}ModelRefPath = _\$${className}ModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     ${className}ModelInitialDocument(
///       ${className}Model(...),
///     ),
///   ],
/// );
/// ```
typedef ${className}ModelInitialDocument = _\$${className}ModelInitialDocument;

/// Document class for storing ${className}Model.
typedef ${className}ModelDocument = _\$${className}ModelDocument;

/// It can be defined as an empty ModelRef<NoteModel>.
///
/// ```dart
/// NoteModelMirrorRefPath() // Define as a path.
/// ```
typedef ${className}ModelMirrorRefPath = _\$${className}ModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     ${className}ModelMirrorInitialDocument(
///       ${className}Model(...),
///     ),
///   ],
/// );
/// ```
typedef ${className}ModelMirrorInitialDocument = _\$${className}ModelMirrorInitialDocument;

/// Document class for storing ${className}Model.
typedef ${className}ModelMirrorDocument = _\$${className}ModelMirrorDocument;
""";
  }
}
