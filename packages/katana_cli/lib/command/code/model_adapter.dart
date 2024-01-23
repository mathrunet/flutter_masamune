part of "code.dart";

/// Create a base class for ModelAdapter.
///
/// ModelAdapterのベースクラスを作成します。
class CodeModelAdapterCliCommand extends CliCodeCommand {
  /// Create a base class for ModelAdapter.
  ///
  /// ModelAdapterのベースクラスを作成します。
  const CodeModelAdapterCliCommand();

  @override
  String get name => "model_adapter";

  @override
  String get prefix => "model_adapter";

  @override
  String get directory => "lib/adapters";

  @override
  String get description =>
      "Create a ModelAdapter base class in `$directory/(filepath).dart`. ModelAdapterのベースクラスを`$directory/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code model_adapter [path]\r\n",
      );
      return;
    }
    label("Create a ModelAdapter class in `$directory/$path.dart`.");
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
import 'dart:async';

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
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """

/// Model adapter for use with DocumentModel and CollectionModel.
///
/// It can be given by [MasamuneApp] or various [ModelQuery], or specified by [CollectionModelPath] or [DocumentModelPath].
@immutable
class ${className}ModelAdapter extends ModelAdapter {
  /// Model adapter for use with DocumentModel and CollectionModel.
  ///
  /// It can be given by [MasamuneApp] or various [ModelQuery], or specified by [CollectionModelPath] or [DocumentModelPath].
  const ${className}ModelAdapter();

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) {
    // TODO: implement loadDocument
    throw UnimplementedError();
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) {
    // TODO: implement loadCollection
    throw UnimplementedError();
  }

  @override
  Future<num> loadAggregation(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) {
    // TODO: implement loadAggregation
    throw UnimplementedError();
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    // TODO: implement saveDocument
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    // TODO: implement disposeDocument
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    // TODO: implement disposeCollection
  }

  @override
  Future<void> clearAll() {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  // TODO: implement availableListen
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    // TODO: implement listenDocument
    throw UnsupportedError("This function is not supported.");
  }

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    // TODO: implement listenCollection
    throw UnsupportedError("This function is not supported.");
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(ModelTransactionRef ref) transaction,
  ) async {
    // TODO: implement runTransaction
    final ref = ${className}ModelTransactionRef._();
    await transaction.call(ref);
    for (final tmp in ref._transactionList) {
      await tmp.call();
    }
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    // TODO: implement loadOnTransaction
    throw UnsupportedError("This function is not supported.");
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! ${className}ModelTransactionRef) {
      throw Exception("[ref] is not [${className}ModelTransactionRef].");
    }
    // TODO: implement saveOnTransaction
    throw UnsupportedError("This function is not supported.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! ${className}ModelTransactionRef) {
      throw Exception("[ref] is not [${className}ModelTransactionRef].");
    }
    // TODO: implement deleteOnTransaction
    throw UnsupportedError("This function is not supported.");
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(ModelBatchRef ref) batch,
    int splitLength,
  ) async {
    // TODO: implement runBatch
    final ref = ${className}ModelBatchRef._();
    await wait(
      ref._batchList.map((tmp) => tmp.call()),
    );
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! ${className}ModelBatchRef) {
      throw Exception("[ref] is not [${className}ModelBatchRef].");
    }
    // TODO: implement saveOnBatch
    throw UnsupportedError("This function is not supported.");
  }

  @override
  void deleteOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! ${className}ModelBatchRef) {
      throw Exception("[ref] is not [${className}ModelBatchRef].");
    }
    // TODO: implement deleteOnBatch
    throw UnsupportedError("This function is not supported.");
  }
}

/// [ModelTransactionRef] for [${className}ModelAdapter].
@immutable
class ${className}ModelTransactionRef extends ModelTransactionRef {
  ${className}ModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}

/// [ModelBatchRef] for [${className}ModelAdapter].
@immutable
class ${className}ModelBatchRef extends ModelBatchRef {
  ${className}ModelBatchRef._();

  final List<FutureOr<void> Function()> _batchList = [];
}
""";
  }
}
