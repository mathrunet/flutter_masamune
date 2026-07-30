// Dart imports:
import "dart:convert";
import "dart:io";

/// Contract used by TiDB Data Service management operations.
abstract interface class TidbDataServiceApi {
  /// Sends a Data Service management API request.
  Future<Map<String, dynamic>> dataService(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  });
}

/// A TiDB Data Service endpoint owned by the current Katana project.
class TidbManagedEndpointOwnership {
  /// Creates an owned endpoint record.
  const TidbManagedEndpointOwnership({
    required this.name,
    required this.method,
    required this.path,
  });

  /// Reads an owned endpoint record from JSON.
  factory TidbManagedEndpointOwnership.fromJson(Map value) {
    return TidbManagedEndpointOwnership(
      name: value["name"]?.toString().trim() ?? "",
      method: value["method"]?.toString().trim().toUpperCase() ?? "",
      path: value["path"]?.toString().trim() ?? "",
    );
  }

  /// Full TiDB endpoint resource name.
  final String name;

  /// HTTP method.
  final String method;

  /// Data Service endpoint path.
  final String path;

  /// Stable method and path key.
  String get key => "$method:$path";

  /// Whether this record can prove ownership of [endpoint].
  bool matchesEndpoint(Map endpoint) {
    return name.isNotEmpty &&
        name == endpoint["name"]?.toString().trim() &&
        method == endpoint["method"]?.toString().trim().toUpperCase() &&
        path == endpoint["path"]?.toString().trim();
  }

  /// Converts this record to JSON.
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "method": method,
      "path": path,
    };
  }
}

/// Last successfully deployed TiDB endpoints for the current project.
class TidbEndpointOwnershipState {
  /// Creates an endpoint ownership state.
  const TidbEndpointOwnershipState({
    required this.appId,
    this.endpoints = const [],
  });

  /// Creates an empty ownership state.
  const TidbEndpointOwnershipState.empty()
      : appId = "",
        endpoints = const [];

  /// Decodes an endpoint ownership state.
  factory TidbEndpointOwnershipState.decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) {
      throw const FormatException(
        "TiDB endpoint ownership state must contain a JSON object.",
      );
    }
    final version = decoded["version"]?.toString() ?? "";
    if (version != "1") {
      throw FormatException(
        "Unsupported TiDB endpoint ownership state version: $version",
      );
    }
    final rawEndpoints = decoded["endpoints"];
    if (rawEndpoints is! List) {
      throw const FormatException(
        "TiDB endpoint ownership state must contain an endpoints array.",
      );
    }
    final endpoints = rawEndpoints
        .whereType<Map>()
        .map(TidbManagedEndpointOwnership.fromJson)
        .toList();
    if (endpoints.length != rawEndpoints.length ||
        endpoints.any(
          (endpoint) =>
              endpoint.name.isEmpty ||
              endpoint.method.isEmpty ||
              endpoint.path.isEmpty,
        )) {
      throw const FormatException(
        "TiDB endpoint ownership records must be complete.",
      );
    }
    return TidbEndpointOwnershipState(
      appId: decoded["app_id"]?.toString().trim() ?? "",
      endpoints: endpoints,
    );
  }

  /// TiDB Data App identifier.
  final String appId;

  /// Endpoints confirmed by the last successful deployment.
  final List<TidbManagedEndpointOwnership> endpoints;

  /// Whether this state belongs to [currentAppId].
  bool belongsTo(String currentAppId) {
    return appId.isNotEmpty && appId == currentAppId;
  }

  /// Returns previously deployed endpoints that are no longer desired.
  Iterable<TidbManagedEndpointOwnership> staleEndpoints({
    required String currentAppId,
    required Set<String> desiredKeys,
  }) {
    if (!belongsTo(currentAppId)) {
      return const [];
    }
    return endpoints.where((endpoint) => !desiredKeys.contains(endpoint.key));
  }

  /// Encodes this state as stable, human-readable JSON.
  String encode() {
    final sorted = [...endpoints]..sort((a, b) => a.key.compareTo(b.key));
    return "${const JsonEncoder.withIndent("  ").convert({
          "version": 1,
          "app_id": appId,
          "endpoints": sorted.map((endpoint) => endpoint.toJson()).toList(),
        })}\n";
  }
}

/// Minimal Digest-authenticated client for TiDB Cloud management APIs.
class TidbCloudManagementApi implements TidbDataServiceApi {
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
  @override
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

/// Deletes one endpoint and waits for its automatic deployment to finish.
Future<void> deleteTidbDataServiceEndpointAndWait(
  TidbDataServiceApi api, {
  required String appId,
  required String endpointName,
  Duration pollInterval = const Duration(seconds: 2),
  int maxAttempts = 30,
}) async {
  final deploymentsPath = "dataApps/$appId/deployments";
  Future<Map<String, dynamic>> latestDeployment() async {
    final response = await api.dataService(
      "GET",
      deploymentsPath,
      query: {"pageSize": "1"},
    );
    final deployments = response["deployments"];
    if (deployments is! List || deployments.isEmpty) {
      return const {};
    }
    final latest = deployments.first;
    if (latest is! Map) {
      return const {};
    }
    return latest.map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }

  final previousDeployment = await latestDeployment();
  final previousName = previousDeployment["name"]?.toString() ?? "";
  await api.dataService("DELETE", endpointName);
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    final deployment = await latestDeployment();
    final name = deployment["name"]?.toString() ?? "";
    final status = deployment["status"]?.toString().toLowerCase() ?? "";
    if (name.isEmpty || name == previousName) {
      await Future<void>.delayed(pollInterval);
      continue;
    }
    if (status == "success") {
      return;
    }
    if (status == "failed") {
      throw StateError(
        "TiDB Data Service endpoint deletion deployment failed: "
        "${deployment["statusErrorMessage"]}",
      );
    }
    await Future<void>.delayed(pollInterval);
  }
  throw StateError(
    "Timed out waiting for the TiDB Data Service endpoint deletion "
    "deployment.",
  );
}

/// Retries a newly deployed endpoint while TiDB propagates the deployment.
Future<Map<String, dynamic>> retryTidbDataEndpointUntilDeployed(
  Future<Map<String, dynamic>> Function() call, {
  Duration pollInterval = const Duration(seconds: 2),
  int maxAttempts = 10,
}) async {
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      return await call();
    } on HttpException catch (exception) {
      if (attempt == maxAttempts - 1 ||
          !exception.message.contains("deployed endpoint not found")) {
        rethrow;
      }
      await Future<void>.delayed(pollInterval);
    }
  }
  throw StateError("TiDB Data Service endpoint retry was exhausted.");
}

/// Lists every page from a TiDB Data Service collection.
Future<List<Map<String, dynamic>>> listTidbDataServicePages(
  TidbCloudManagementApi api,
  String path,
  String listKey,
) async {
  final items = <Map<String, dynamic>>[];
  String? pageToken;
  do {
    final response = await api.dataService(
      "GET",
      path,
      query: {
        "pageSize": "100",
        if (pageToken != null) "pageToken": pageToken,
      },
    );
    final values = response[listKey];
    if (values is List) {
      items.addAll(
        values.whereType<Map>().map(
              (value) => value.map(
                (key, item) => MapEntry(key.toString(), item),
              ),
            ),
      );
    }
    final next = response["nextPageToken"]?.toString() ?? "";
    pageToken = next.isEmpty ? null : next;
  } while (pageToken != null);
  return items;
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
