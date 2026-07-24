// Dart imports:
import "dart:convert";
import "dart:io";

/// Minimal Digest-authenticated client for TiDB Cloud management APIs.
class TidbCloudManagementApi {
  /// Creates a management API client.
  TidbCloudManagementApi({
    required this.publicKey,
    required this.privateKey,
  }) {
    _client.authenticate = (uri, scheme, realm) {
      _client.addCredentials(
        uri,
        realm ?? "",
        HttpClientDigestCredentials(publicKey, privateKey),
      );
      return Future.value(true);
    };
  }

  /// TiDB Cloud organization API public key.
  final String publicKey;

  /// TiDB Cloud organization API private key.
  final String privateKey;

  final HttpClient _client = HttpClient();

  /// Sends a Data Service management API request.
  Future<Map<String, dynamic>> dataService(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) {
    return request(
      method,
      Uri.https("dataservice.tidbapi.com", "/v1beta1/$path", query),
      body: body,
    );
  }

  /// Sends a Starter management API request.
  Future<Map<String, dynamic>> starter(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) {
    return request(
      method,
      Uri.https("serverless.tidbapi.com", "/v1beta1/$path", query),
      body: body,
    );
  }

  /// Sends a Digest-authenticated request.
  Future<Map<String, dynamic>> request(
    String method,
    Uri uri, {
    Object? body,
  }) async {
    final request = await _client.openUrl(method, uri);
    request.headers
      ..set(HttpHeaders.acceptHeader, "application/json")
      ..set(HttpHeaders.contentTypeHeader, "application/json");
    if (body != null) {
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    final text = await utf8.decoder.bind(response).join();
    Map<String, dynamic> decoded = {};
    if (text.isNotEmpty) {
      final value = jsonDecode(text);
      if (value is Map) {
        decoded = value.map(
          (key, item) => MapEntry(key.toString(), item),
        );
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded["message"] ??
          (decoded["error"] is Map
              ? (decoded["error"] as Map)["message"]
              : null) ??
          text;
      throw HttpException(
        "TiDB Cloud API $method $uri failed "
        "(${response.statusCode}): $message",
        uri: uri,
      );
    }
    return decoded;
  }

  /// Closes the underlying HTTP client.
  void close() {
    _client.close();
  }
}

/// Calls a deployed Data Service endpoint with Digest authentication.
Future<Map<String, dynamic>> callTidbDataEndpoint({
  required String region,
  required String appId,
  required String path,
  required String publicKey,
  required String privateKey,
  String method = "GET",
  Map<String, String>? query,
  Object? body,
}) async {
  final client = HttpClient();
  client.authenticate = (uri, scheme, realm) {
    client.addCredentials(
      uri,
      realm ?? "",
      HttpClientDigestCredentials(publicKey, privateKey),
    );
    return Future.value(true);
  };
  final normalizedPath = path
      .split("/")
      .where((segment) => segment.isNotEmpty)
      .map(Uri.encodeComponent)
      .join("/");
  final uri = Uri.https(
    "$region.data.tidbcloud.com",
    "/api/v1beta/app/${Uri.encodeComponent(appId)}/endpoint/$normalizedPath",
    query,
  );
  final request = await client.openUrl(method, uri);
  request.headers
    ..set(HttpHeaders.acceptHeader, "application/json")
    ..set(HttpHeaders.contentTypeHeader, "application/json");
  if (body != null) {
    request.write(jsonEncode(body));
  }
  final response = await request.close();
  final text = await utf8.decoder.bind(response).join();
  client.close();
  final decoded = text.isEmpty ? <String, dynamic>{} : jsonDecode(text);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      "TiDB Data Service smoke test failed "
      "(${response.statusCode}): $text",
      uri: uri,
    );
  }
  return decoded is Map
      ? decoded.map((key, value) => MapEntry(key.toString(), value))
      : <String, dynamic>{"data": decoded};
}
