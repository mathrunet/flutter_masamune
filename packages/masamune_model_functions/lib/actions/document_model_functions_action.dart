part of "/masamune_model_functions.dart";

/// FunctionsAction for reading and writing documents.
///
/// ドキュメントを読み書きするためのFunctionsAction。
class DocumentModelFunctionsAction
    extends FunctionsAction<DocumentModelFunctionsActionResponse> {
  /// FunctionsAction for reading and writing documents.
  ///
  /// ドキュメントを読み書きするためのFunctionsAction。
  const DocumentModelFunctionsAction({
    required this.path,
    required this.method,
    this.action = "document_model_firestore",
    this.data,
  });

  /// Data for Post and Put.
  ///
  /// PostやPutのデータ。
  final DynamicMap? data;

  @override
  final String path;

  @override
  final ApiMethod method;

  @override
  final String action;

  @override
  DynamicMap? toMap() {
    final path = this.path.trimQuery().trimString("/");
    assert(
        method == ApiMethod.get ||
            method == ApiMethod.delete ||
            data.isNotEmpty,
        "If the method is POST or PUT, data is required.");
    assert(
      !(path.splitLength() <= 0 || path.splitLength() % 2 != 0),
      "The query path hierarchy must be an even number: $path",
    );
    assert(
      !path.contains("//"),
      "The query path hierarchy must not contain double slashes: $path",
    );
    return {
      "path": path,
      "method": method.name,
      if (data != null) "data": data,
    };
  }

  @override
  DocumentModelFunctionsActionResponse toResponse(DynamicMap map) {
    final status = map.getAsInt("status");
    final data = map.getAsMap("data");
    return DocumentModelFunctionsActionResponse(
      status: status,
      data: data.isEmpty ? null : data,
    );
  }
}

/// Response for [DocumentModelFunctionsAction].
///
/// [DocumentModelFunctionsAction]のレスポンス。
class DocumentModelFunctionsActionResponse extends FunctionsActionResponse {
  /// Response for [DocumentModelFunctionsAction].
  ///
  /// [DocumentModelFunctionsAction]のレスポンス。
  const DocumentModelFunctionsActionResponse({
    required this.status,
    this.data,
  });

  /// Status.
  ///
  /// ステータス。
  final int status;

  /// Data.
  ///
  /// データ。
  final DynamicMap? data;
}
