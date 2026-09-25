// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Default endpoint of the Turso Platform API.
///
/// Turso Platform APIの既定のエンドポイント。
const tursoPlatformApiDefaultBaseUrl = "https://api.turso.tech";

/// Minimal client of the Turso Platform API used by `katana apply`.
///
/// `katana apply`で使用するTurso Platform APIの最小限のクライアント。
class TursoPlatformApi {
  /// Minimal client of the Turso Platform API used by `katana apply`.
  ///
  /// [baseUrl] can be replaced (e.g. with a loopback server in tests).
  ///
  /// `katana apply`で使用するTurso Platform APIの最小限のクライアント。
  ///
  /// [baseUrl]は差し替え可能です（テストでのループバックサーバーなど）。
  TursoPlatformApi({
    required this.token,
    Uri? baseUrl,
    HttpClient? client,
  })  : baseUrl = baseUrl ?? Uri.parse(tursoPlatformApiDefaultBaseUrl),
        _client = client ?? HttpClient();

  /// Platform API token (Bearer).
  ///
  /// Platform APIトークン（Bearer）。
  final String token;

  /// API endpoint. Tests may use an in-process endpoint.
  ///
  /// APIのエンドポイント。テストではプロセス内のエンドポイントを使用できます。
  final Uri baseUrl;

  final HttpClient _client;

  /// Lists the groups of [organization].
  ///
  /// `GET /v1/organizations/{organization}/groups`
  ///
  /// [organization]のグループ一覧を取得します。
  Future<List<TursoGroupInfo>> listGroups(String organization) async {
    final response = await _request("GET", _groupsPath(organization));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TursoPlatformApiException(
        statusCode: response.statusCode,
        body: response.body,
        operation: "list groups",
      );
    }
    final decoded = jsonDecode(response.body);
    final groups = decoded is Map ? decoded["groups"] : null;
    if (groups is! List) {
      throw const FormatException(
          "Unexpected response format of the Turso groups API.");
    }
    return groups.whereType<Map>().map(TursoGroupInfo.fromJson).toList();
  }

  /// Creates the group [name] whose primary location is [location] in [organization].
  ///
  /// Returns false if the group already exists (HTTP 409), otherwise true.
  ///
  /// `POST /v1/organizations/{organization}/groups`
  ///
  /// [organization]にプライマリロケーションが[location]のグループ[name]を作成します。
  ///
  /// グループが既に存在する場合（HTTP 409）はfalse、それ以外はtrueを返します。
  Future<bool> createGroup(
    String organization, {
    required String name,
    required String location,
  }) async {
    final response = await _request(
      "POST",
      _groupsPath(organization),
      {"name": name, "location": location},
    );
    if (response.statusCode == HttpStatus.conflict) {
      return false;
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TursoPlatformApiException(
        statusCode: response.statusCode,
        body: response.body,
        operation: "create group `$name` ($location)",
      );
    }
    return true;
  }

  /// Closes the underlying HTTP client.
  ///
  /// 内部のHTTPクライアントを閉じます。
  void close() {
    _client.close(force: true);
  }

  String _groupsPath(String organization) =>
      "/v1/organizations/${Uri.encodeComponent(organization)}/groups";

  Future<_TursoResponse> _request(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final request = await _client.openUrl(method, baseUrl.resolve(path));
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    final content = await utf8.decoder.bind(response).join();
    return _TursoResponse(response.statusCode, content);
  }
}

/// Group information returned by the Turso Platform API.
///
/// Turso Platform APIが返すグループ情報。
class TursoGroupInfo {
  /// Group information returned by the Turso Platform API.
  ///
  /// Turso Platform APIが返すグループ情報。
  const TursoGroupInfo({
    required this.name,
    this.primary,
    this.locations = const [],
  });

  /// Creates an instance from the API response object.
  ///
  /// APIの応答オブジェクトから作成します。
  factory TursoGroupInfo.fromJson(Map<dynamic, dynamic> json) {
    final locations = json["locations"];
    return TursoGroupInfo(
      name: json["name"]?.toString() ?? "",
      primary: json["primary"]?.toString(),
      locations: locations is List
          ? locations.map((e) => e.toString()).toList()
          : const [],
    );
  }

  /// Group name.
  ///
  /// グループ名。
  final String name;

  /// Primary location code (e.g. `aws-ap-northeast-1`).
  ///
  /// プライマリロケーションのコード（例：`aws-ap-northeast-1`）。
  final String? primary;

  /// Location codes of the group.
  ///
  /// グループのロケーションコード一覧。
  final List<String> locations;
}

/// Error response of the Turso Platform API.
///
/// Turso Platform APIのエラー応答。
class TursoPlatformApiException implements Exception {
  /// Error response of the Turso Platform API.
  ///
  /// Turso Platform APIのエラー応答。
  const TursoPlatformApiException({
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
  /// レスポンス本文。
  final String body;

  /// Description of the failed operation.
  ///
  /// 失敗した操作の説明。
  final String operation;

  /// Whether the token was rejected (HTTP 401/403).
  ///
  /// トークンが拒否された（HTTP 401/403）かどうか。
  bool get isUnauthorized =>
      statusCode == HttpStatus.unauthorized ||
      statusCode == HttpStatus.forbidden;

  @override
  String toString() =>
      "Turso Platform API failed to $operation: HTTP $statusCode $body";
}

/// Creates Turso groups that have a `location` in [groups] but do not exist in [organization].
///
/// Existing groups are left untouched; a warning is shown when the primary location differs.
/// HTTP 409 is treated as success. HTTP 401/403 and other failures throw [StateError].
/// Returns the names of the created groups.
///
/// [groups]のうち`location`を持ち、[organization]に存在しないTursoグループだけを作成します。
///
/// 既存グループは変更せず、プライマリロケーションが異なる場合は警告のみ表示します。
/// HTTP 409は成功扱いです。HTTP 401/403とその他の失敗は[StateError]を投げます。
/// 作成したグループ名を返します。
Future<List<String>> ensureTursoGroups({
  required TursoPlatformApi api,
  required String organization,
  required List<Map<String, dynamic>> groups,
}) async {
  final targets = groups
      .where((group) => (group["location"] as String?)?.isNotEmpty ?? false)
      .toList();
  if (targets.isEmpty) {
    return const [];
  }
  const tokenHint =
      "An organization-wide Turso Platform API token is required to create groups. "
      "Create a token without specifying a Group and set it to [cloudflare]->[turso]->[platform_api_token]. "
      "groupを作成するにはorganization全体のTurso Platform API tokenが必要です。 "
      "Groupを指定せずにトークンを作成し、[cloudflare]->[turso]->[platform_api_token]に設定してください。";
  const planHint = "Multiple groups require the Turso Scaler plan or higher. "
      "複数groupの利用にはTursoのScaler以上のプランが必要です。";
  List<TursoGroupInfo> existing;
  try {
    existing = await api.listGroups(organization);
  } on TursoPlatformApiException catch (e) {
    if (e.isUnauthorized) {
      throw StateError("$e\n$tokenHint");
    }
    throw StateError(e.toString());
  }
  final existingByName = {for (final group in existing) group.name: group};
  final created = <String>[];
  for (final group in targets) {
    final name = group["name"] as String;
    final location = group["location"] as String;
    final current = existingByName[name];
    if (current != null) {
      if (current.primary != null && current.primary != location) {
        label(
          "Warning: Turso group `$name` already exists with primary location `${current.primary}` "
          "(katana.yaml: `$location`). Katana does not modify existing groups. "
          "既存のTurso group `$name` のprimary location（${current.primary}）がkatana.yaml（$location）と異なります。既存groupは変更しません。",
        );
      }
      continue;
    }
    label("Create Turso group: $name ($location)");
    try {
      if (await api.createGroup(organization, name: name, location: location)) {
        created.add(name);
      }
    } on TursoPlatformApiException catch (e) {
      if (e.isUnauthorized) {
        throw StateError("$e\n$tokenHint");
      }
      throw StateError("$e\n$planHint");
    }
  }
  return created;
}

class _TursoResponse {
  const _TursoResponse(this.statusCode, this.body);

  final int statusCode;

  final String body;
}
