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
    required this.action,
    required this.method,
    this.data,
  });

  /// Data for Post and Put.
  ///
  /// PostやPutのデータ。
  final DynamicMap? data;

  @override
  final ApiMethod method;

  @override
  final String action;

  @override
  DynamicMap? toMap() {
    assert(
        method == ApiMethod.get ||
            method == ApiMethod.delete ||
            data.isNotEmpty,
        "If the method is POST or PUT, data is required.");
    return {
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
