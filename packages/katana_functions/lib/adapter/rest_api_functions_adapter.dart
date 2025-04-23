part of '/katana_functions.dart';

/// Adapter to execute functions using Rest API.
///
/// Specify the base endpoint in [endpoint].
///
/// Rest APIを用いて関数を実行するアダプター。
///
/// [endpoint]にベースのエンドポイントを指定します。
class RestApiFunctionsAdapter extends FunctionsAdapter {
  /// Adapter to execute functions using Rest API.
  ///
  /// Specify the base endpoint in [endpoint].
  ///
  /// Rest APIを用いて関数を実行するアダプター。
  ///
  /// [endpoint]にベースのエンドポイントを指定します。
  const RestApiFunctionsAdapter({
    required this.endpoint,
    this.method = ApiMethod.post,
    this.headers = defaultHeaders,
    this.checkError = defaultCheckError,
    this.dataOnExecute = defaultDataOnExecute,
    this.onResponse = defaultOnResponse,
  });

  @override
  final String endpoint;

  /// Method.
  ///
  /// メソッド。
  final ApiMethod method;

  /// Headers.
  ///
  /// ヘッダー。
  final FutureOr<Map<String, String>> Function() headers;

  /// A function that returns `true` if the response is an error.
  ///
  /// レスポンスがエラーの場合は`true`を返します。
  final bool Function(ApiResponse response) checkError;

  /// Data on post.
  ///
  /// ポストデータ。
  final FutureOr<Object> Function(DynamicMap input) dataOnExecute;

  /// On response.
  ///
  /// レスポンス。
  final FutureOr<DynamicMap?> Function(ApiResponse response) onResponse;

  /// Default headers.
  ///
  /// デフォルトのヘッダー。
  static FutureOr<Map<String, String>> defaultHeaders() {
    return {};
  }

  /// Default check error.
  ///
  /// デフォルトのエラーチェック。
  static bool defaultCheckError(ApiResponse response) {
    return response.statusCode >= 400;
  }

  /// Default data on execute.
  ///
  /// デフォルトのポストデータ。
  static FutureOr<Object> defaultDataOnExecute(DynamicMap input) {
    return jsonEncode(input);
  }

  /// Default on response.
  ///
  /// デフォルトのレスポンス。
  static FutureOr<DynamicMap?> defaultOnResponse(ApiResponse response) {
    return jsonDecodeAsMap(response.body);
  }

  @override
  Future<TResponse> execute<TResponse>(
      FunctionsAction<TResponse> action) async {
    try {
      final method = action.method ?? this.method;
      final path =
          "${endpoint.trimQuery().trimString("/")}/${(action.path ?? action.action).trimString("/")}";
      final headers = await (action.headers ?? this.headers());
      return await action.execute((map) async {
        switch (method) {
          case ApiMethod.get:
            final res = await Api.get(path, headers: headers);
            if (checkError(res)) {
              throw RestApiFunctionsAdapterException(
                uri: Uri.tryParse(path),
                response: res.body,
                statusCode: res.statusCode,
              );
            }
            return await onResponse(res);
          case ApiMethod.post:
            final body = await dataOnExecute(map ?? {});
            final res = await Api.post(path, headers: headers, body: body);
            if (checkError(res)) {
              throw RestApiFunctionsAdapterException(
                uri: Uri.tryParse(path),
                response: res.body,
                statusCode: res.statusCode,
              );
            }
            return await onResponse(res);
          case ApiMethod.put:
            final body = await dataOnExecute(map ?? {});
            final res = await Api.put(path, headers: headers, body: body);
            if (checkError(res)) {
              throw RestApiFunctionsAdapterException(
                uri: Uri.tryParse(path),
                response: res.body,
                statusCode: res.statusCode,
              );
            }
            return await onResponse(res);
          case ApiMethod.patch:
            final body = await dataOnExecute(map ?? {});
            final res = await Api.patch(path, headers: headers, body: body);
            if (checkError(res)) {
              throw RestApiFunctionsAdapterException(
                uri: Uri.tryParse(path),
                response: res.body,
                statusCode: res.statusCode,
              );
            }
            return await onResponse(res);
          case ApiMethod.delete:
            final res = await Api.delete(path, headers: headers);
            if (checkError(res)) {
              throw RestApiFunctionsAdapterException(
                uri: Uri.tryParse(path),
                response: res.body,
                statusCode: res.statusCode,
              );
            }
            return await onResponse(res);
          case ApiMethod.head:
            final res = await Api.head(path, headers: headers);
            if (checkError(res)) {
              throw RestApiFunctionsAdapterException(
                uri: Uri.tryParse(path),
                response: res.body,
                statusCode: res.statusCode,
              );
            }
            return await onResponse(res);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  int get hashCode => runtimeType.hashCode ^ endpoint.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Exception raised when execution fails.
///
/// 実行に失敗した場合に投げられる例外。
class RestApiFunctionsAdapterException implements Exception {
  /// Exception raised when execution fails.
  ///
  /// 実行に失敗した場合に投げられる例外。
  const RestApiFunctionsAdapterException(
      {this.uri, this.response, this.statusCode});

  /// The URI of the request.
  ///
  /// リクエストのURI。
  final Uri? uri;

  /// The response of the request.
  ///
  /// リクエストのレスポンス。
  final String? response;

  /// The status code of the response.
  ///
  /// レスポンスのステータスコード。
  final int? statusCode;

  @override
  String toString() {
    return "RestApiFunctionsAdapterException($uri, $statusCode, $response)";
  }
}
