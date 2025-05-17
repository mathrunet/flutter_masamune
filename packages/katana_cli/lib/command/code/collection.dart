part of "code.dart";

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
  String? get example => "katana code collection [model_name]";

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
    await const CodeCollectionExtensionCliCommand()
        .generateDartCode("$directory/$path.extensions", path);
    await const CodeCollectionApiCliCommand()
        .generateDartCode("$directory/$path.api.dart", path);
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
part '$baseName.extensions.dart';
part '$baseName.api.dart';
""";
  }

  @override
  String body(String path, String baseName, String className) {
    final paths = path.split("/");
    if (paths.length.isEven) {
      path = paths.sublist(0, paths.length - 1).join("/");
    }
    return """
/// Value for model.
@freezed
@formValue
@immutable
// TODO: Set the path for the collection.
@CollectionModelPath("\${1:$path}")
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
  /// appRef.model(${className}Model.document(id));       // Get the document.
  /// ref.app.model(${className}Model.document(id))..load();  // Load the document.
  /// ```
  static const document = _\$${className}ModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(${className}Model.collection());       // Get the collection.
  /// ref.app.model(${className}Model.collection())..load();  // Load the collection.
  /// ref.app.model(
  ///   ${className}Model.collection().data.equal(
  ///     "data",
  ///   )
  /// )..load(); // Load the collection with filter.
  /// ```
  static const collection = _\$${className}ModelCollectionQuery();

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
/// ${className}ModelRefPath("xxx") // Define as a path.
/// ```
typedef ${className}ModelRefPath = _\$${className}ModelRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     ${className}ModelInitialCollection(
///       "xxx": ${className}Model(...),
///     ),
///   ],
/// );
/// ```
typedef ${className}ModelInitialCollection = _\$${className}ModelInitialCollection;

/// Document class for storing ${className}Model.
typedef ${className}ModelDocument = _\$${className}ModelDocument;

/// Collection class for storing ${className}Model.
typedef ${className}ModelCollection = _\$${className}ModelCollection;

/// It can be defined as an empty ModelRef&lt;${className}Model&gt;.
///
/// ```dart
/// ${className}ModelMirrorRefPath("xxx") // Define as a path.
/// ```
typedef ${className}ModelMirrorRefPath = _\$${className}ModelMirrorRefPath;

/// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
///
/// ```dart
/// RuntimeModelAdapter(
///   initialValue: [
///     ${className}ModelMirrorInitialCollection(
///       "xxx": ${className}Model(...),
///     ),
///   ],
/// );
/// ```
typedef ${className}ModelMirrorInitialCollection = _\$${className}ModelMirrorInitialCollection;

/// Document class for storing ${className}Model.
typedef ${className}ModelMirrorDocument = _\$${className}ModelMirrorDocument;

/// Collection class for storing ${className}Model.
typedef ${className}ModelMirrorCollection = _\$${className}ModelMirrorCollection;
""";
  }
}

/// Generates code to define an Extension corresponding to [CodeCollectionCliCommand].
///
/// [CodeCollectionCliCommand]に対応するExtensionを記載するコードを生成します。
class CodeCollectionExtensionCliCommand extends CliCode {
  /// Generates code to define an Extension corresponding to [CodeCollectionCliCommand].
  ///
  /// [CodeCollectionCliCommand]に対応するExtensionを記載するコードを生成します。
  const CodeCollectionExtensionCliCommand();

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
part of '$baseName.dart';
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

/// Extension for ${className}ModelCollection.
extension ${className}ModelCollectionExtensions on ${className}ModelCollection {
  // TODO: Define the extension method.
}
""";
  }
}

/// Generates code to define an API corresponding to [CodeCollectionCliCommand].
///
/// [CodeCollectionCliCommand]に対応するAPIを記載するコードを生成します。
class CodeCollectionApiCliCommand extends CliCode {
  /// Generates code to define an API corresponding to [CodeCollectionCliCommand].
  ///
  /// [CodeCollectionCliCommand]に対応するAPIを記載するコードを生成します。
  const CodeCollectionApiCliCommand();

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
part of '$baseName.dart';
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

  // TODO: Set the collection.
  @override
  CollectionModelRestApiBuilder? get collection => null;
}
""";
  }
}
