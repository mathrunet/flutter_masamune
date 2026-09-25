// Dart imports:
import "dart:convert";
import "dart:io";

/// Default endpoint of the Cloudflare API.
///
/// Cloudflare APIの既定のエンドポイント。
const cloudflareApiDefaultBaseUrl = "https://api.cloudflare.com/client/v4/";

/// Minimal client of the Cloudflare API used by `katana apply`.
///
/// The token is only sent in the `Authorization` header and is never included
/// in exceptions or logs.
///
/// `katana apply`で使用するCloudflare APIの最小限のクライアント。
///
/// トークンは`Authorization`ヘッダーでのみ送信され、例外やログには含まれません。
class CloudflareApi {
  /// Minimal client of the Cloudflare API used by `katana apply`.
  ///
  /// [baseUrl] can be replaced (e.g. with a loopback server in tests).
  ///
  /// `katana apply`で使用するCloudflare APIの最小限のクライアント。
  ///
  /// [baseUrl]は差し替え可能です（テストでのループバックサーバーなど）。
  CloudflareApi({
    required String token,
    Uri? baseUrl,
    HttpClient? client,
  })  : _token = token,
        baseUrl = _withTrailingSlash(
          baseUrl ?? Uri.parse(cloudflareApiDefaultBaseUrl),
        ),
        _client = client ?? HttpClient();

  final String _token;

  /// API endpoint. Tests may use an in-process endpoint.
  ///
  /// APIのエンドポイント。テストではプロセス内のエンドポイントを使用できます。
  final Uri baseUrl;

  final HttpClient _client;

  /// Returns the `*.pages.dev` subdomain of the Pages project [project].
  ///
  /// `GET /accounts/{account_id}/pages/projects/{project}`
  ///
  /// Pagesプロジェクト[project]の`*.pages.dev`サブドメインを返します。
  Future<String?> getPagesProjectSubdomain(
    String accountId,
    String project,
  ) async {
    final result = await _result(
      "GET",
      "accounts/${_encode(accountId)}/pages/projects/${_encode(project)}",
      operation: "get Pages project `$project`",
    );
    final subdomain = result is Map ? result["subdomain"] : null;
    return subdomain is String && subdomain.isNotEmpty ? subdomain : null;
  }

  /// Lists the custom domains of the Pages project [project].
  ///
  /// `GET /accounts/{account_id}/pages/projects/{project}/domains`
  ///
  /// Pagesプロジェクト[project]のカスタムドメイン一覧を取得します。
  Future<List<CloudflarePagesDomain>> listPagesDomains(
    String accountId,
    String project,
  ) async {
    final result = await _result(
      "GET",
      _pagesDomainsPath(accountId, project),
      operation: "list Pages domains of `$project`",
    );
    if (result is! List) {
      throw const FormatException(
        "Unexpected response format of the Cloudflare Pages domains API.",
      );
    }
    return result.whereType<Map>().map(CloudflarePagesDomain.fromJson).toList();
  }

  /// Attaches the custom domain [domain] to the Pages project [project].
  ///
  /// `POST /accounts/{account_id}/pages/projects/{project}/domains`
  ///
  /// Pagesプロジェクト[project]にカスタムドメイン[domain]を接続します。
  Future<CloudflarePagesDomain> addPagesDomain(
    String accountId,
    String project,
    String domain,
  ) async {
    final result = await _result(
      "POST",
      _pagesDomainsPath(accountId, project),
      body: {"name": domain},
      operation: "attach `$domain` to Pages project `$project`",
    );
    if (result is! Map) {
      return CloudflarePagesDomain(name: domain, status: "");
    }
    return CloudflarePagesDomain.fromJson(result);
  }

  /// Returns the zone [zoneId].
  ///
  /// `GET /zones/{zone_id}`
  ///
  /// ゾーン[zoneId]を取得します。
  Future<CloudflareZone> getZone(String zoneId) async {
    final result = await _result(
      "GET",
      "zones/${_encode(zoneId)}",
      operation: "get zone `$zoneId`",
    );
    if (result is! Map) {
      throw const FormatException(
        "Unexpected response format of the Cloudflare zones API.",
      );
    }
    return CloudflareZone.fromJson(result);
  }

  /// Lists the DNS records named [name] in the zone [zoneId].
  ///
  /// `GET /zones/{zone_id}/dns_records?name={name}`
  ///
  /// ゾーン[zoneId]の名前が[name]のDNSレコード一覧を取得します。
  Future<List<CloudflareDnsRecord>> listDnsRecords(
    String zoneId,
    String name,
  ) async {
    final result = await _result(
      "GET",
      "zones/${_encode(zoneId)}/dns_records?name=${Uri.encodeQueryComponent(name)}",
      operation: "list DNS records of `$name`",
    );
    if (result is! List) {
      throw const FormatException(
        "Unexpected response format of the Cloudflare DNS records API.",
      );
    }
    return result.whereType<Map>().map(CloudflareDnsRecord.fromJson).toList();
  }

  /// Creates a proxied CNAME record from [name] to [content] in [zoneId].
  ///
  /// `POST /zones/{zone_id}/dns_records`
  ///
  /// ゾーン[zoneId]に[name]から[content]へのプロキシ有効なCNAMEレコードを作成します。
  Future<void> createProxiedCname(
    String zoneId, {
    required String name,
    required String content,
  }) async {
    await _result(
      "POST",
      "zones/${_encode(zoneId)}/dns_records",
      body: {
        "type": "CNAME",
        "name": name,
        "content": content,
        "proxied": true,
        "ttl": 1,
      },
      operation: "create CNAME `$name` -> `$content`",
    );
  }

  /// Closes the underlying HTTP client.
  ///
  /// 内部のHTTPクライアントを閉じます。
  void close() {
    _client.close(force: true);
  }

  String _pagesDomainsPath(String accountId, String project) =>
      "accounts/${_encode(accountId)}/pages/projects/${_encode(project)}/domains";

  static String _encode(String value) => Uri.encodeComponent(value);

  static Uri _withTrailingSlash(Uri uri) =>
      uri.path.endsWith("/") ? uri : uri.replace(path: "${uri.path}/");

  Future<Object?> _result(
    String method,
    String path, {
    required String operation,
    Map<String, Object?>? body,
  }) async {
    final request = await _client.openUrl(method, baseUrl.resolve(path));
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $_token");
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    final content = await utf8.decoder.bind(response).join();
    Object? decoded;
    try {
      decoded = content.isEmpty ? null : jsonDecode(content);
    } on FormatException {
      decoded = null;
    }
    final success = decoded is Map ? decoded["success"] : null;
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        success == false) {
      throw CloudflareApiException(
        statusCode: response.statusCode,
        body: content,
        operation: operation,
      );
    }
    return decoded is Map ? decoded["result"] : null;
  }
}

/// Custom domain of a Cloudflare Pages project.
///
/// Cloudflare Pagesプロジェクトのカスタムドメイン。
class CloudflarePagesDomain {
  /// Custom domain of a Cloudflare Pages project.
  ///
  /// Cloudflare Pagesプロジェクトのカスタムドメイン。
  const CloudflarePagesDomain({
    required this.name,
    required this.status,
    this.message = "",
  });

  /// Creates an instance from the API response object.
  ///
  /// APIの応答オブジェクトから作成します。
  factory CloudflarePagesDomain.fromJson(Map json) {
    String nested(String key, String field) {
      final value = json[key];
      return value is Map ? (value[field]?.toString() ?? "") : "";
    }

    return CloudflarePagesDomain(
      name: (json["name"]?.toString() ?? "").toLowerCase(),
      status: json["status"]?.toString() ?? "",
      message: [
        nested("verification_data", "error_message"),
        nested("validation_data", "error_message"),
      ].where((e) => e.isNotEmpty).join(" "),
    );
  }

  /// Domain name.
  ///
  /// ドメイン名。
  final String name;

  /// Domain status such as `active`, `pending` or `initializing`.
  ///
  /// `active`、`pending`、`initializing`などのドメインの状態。
  final String status;

  /// Verification or validation error message (e.g. `CNAME record not set`).
  ///
  /// 検証エラーメッセージ（例：`CNAME record not set`）。
  final String message;

  /// Whether the domain still waits for its DNS record.
  ///
  /// ドメインがDNSレコードを待っている状態かどうか。
  bool get needsDnsRecord =>
      status != "active" &&
      (status == "pending" ||
          status == "initializing" ||
          message.toLowerCase().contains("cname"));
}

/// Cloudflare zone.
///
/// Cloudflareのゾーン。
class CloudflareZone {
  /// Cloudflare zone.
  ///
  /// Cloudflareのゾーン。
  const CloudflareZone({required this.name, required this.accountId});

  /// Creates an instance from the API response object.
  ///
  /// APIの応答オブジェクトから作成します。
  factory CloudflareZone.fromJson(Map json) {
    final account = json["account"];
    return CloudflareZone(
      name: (json["name"]?.toString() ?? "").toLowerCase(),
      accountId: account is Map ? (account["id"]?.toString() ?? "") : "",
    );
  }

  /// Zone name (e.g. `example.com`).
  ///
  /// ゾーン名（例：`example.com`）。
  final String name;

  /// ID of the account that owns the zone.
  ///
  /// ゾーンを所有するアカウントのID。
  final String accountId;

  /// Whether [host] belongs to this zone.
  ///
  /// [host]がこのゾーンに属するかどうか。
  bool contains(String host) => host == name || host.endsWith(".$name");
}

/// Cloudflare DNS record.
///
/// CloudflareのDNSレコード。
class CloudflareDnsRecord {
  /// Cloudflare DNS record.
  ///
  /// CloudflareのDNSレコード。
  const CloudflareDnsRecord({required this.type, required this.content});

  /// Creates an instance from the API response object.
  ///
  /// APIの応答オブジェクトから作成します。
  factory CloudflareDnsRecord.fromJson(Map json) {
    return CloudflareDnsRecord(
      type: json["type"]?.toString() ?? "",
      content: (json["content"]?.toString() ?? "").toLowerCase(),
    );
  }

  /// Record type such as `CNAME`.
  ///
  /// `CNAME`などのレコード種別。
  final String type;

  /// Record content.
  ///
  /// レコードの内容。
  final String content;
}

/// Exception thrown when the Cloudflare API returns an error.
///
/// Cloudflare APIがエラーを返した場合の例外。
class CloudflareApiException implements Exception {
  /// Exception thrown when the Cloudflare API returns an error.
  ///
  /// Cloudflare APIがエラーを返した場合の例外。
  const CloudflareApiException({
    required this.statusCode,
    required this.body,
    required this.operation,
  });

  /// HTTP status code.
  ///
  /// HTTPステータスコード。
  final int statusCode;

  /// Response body.
  ///
  /// レスポンスボディ。
  final String body;

  /// Operation that failed.
  ///
  /// 失敗した操作。
  final String operation;

  /// Whether the token lacks permission (HTTP 401 / 403).
  ///
  /// トークンの権限が不足しているかどうか（HTTP 401 / 403）。
  bool get isPermissionError =>
      statusCode == HttpStatus.unauthorized ||
      statusCode == HttpStatus.forbidden;

  @override
  String toString() =>
      "CloudflareApiException: Failed to $operation (HTTP $statusCode): $body";
}
