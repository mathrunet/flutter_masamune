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
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final request = await _client.openUrl(method, uri);
        request.headers
          ..set(HttpHeaders.acceptHeader, "application/json")
          ..set(HttpHeaders.contentTypeHeader, "application/json");
        if (body != null) {
          final encodedBody = utf8.encode(jsonEncode(body));
          request.contentLength = encodedBody.length;
          request.add(encodedBody);
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
        if (response.statusCode == HttpStatus.badRequest &&
            body != null &&
            attempt == 0) {
          continue;
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
      } on HttpException catch (exception) {
        if (!exception.message.contains(
          "Connection closed before full header was received",
        )) {
          rethrow;
        }
        if (attempt == 0) {
          continue;
        }
        return _callTidbCloudApiWithCurl(
          uri: uri,
          publicKey: publicKey,
          privateKey: privateKey,
          method: method,
          body: body,
        );
      }
    }
    throw StateError("TiDB Cloud API request retry was exhausted.");
  }

  /// Closes the underlying HTTP client.
  void close() {
    _client.close();
  }
}

Future<Map<String, dynamic>> _callTidbCloudApiWithCurl({
  required Uri uri,
  required String publicKey,
  required String privateKey,
  required String method,
  required Object? body,
}) {
  return _callTidbDataEndpointWithCurl(
    uri: uri,
    publicKey: publicKey,
    privateKey: privateKey,
    method: method,
    body: body,
  );
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
  late HttpClientResponse response;
  var text = "";
  for (var attempt = 0; attempt < 2; attempt++) {
    try {
      final request = await client.openUrl(method, uri);
      request.headers
        ..set(HttpHeaders.acceptHeader, "application/json")
        ..set(HttpHeaders.contentTypeHeader, "application/json");
      if (body != null) {
        final encodedBody = utf8.encode(jsonEncode(body));
        request.contentLength = encodedBody.length;
        request.add(encodedBody);
      }
      response = await request.close();
      text = await utf8.decoder.bind(response).join();
    } on HttpException catch (exception) {
      if (attempt == 0 &&
          exception.message.contains(
            "Connection closed before full header was received",
          )) {
        continue;
      }
      if (exception.message.contains(
        "Connection closed before full header was received",
      )) {
        client.close();
        for (var curlAttempt = 0; curlAttempt < 10; curlAttempt++) {
          try {
            return await _callTidbDataEndpointWithCurl(
              uri: uri,
              publicKey: publicKey,
              privateKey: privateKey,
              method: method,
              body: body,
            );
          } on HttpException catch (curlException) {
            if (curlAttempt == 9 ||
                !curlException.message.contains(
                  "deployed endpoint not found",
                )) {
              rethrow;
            }
            await Future<void>.delayed(const Duration(seconds: 2));
          }
        }
      }
      rethrow;
    }
    // HttpClient's first Digest challenge can consume a POST body without
    // replaying it. The authenticated connection is cached after that
    // challenge, so retry the same body once when the endpoint reports a
    // missing parameter.
    if (response.statusCode != HttpStatus.badRequest ||
        body == null ||
        attempt == 1 ||
        !text.contains("parameter is required")) {
      break;
    }
  }
  client.close();
  final decoded = text.isEmpty ? <String, dynamic>{} : jsonDecode(text);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      "TiDB Data Service smoke test failed "
      "(${response.statusCode}): $text",
      uri: uri,
    );
  }
  final normalized = decoded is Map
      ? decoded.map((key, value) => MapEntry(key.toString(), value))
      : <String, dynamic>{"data": decoded};
  _validateTidbDataResult(normalized, uri);
  return normalized;
}

Future<Map<String, dynamic>> _callTidbDataEndpointWithCurl({
  required Uri uri,
  required String publicKey,
  required String privateKey,
  required String method,
  required Object? body,
}) async {
  final temporaryDirectory = await Directory.systemTemp.createTemp(
    "katana_tidb_data_service_",
  );
  try {
    final config = File("${temporaryDirectory.path}/curl.config");
    await config.writeAsString(
      'user = ${jsonEncode("$publicKey:$privateKey")}\n'
      "silent\n"
      "show-error\n",
    );
    if (!Platform.isWindows) {
      final chmod = await Process.run("chmod", ["600", config.path]);
      if (chmod.exitCode != 0) {
        throw ProcessException(
          "chmod",
          ["600", config.path],
          chmod.stderr.toString(),
          chmod.exitCode,
        );
      }
    }
    final arguments = <String>[
      "--digest",
      "--config",
      config.path,
      "--request",
      method,
      "--header",
      "Accept: application/json",
      "--header",
      "Content-Type: application/json",
    ];
    if (body != null) {
      final bodyFile = File("${temporaryDirectory.path}/body.json");
      await bodyFile.writeAsString(jsonEncode(body));
      arguments
        ..add("--data-binary")
        ..add("@${bodyFile.path}");
    }
    arguments
      ..add("--write-out")
      ..add("\n%{http_code}")
      ..add(uri.toString());
    final result = await Process.run("curl", arguments);
    if (result.exitCode != 0) {
      throw ProcessException(
        "curl",
        arguments,
        result.stderr.toString(),
        result.exitCode,
      );
    }
    final output = result.stdout.toString();
    final separator = output.lastIndexOf("\n");
    if (separator < 0) {
      throw const FormatException(
        "TiDB Data Service curl response did not include a status code.",
      );
    }
    final text = output.substring(0, separator);
    final statusCode = int.tryParse(output.substring(separator + 1).trim());
    if (statusCode == null) {
      throw const FormatException(
        "TiDB Data Service curl status code was invalid.",
      );
    }
    final decoded = text.isEmpty ? <String, dynamic>{} : jsonDecode(text);
    if (statusCode < 200 || statusCode >= 300) {
      throw HttpException(
        "TiDB Data Service smoke test failed ($statusCode): $text",
        uri: uri,
      );
    }
    final normalized = decoded is Map
        ? decoded.map((key, value) => MapEntry(key.toString(), value))
        : <String, dynamic>{"data": decoded};
    _validateTidbDataResult(normalized, uri);
    return normalized;
  } finally {
    if (temporaryDirectory.existsSync()) {
      await temporaryDirectory.delete(recursive: true);
    }
  }
}

void _validateTidbDataResult(Map<String, dynamic> response, Uri uri) {
  final data = response["data"];
  if (data is! Map) {
    return;
  }
  final result = data["result"];
  if (result is! Map) {
    return;
  }
  final code = int.tryParse(result["code"]?.toString() ?? "");
  if (code == null || (code >= 200 && code < 300)) {
    return;
  }
  throw HttpException(
    "TiDB Data Service query failed ($code): ${result["message"]}",
    uri: uri,
  );
}
