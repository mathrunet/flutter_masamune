part of "web.dart";

/// Provides static methods for making HTTP requests.
///
/// HTTPのリクエストを行うためのstaticメソッドを提供します。
class Api {
  const Api._();

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  ///
  /// 指定されたヘッダーを含む HTTP DELETE 要求を指定された URL に送信します。
  ///
  /// これにより、新しい [http.Client] が自動的に初期化され、リクエストが完了するとそのクライアントが閉じられます。同じサーバーに複数のリクエストを送信する予定がある場合は、それらすべてのリクエストに対して単一の [http.Client] を使用する必要があります。
  static Future<ApiResponse> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final url = Uri.parse(path);
    return http.delete(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  /// Sends an HTTP GET request with the given headers to the given URL.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  ///
  /// 指定されたヘッダーを含む HTTP GET 要求を指定された URL に送信します。
  ///
  /// これにより、新しい [http.Client] が自動的に初期化され、リクエストが完了するとそのクライアントが閉じられます。同じサーバーに複数のリクエストを送信する予定がある場合は、それらすべてのリクエストに対して単一の [http.Client] を使用する必要があります。
  static Future<ApiResponse> get(
    String path, {
    Map<String, String>? headers,
  }) {
    final url = Uri.parse(path);
    return http.get(
      url,
      headers: headers,
    );
  }

  /// Sends an HTTP HEAD request with the given headers to the given URL.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  ///
  /// 指定されたヘッダーを含む HTTP HEAD リクエストを指定された URL に送信します。
  ///
  /// これにより、新しい [http.Client] が自動的に初期化され、リクエストが完了するとそのクライアントが閉じられます。同じサーバーに複数のリクエストを送信する予定がある場合は、それらすべてのリクエストに対して単一の [http.Client] を使用する必要があります。
  static Future<ApiResponse> head(
    String path, {
    Map<String, String>? headers,
  }) {
    final url = Uri.parse(path);
    return http.head(
      url,
      headers: headers,
    );
  }

  /// Sends an HTTP PATCH request with the given headers and body to the given URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List] or a [Map<String, String>]. If it's a String, it's encoded using [encoding] and used as the body of the request. The content-type of the request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The content-type of the request will be set to "application/x-www-form-urlencoded"; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// 指定されたヘッダーと本文を含む HTTP PATCH 要求を指定された URL に送信します。
  ///
  /// [body] リクエストの本文を設定します。 [String]、[List]、または [Map<String, String>] のいずれかです。文字列の場合は、[encoding] を使用してエンコードされ、リクエストの本文として使用されます。リクエストの content-type は、デフォルトで「text/plain」になります。
  ///
  /// [body] がリストの場合、リクエストの本文のバイトのリストとして使用されます。
  ///
  /// [body] が Map の場合、[encoding] を使用してフォーム フィールドとしてエンコードされます。リクエストのコンテンツ タイプは「application/x-www-form-urlencoded」に設定されます。これはオーバーライドできません。
  ///
  /// [encoding] のデフォルトは [utf8] です。
  static Future<ApiResponse> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final url = Uri.parse(path);
    return http.patch(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  /// Sends an HTTP POST request with the given headers and body to the given URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List] or a [Map<String, String>]. If it's a String, it's encoded using [encoding] and used as the body of the request. The content-type of the request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The content-type of the request will be set to "application/x-www-form-urlencoded"; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// 指定されたヘッダーと本文を含む HTTP POST 要求を指定された URL に送信します。
  ///
  /// [body] リクエストの本文を設定します。 [String]、[List]、または [Map<String, String>] のいずれかです。文字列の場合は、[encoding] を使用してエンコードされ、リクエストの本文として使用されます。リクエストの content-type は、デフォルトで「text/plain」になります。
  ///
  /// [body] がリストの場合、リクエストの本文のバイトのリストとして使用されます。
  ///
  /// [body] が Map の場合、[encoding] を使用してフォーム フィールドとしてエンコードされます。リクエストのコンテンツ タイプは「application/x-www-form-urlencoded」に設定されます。これはオーバーライドできません。
  ///
  /// [encoding] のデフォルトは [utf8] です。
  static Future<ApiResponse> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final url = Uri.parse(path);
    return http.post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  /// Sends an HTTP PUT request with the given headers and body to the given URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List] or a [Map<String, String>]. If it's a String, it's encoded using [encoding] and used as the body of the request. The content-type of the request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The content-type of the request will be set to "application/x-www-form-urlencoded"; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// 指定されたヘッダーと本文を含む HTTP PUT 要求を指定された URL に送信します。
  ///
  /// [body] リクエストの本文を設定します。 [String]、[List]、または [Map<String, String>] のいずれかです。文字列の場合は、[encoding] を使用してエンコードされ、リクエストの本文として使用されます。リクエストの content-type は、デフォルトで「text/plain」になります。
  ///
  /// [body] がリストの場合、リクエストの本文のバイトのリストとして使用されます。
  ///
  /// [body] が Map の場合、[encoding] を使用してフォーム フィールドとしてエンコードされます。リクエストのコンテンツ タイプは「application/x-www-form-urlencoded」に設定されます。これはオーバーライドできません。
  ///
  /// [encoding] のデフォルトは [utf8] です。
  static Future<ApiResponse> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    final url = Uri.parse(path);
    return http.put(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  /// Sends an HTTP GET request with the given headers to the given URL and　returns a Future that completes to the body of the response as a [String].
  ///
  /// The Future will emit a [http.ClientException] if the response doesn't have a success status code.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  ///
  /// 指定されたヘッダーを指定された HTTP GET リクエストを指定された URL に送信し、[String] としてレスポンスの本文に完了する Future を返します。
  ///
  /// レスポンスに成功ステータス コードがない場合、Future は [http.ClientException] を発行します。
  /// これにより、新しい [http.Client] が自動的に初期化され、リクエストが完了するとそのクライアントが閉じられます。同じサーバーに複数のリクエストを送信する予定がある場合は、それらすべてのリクエストに対して単一の [http.Client] を使用する必要があります。
  static Future<String> read(
    String path, {
    Map<String, String>? headers,
  }) {
    final url = Uri.parse(path);
    return http.read(url, headers: headers);
  }

  /// Sends an HTTP GET request with the given headers to the given URL and returns a Future that completes to the body of the response as a list of bytes.
  ///
  /// The Future will emit a [http.ClientException] if the response doesn't have a success status code.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  ///
  /// 指定されたヘッダーを持つ HTTP GET 要求を指定された URL に送信し、バイトのリストとして応答の本文に完了する Future を返します。
  ///
  /// レスポンスに成功ステータス コードがない場合、Future は [http.ClientException] を発行します。
  ///
  /// これにより、新しい [http.Client] が自動的に初期化され、リクエストが完了するとそのクライアントが閉じられます。同じサーバーに複数のリクエストを送信する予定がある場合は、それらすべてのリクエストに対して単一の [http.Client] を使用する必要があります。
  static Future<Uint8List> readBytes(
    String path, {
    Map<String, String>? headers,
  }) {
    final url = Uri.parse(path);
    return http.readBytes(url, headers: headers);
  }
}

/// An HTTP response where the entire response body is known in advance.
///
/// 応答本文全体が事前にわかっている HTTP レスポンス。
typedef ApiResponse = http.Response;

/// An HTTP request where the entire request body is known in advance.
///
/// リクエスト本文全体が事前にわかっている HTTP リクエスト。
typedef ApiResquest = http.Request;

/// An HTTP method.
///
/// HTTP メソッド。
enum ApiMethod {
  /// GET
  ///
  /// GET
  get,

  /// POST
  ///
  /// POST
  post,

  /// PUT
  ///
  /// PUT
  put,

  /// PATCH
  ///
  /// PATCH
  patch,

  /// DELETE
  ///
  /// DELETE
  delete,

  /// HEAD
  ///
  /// HEAD
  head;
}
