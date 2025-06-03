part of "code.dart";

/// Create a base class for the document model.
///
/// ドキュメントモデルのベースクラスを作成します。
class CodeDocumentCliCommand extends CliTestableCodeCommand {
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
  String get testDirectory => "test/models";

  @override
  String get description =>
      "Create a base class for the document model in `$directory/(filepath).dart`. ドキュメントモデルのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code document [model_name]";

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
    await const CodeDocumentExtensionCliCommand()
        .generateDartCode("$directory/$path.extensions", path);
    await const CodeDocumentApiCliCommand()
        .generateDartCode("$directory/$path.api", path);
    await generateDartTestCode("$testDirectory/$path", path);
  }

  @override
  String import(String path, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
// ignore: unused_import, unnecessary_import
import 'package:flutter/material.dart';
// ignore: unused_import, unnecessary_import
import 'package:masamune/masamune.dart';

// ignore: unused_import, unnecessary_import
import 'package:$packageName/main.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return """
import 'package:freezed_annotation/freezed_annotation.dart';

part '$baseName.m.dart';
part '$baseName.g.dart';
part '$baseName.freezed.dart';
part '$baseName.extensions.dart';
part '$baseName.api.dart';
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
abstract class ${className}Model with _\$${className}Model {
  const factory ${className}Model({
     // TODO: Set the data fields.
     \${2}
  }) = _${className}Model;
  const ${className}Model._();

  factory ${className}Model.fromJson(Map<String, Object?> json) => _\$${className}ModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(${className}Model.document());      // Get the document.
  /// 
  /// ref.page.form(CounterModel.form(CounterModel()));    // Get the form controller.(${className}Model.document())..load(); // Load the document.
  /// ```
  static const document = _\$${className}ModelDocumentQuery();

  /// Query for form value.
  ///
  /// ```dart
  /// ref.app.form(${className}Model.form(${className}Model()));    // Get the form controller in app scope.
  /// ref.page.form(${className}Model.form(${className}Model()));    // Get the form controller in page scope.
  /// ```
  static const form = _\$${className}ModelFormQuery();
}

/// [Enum] of the name of the value defined in ${className}Model.
typedef ${className}ModelKeys = _\$${className}ModelKeys;

/// Alias for ModelRef&lt;${className}Model&gt;.
///
/// When defining parameters for other Models, you can define them as follows
///
/// ```dart
/// @RefParam(${className}ModelDocument) ${className}ModelRef $baseName
/// ```
typedef ${className}ModelRef = ModelRef<${className}Model>?;

/// It can be defined as an empty ModelRef&lt;${className}Model&gt;.
///
/// ```dart
/// ${className}ModelRefPath() // Define as a path.
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

/// It can be defined as an empty ModelRef&lt;${className}Model&gt;.
///
/// ```dart
/// ${className}ModelMirrorRefPath() // Define as a path.
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

/// Extension for ${className}ModelDocument.
extension ${className}ModelDocumentExtension on ${className}ModelDocument {
  // TODO: Define the extension method.

  /// Convert to a tile widget.
  ///
  /// ```dart
  /// document.toTile(context);
  /// ```
  Widget toTile(BuildContext context) {
    return const ListTile();
  }
}
""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
    final packageName = retrievePackageName();
    return """
import 'package:masamune/masamune.dart';
import 'package:masamune_test/masamune_test.dart';

import 'package:$packageName/models/$sourcePath.dart';

void main() {
  masamuneModelTileTest(
    name: "$className",
    // TODO: Set the document Id.
    document: (ref) => ref.appRef.model(${className}Model.document()),
    builder: (context, ref, doc) {
      // TODO: Write test code.
      return doc.toTile(context);
    },
  );
}
""";
  }
}

/// Generates code to define an Extension corresponding to [CodeDocumentCliCommand].
///
/// [CodeDocumentCliCommand]に対応するExtensionを記載するコードを生成します。
class CodeDocumentExtensionCliCommand extends CliCode {
  /// Generates code to define an Extension corresponding to [CodeDocumentCliCommand].
  ///
  /// [CodeDocumentCliCommand]に対応するExtensionを記載するコードを生成します。
  const CodeDocumentExtensionCliCommand();

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "lib/models";

  @override
  String get description => "";

  @override
  String import(String path, String baseName, String className) {
    return """
part of '${baseName.replaceAll(".extensions", "")}.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Extension for ${className}Model.
extension ${className}ModelExtensions on ${className}Model {
  // TODO: Define the extension method.
}

/// Extension for ${className}ModelRef / ${className}ModelDocument.
extension ${className}ModelRefExtensions on ${className}ModelRef {
  // TODO: Define the extension method.

  /// Convert to a tile widget.
  ///
  /// ```dart
  /// document.toTile(context);
  /// ```
  Widget toTile(BuildContext context) {
    // ignore: unused_local_variable
    final value = this?.value;
    return const ListTile();
  }
}
""";
  }
}

/// Generates code to define an API corresponding to [CodeDocumentCliCommand].
///
/// [CodeDocumentCliCommand]に対応するAPIを記載するコードを生成します。
class CodeDocumentApiCliCommand extends CliCode {
  /// Generates code to define an API corresponding to [CodeDocumentCliCommand].
  ///
  /// [CodeDocumentCliCommand]に対応するAPIを記載するコードを生成します。
  const CodeDocumentApiCliCommand();

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "lib/models";

  @override
  String get description => "";

  @override
  String import(String path, String baseName, String className) {
    return """
part of '${baseName.replaceAll(".api", "")}.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// Defines the API mapping to be passed to [RestApiModelAdapter].
class ${className}ModelRestApiQuery extends ModelRestApiQuery {
  /// Defines the API mapping to be passed to [RestApiModelAdapter].
  const ${className}ModelRestApiQuery();

  // TODO: Set the description.
  @override
  String? get description => null;

  // TODO: Set the document.
  @override
  DocumentModelRestApiBuilder? get document => null;
}
""";
  }
}
