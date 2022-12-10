part of katana_cli;

/// Collection model code base.
///
/// コレクションモデルのコードベース。
class CollectionModelCliCode extends CliCode {
  /// Collection model code base.
  ///
  /// コレクションモデルのコードベース。
  const CollectionModelCliCode();

  @override
  String get name => "collection_model";

  @override
  String get prefix => "collectionModel";

  @override
  String get description =>
      "Create the code needed to create the collection and document models. The model name will be [(filename)Model]. コレクションおよびドキュメントモデル作成に必要なコードを作成します。モデル名は[(ファイル名)Model]となります。";

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
// TODO: Set the path for the collection.
@CollectionModelPath("\${1}")
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
  /// appRef.model(${className}Model.document(id));      // Get the document.
  /// ref.model(${className}Model.document(id))..load(); // Load the document.
  /// ```
  static const document = _\$${className}ModelDocumentQuery();

  /// Query for collection.
  ///
  /// ```dart
  /// appRef.model(${className}Model.collectoin());      // Get the collection.
  /// ref.model(${className}Model.collection())..load(); // Load the collection.
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
