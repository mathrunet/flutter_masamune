part of katana_cli;

/// Collection model code base.
///
/// ドキュメントモデルのコードベース。
class DocumentModelCliCode extends CliCode {
  /// Collection model code base.
  ///
  /// ドキュメントモデルのコードベース。
  const DocumentModelCliCode();

  @override
  String get name => "document_model";

  @override
  String get prefix => "documentModel";

  @override
  String get description =>
      "Create the code necessary to create the document model. The model name is [(filename)Model]. ドキュメントモデル作成に必要なコードを作成します。モデル名は[(ファイル名)Model]となります。";

  @override
  String import(String baseName) {
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
  String header(String baseName) {
    return """
import 'package:freezed_annotation/freezed_annotation.dart';

part '$baseName.m.dart';
part '$baseName.g.dart';
part '$baseName.freezed.dart';
""";
  }

  @override
  String body(String className) {
    return """
/// Value for model.
@freezed
@formValue
// TODO: Set the path for the document.
@DocumentModelPath("\${1}")
class ${className}Model with _\$${className}Model {
  const factory ${className}Model({
     // TODO: Set the data schema.
     \${2}
  }) = _${className}Model;
  const ${className}Model._();

  factory ${className}Model.fromJson(Map<String, Object?> json) => \$${className}ModelFromJson(json);

  /// Query for document.
  ///
  /// ```dart
  /// appRef.model(${className}Model.document());      // Get the document.
  /// ref.model(${className}Model.document())..load(); // Load the document.
  /// ```
  static const document = _\$${className}ModelDocumentQuery();

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
