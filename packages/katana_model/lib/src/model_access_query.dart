part of "/katana_model.dart";

/// Stores information for accessing the server.
///
/// サーバーにアクセスするための情報を格納します。
class ModelAccessQuery {
  const ModelAccessQuery({
    required this.endpoint,
    this.type = ModelAccessQueryType.get,
    this.headers = const {},
    this.parameters = const {},
  });

  /// The type of access to the server.
  ///
  /// サーバーへのアクセスのタイプ。
  final ModelAccessQueryType type;

  /// The endpoint to access the server.
  ///
  /// サーバーへのアクセスのエンドポイント。
  final String endpoint;

  /// Header data to be sent to the server.
  ///
  /// サーバーに送信するヘッダーデータ。
  final DynamicMap headers;

  /// Parameters to be sent to the server.
  ///
  /// サーバーに送信するパラメーター。
  final DynamicMap parameters;
}

/// Define the type of access to the server.
///
/// サーバーへのアクセスのタイプを定義します。
enum ModelAccessQueryType {
  /// Get data from the server.
  ///
  /// サーバーからデータを取得します。
  get,

  /// Send data to the server.
  ///
  /// サーバーにデータを送信します。
  post,

  /// Update data on the server.
  ///
  /// サーバー上のデータを更新します。
  put,

  /// Delete data on the server.
  ///
  /// サーバー上のデータを削除します。
  delete;
}
