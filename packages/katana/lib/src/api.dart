part of katana;

/// HTTP requests can be sent.
///
/// Wrapper for http package.
class Api {
  const Api._();

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  static Future<ApiResponse> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
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
  static Future<ApiResponse> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(path);
    return http.get(
      url,
      headers: headers,
    );
  }

  /// Sends an HTTP HEAD request with the given headers to the given URL.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once the request is complete. If you're planning on making multiple requests to the same server, you should use a single [http.Client] for all of those requests.
  static Future<ApiResponse> head(
    String path, {
    Map<String, String>? headers,
  }) async {
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
  static Future<ApiResponse> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
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
  static Future<ApiResponse> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
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
  static Future<ApiResponse> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final url = Uri.parse(path);
    return http.put(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a [String].
  ///
  /// The Future will emit a [http.ClientException] if the response doesn't have a
  /// success status code.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once
  /// the request is complete. If you're planning on making multiple requests to
  /// the same server, you should use a single [http.Client] for all of those requests.
  Future<String> read(
    String path, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(path);
    return http.read(url, headers: headers);
  }

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a list of
  /// bytes.
  ///
  /// The Future will emit a [http.ClientException] if the response doesn't have a
  /// success status code.
  ///
  /// This automatically initializes a new [http.Client] and closes that client once
  /// the request is complete. If you're planning on making multiple requests to
  /// the same server, you should use a single [http.Client] for all of those requests.
  Future<Uint8List> readBytes(
    String path, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(path);
    return http.readBytes(url, headers: headers);
  }
}

/// An HTTP response where the entire response body is known in advance.
typedef ApiResponse = http.Response;

/// An HTTP request where the entire request body is known in advance.
typedef ApiResquest = http.Request;
