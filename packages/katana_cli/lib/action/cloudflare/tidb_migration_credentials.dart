import "dart:convert";
import "dart:io";
import "dart:math";

import "package:yaml/yaml.dart";

/// The SQL identity used only by local migration and runtime-user provisioning.
class TidbMigrationCredentials {
  /// Keeps the resolved username, password and preserved state together.
  const TidbMigrationCredentials(this.username, this.password, this.state);

  /// SQL username.
  final String username;

  /// SQL password. Never print this value.
  final String password;

  /// Existing and newly written TiDB state.
  final Map<String, dynamic> state;
}

/// Injectable SQL identity and privilege probe.
typedef TidbSqlProbe = Future<void> Function(String host, String database,
    String username, String password, String node);

/// Administrative API transport. It never exposes an API key to the child argv.
class TidbCloudSqlUserApi {
  /// Creates an authenticated TiDB Cloud IAM client.
  TidbCloudSqlUserApi(this.publicKey, this.privateKey,
      {Uri? baseUrl, Uri? clusterBaseUrl, HttpClient? client})
      : baseUrl = baseUrl ?? Uri.parse("https://iam.tidbapi.com"),
        clusterBaseUrl = clusterBaseUrl ??
            baseUrl ??
            Uri.parse("https://serverless.tidbapi.com"),
        _bearerToken = null,
        _client = client ?? HttpClient() {
    _client.authenticate = (url, scheme, realm) async {
      if (scheme.toLowerCase() != "digest") {
        return false;
      }
      _client.addCredentials(
          url, realm ?? "", HttpClientDigestCredentials(publicKey, privateKey));
      return true;
    };
  }

  TidbCloudSqlUserApi._oauth(this._bearerToken,
      {Uri? baseUrl, Uri? clusterBaseUrl, HttpClient? client})
      : publicKey = "",
        privateKey = "",
        baseUrl = baseUrl ?? Uri.parse("https://iam.tidbapi.com"),
        clusterBaseUrl = clusterBaseUrl ??
            baseUrl ??
            Uri.parse("https://serverless.tidbapi.com"),
        _client = client ?? HttpClient();

  /// Uses an existing ticloud OAuth profile without exporting the token.
  static Future<TidbCloudSqlUserApi> fromTicloudProfile(String profile) async {
    if (!Platform.isMacOS) {
      throw StateError(
          "TiDB OAuth Keychain連携はmacOSのみ対応しています。管理APIキーを使用してください。");
    }
    if (!RegExp(r"^[A-Za-z0-9_-]+$").hasMatch(profile)) {
      throw StateError("TiDB OAuth profile名が不正です。");
    }
    final keychain = await Process.run("/usr/bin/security", [
      "find-generic-password",
      "-s",
      "ticloud_access_token",
      "-a",
      profile,
      "-w",
    ]);
    if (keychain.exitCode != 0) {
      throw StateError(
          "ticloud OAuth profileをKeychainから取得できません。ticloud auth loginを確認してください。");
    }
    var token = (keychain.stdout as String).trim();
    const base64Prefix = "go-keyring-base64:";
    const hexPrefix = "go-keyring-encoded:";
    try {
      if (token.startsWith(base64Prefix)) {
        token =
            utf8.decode(base64.decode(token.substring(base64Prefix.length)));
      } else if (token.startsWith(hexPrefix)) {
        final encoded = token.substring(hexPrefix.length);
        if (encoded.length.isOdd ||
            !RegExp(r"^[0-9a-fA-F]+$").hasMatch(encoded)) {
          throw const FormatException("invalid keychain encoding");
        }
        token = utf8.decode(List<int>.generate(
            encoded.length ~/ 2,
            (index) => int.parse(encoded.substring(index * 2, index * 2 + 2),
                radix: 16)));
      }
    } catch (_) {
      throw StateError("ticloud OAuth profileのKeychain形式が不正です。");
    }
    if (token.isEmpty || token.contains(RegExp(r"[\r\n]"))) {
      throw StateError("ticloud OAuth tokenの形式が不正です。");
    }
    return TidbCloudSqlUserApi._oauth(token);
  }

  /// TiDB Cloud management API public key.
  final String publicKey;

  /// TiDB Cloud management API private key.
  final String privateKey;

  /// API endpoint. Tests may use an in-process endpoint.
  final Uri baseUrl;

  /// Cluster metadata endpoint used to obtain the authoritative SQL prefix.
  final Uri clusterBaseUrl;
  final String? _bearerToken;
  final HttpClient _client;

  Future<Map<String, dynamic>> _request(String method, String path,
      [Map<String, dynamic>? body, Uri? endpoint]) async {
    final url = (endpoint ?? baseUrl).resolve(path);
    final request = await _client.openUrl(method, url);
    request.headers.contentType = ContentType.json;
    if (_bearerToken != null) {
      request.headers
          .set(HttpHeaders.authorizationHeader, "Bearer $_bearerToken");
    }
    if (body != null) {
      request.write(jsonEncode(body));
    }
    final response = await request.close();
    final content = await utf8.decoder.bind(response).join();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      var code = "unknown";
      var invalidField = "unavailable";
      final rawRequestId = response.headers.value("x-request-id") ??
          response.headers.value("x-tidb-request-id") ??
          "";
      final requestId = RegExp(r"^[A-Za-z0-9_-]{1,128}$").hasMatch(rawRequestId)
          ? rawRequestId
          : "unavailable";
      try {
        final error = jsonDecode(content);
        if (error is Map &&
            error["code"] is String &&
            RegExp(r"^[A-Za-z0-9_]+$").hasMatch(error["code"] as String)) {
          code = error["code"] as String;
        }
        if (error is Map && error["message"] is String) {
          final message = (error["message"] as String).toLowerCase();
          for (final field in <String>[
            "password",
            "username",
            "authmethod",
            "autoprefix",
            "builtinrole",
            "customroles",
          ]) {
            if (message.contains(field)) {
              invalidField = field;
              break;
            }
          }
        }
      } catch (_) {
        // API responses may contain echoed input; only the error code is safe.
      }
      throw StateError(
          "TiDB Cloud APIがHTTP ${response.statusCode} ($code, field=$invalidField, request_id=$requestId)を返しました。管理API権限と対象clusterを確認してください。");
    }
    final value = jsonDecode(content);
    if (value is! Map) {
      throw const FormatException("TiDB Cloud SQL Users APIの応答形式が不正です。");
    }
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  /// Reads the prefix from the target cluster, independent of SQL-user listing.
  Future<String> clusterPrefix(String cluster) async {
    final result = await _request(
        "GET",
        "/v1beta1/clusters/${Uri.encodeComponent(cluster)}",
        null,
        clusterBaseUrl);
    if ((result["clusterId"] ?? "").toString() != cluster) {
      throw StateError("TiDB Cloud cluster metadataのIDが一致しません。");
    }
    final prefix = (result["userPrefix"] ?? "").toString();
    if (prefix.isEmpty) {
      throw StateError("TiDB Cloud cluster metadataにSQL user prefixがありません。");
    }
    return prefix;
  }

  /// Lists every SQL user on the selected cluster.
  Future<List<Map<String, dynamic>>> list(String cluster) async {
    final users = <Map<String, dynamic>>[];
    var token = "";
    do {
      final query = token.isEmpty
          ? "?pageSize=100"
          : "?pageSize=100&pageToken=${Uri.encodeQueryComponent(token)}";
      final result = await _request("GET",
          "/v1beta1/clusters/${Uri.encodeComponent(cluster)}/sqlUsers$query");
      final payload = result["data"] is Map ? result["data"] as Map : result;
      final page = payload["sqlUsers"] ?? payload["sql_users"] ?? <Object>[];
      if (page is! List) {
        throw const FormatException("TiDB Cloud SQL Users一覧の形式が不正です。");
      }
      for (final user in page) {
        if (user is! Map) {
          throw const FormatException("TiDB Cloud SQL Userの形式が不正です。");
        }
        users.add(user.map((key, value) => MapEntry(key.toString(), value)));
      }
      token = (payload["nextPageToken"] ?? payload["next_page_token"] ?? "")
          .toString();
    } while (token.isNotEmpty);
    return users;
  }

  /// Creates one administrator SQL user without passing secrets in argv.
  Future<String> create(
      String cluster, String shortName, String password) async {
    final result = await _request(
        "POST", "/v1beta1/clusters/${Uri.encodeComponent(cluster)}/sqlUsers", {
      "userName": shortName,
      "password": password,
      "authMethod": "mysql_native_password",
      "autoPrefix": true,
      "builtinRole": "role_admin",
    });
    final username =
        (result["userName"] ?? result["username"] ?? "").toString();
    if (username.isEmpty) {
      throw const FormatException("TiDB Cloud SQL User作成応答にuserNameがありません。");
    }
    return username;
  }

  /// Closes the HTTP client.
  void close() => _client.close();
}

Map<String, dynamic> _plainMap(Map value) => value.map((key, item) =>
    MapEntry(key.toString(), item is Map ? _plainMap(item) : item));

/// Reads the local state without printing credential values.
Future<Map<String, dynamic>> loadTidbCredentialState() async {
  final file = File("cloudflare/tidb.yaml");
  if (!await file.exists()) {
    return <String, dynamic>{};
  }
  final value = loadYaml(await file.readAsString());
  if (value is! Map) {
    throw const FormatException("cloudflare/tidb.yamlの形式が不正です。");
  }
  return _plainMap(value);
}

/// Writes before provisioning, so a failed final save cannot lose the password.
Future<void> saveTidbCredentialState(Map<String, dynamic> state) async {
  final directory = Directory("cloudflare");
  await directory.create(recursive: true);
  final temporaryDirectory = await directory.createTemp(".tidb-credentials-");
  final temporary = File("${temporaryDirectory.path}/tidb.yaml");
  try {
    final protectDirectory =
        await Process.run("chmod", ["700", temporaryDirectory.path]);
    if (protectDirectory.exitCode != 0) {
      throw StateError("TiDB資格情報一時領域を保護できません。");
    }
    await temporary.writeAsString(
        "${const JsonEncoder.withIndent("  ").convert(state)}\n",
        mode: FileMode.writeOnly);
    final protectFile = await Process.run("chmod", ["600", temporary.path]);
    if (protectFile.exitCode != 0) {
      throw StateError("TiDB資格情報ファイルを保護できません。");
    }
    await temporary.rename("cloudflare/tidb.yaml");
  } finally {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  }
}

Map<String, dynamic> _migrationUsers(Map<String, dynamic> state) {
  final cloudflare = state.putIfAbsent("cloudflare", () => <String, dynamic>{})
      as Map<String, dynamic>;
  final tidb = cloudflare.putIfAbsent("tidb", () => <String, dynamic>{})
      as Map<String, dynamic>;
  return tidb.putIfAbsent("migration_users", () => <String, dynamic>{})
      as Map<String, dynamic>;
}

String _name(Map<String, dynamic> user) =>
    (user["userName"] ?? user["username"] ?? "").toString();

String _randomPassword() {
  const alphabet =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  final random = Random.secure();
  while (true) {
    final password = String.fromCharCodes(List<int>.generate(
        32, (_) => alphabet.codeUnitAt(random.nextInt(alphabet.length))));
    if (RegExp(r"[a-z]").hasMatch(password) &&
        RegExp(r"[A-Z]").hasMatch(password) &&
        RegExp(r"[0-9]").hasMatch(password)) {
      return password;
    }
  }
}

/// Resolve legacy credentials first, then provision a dedicated user once.
/// Existing users with the intended name are never adopted without a saved
/// pending credential that proves this process created them.
Future<TidbMigrationCredentials> resolveTidbMigrationCredentials({
  required String environment,
  required String cluster,
  required String host,
  required String database,
  required String node,
  required Map<String, dynamic> legacySecrets,
  required String publicKey,
  required String privateKey,
  String authMode = "api_key",
  String oauthProfile = "default",
  bool allowProvision = true,
  TidbCloudSqlUserApi? api,
  TidbSqlProbe? probe,
  Future<void> Function(Map<String, dynamic>)? save,
}) async {
  if (environment != "dev" && environment != "prod") {
    throw StateError("TiDB migrationにはdev/prodを明示してください。");
  }
  if (cluster.isEmpty || host.isEmpty || database.isEmpty) {
    throw StateError("TiDB migrationのcluster/host/databaseが不足しています。");
  }
  final state = await loadTidbCredentialState();
  final entries = _migrationUsers(state);
  final stored = entries[environment] is Map
      ? Map<String, dynamic>.from(entries[environment] as Map)
      : <String, dynamic>{};
  final check = probe ?? verifyTidbMigrationSqlUser;
  final persist = save ?? saveTidbCredentialState;
  final storedUser = (stored["username"] ?? "").toString();
  var storedPassword = (stored["password"] ?? "").toString();
  if (stored.isNotEmpty) {
    if (stored["owner"] != "katana-cloudflare-tidb-migration-v1" ||
        stored["cluster_id"] != cluster ||
        storedUser.isEmpty ||
        storedPassword.isEmpty) {
      throw StateError("保存済みTiDB migration資格情報の所有者またはclusterが一致しません。");
    }
    if (stored["status"] == "pending") {
      if (!allowProvision) {
        throw StateError("TiDB migration資格情報の初期作成はkatana applyで完了してください。");
      }
      if (authMode == "api_key" && (publicKey.isEmpty || privateKey.isEmpty)) {
        throw StateError("TiDB Cloud管理API資格情報がありません。");
      }
      final client = api ??
          await _openSqlUserApi(authMode, oauthProfile, publicKey, privateKey);
      try {
        var verified = false;
        try {
          await check(host, database, storedUser, storedPassword, node);
          verified = true;
        } catch (_) {
          // A pending record can precede API creation. A second POST is
          // create-only and must stop on conflict without changing the user.
        }
        if (!verified) {
          final existingUsers = await client.list(cluster);
          if (existingUsers.any((user) => _name(user) == storedUser)) {
            throw StateError(
                "TiDB migration userは存在しますがSQL検証に失敗しました。既存userを変更せず停止します。");
          }
          var shortName = (stored["requested_name"] ?? "").toString();
          // The first generated name exceeded TiDB's 32-character limit on
          // prefixed Serverless users. That API request was rejected before
          // user creation, so preserve the password while shortening only
          // this known pending name.
          if (shortName == "masamune_${environment}_migration" &&
              storedUser.length > 32) {
            final prefix = await client.clusterPrefix(cluster);
            if (storedUser != "$prefix.$shortName") {
              throw StateError("TiDB migration userのcluster prefixが一致しません。");
            }
            shortName = "migrate_$environment";
            stored["requested_name"] = shortName;
            stored["username"] = "$prefix.$shortName";
            entries[environment] = stored;
            await persist(state);
          }
          final requestedUser = (stored["username"] ?? "").toString();
          if (shortName.isEmpty || !requestedUser.endsWith(".$shortName")) {
            throw StateError("TiDB migration userの作成待ち記録が不正です。");
          }
          final prefix = await client.clusterPrefix(cluster);
          if (requestedUser != "$prefix.$shortName" ||
              requestedUser.length > 32) {
            throw StateError("TiDB migration userのcluster prefixが一致しません。");
          }
          if (existingUsers.any((user) => _name(user) == requestedUser)) {
            throw StateError("同名のTiDB migration userがあります。既存userを変更せず停止します。");
          }
          if (RegExp(r"^[A-Za-z0-9_-]{43}$").hasMatch(storedPassword)) {
            storedPassword = _randomPassword();
            stored["password"] = storedPassword;
            entries[environment] = stored;
            await persist(state);
          }
          final created =
              await client.create(cluster, shortName, storedPassword);
          if (created != requestedUser) {
            throw StateError("TiDB Cloudが想定外のSQL user名を返しました。");
          }
          await check(host, database, requestedUser, storedPassword, node);
        }
      } finally {
        if (api == null) {
          client.close();
        }
      }
      stored["status"] = "active";
      entries[environment] = stored;
      await persist(state);
    } else if (stored["status"] == "active") {
      await check(host, database, storedUser, storedPassword, node);
    } else {
      throw StateError("TiDB migration資格情報の状態が不正です。");
    }
    return TidbMigrationCredentials(
        (stored["username"] ?? "").toString(), storedPassword, state);
  }

  final legacyUser = (legacySecrets["migration_username"] ?? "").toString();
  final legacyPassword = (legacySecrets["migration_password"] ?? "").toString();
  if (legacyUser.isNotEmpty || legacyPassword.isNotEmpty) {
    if (legacyUser.isEmpty || legacyPassword.isEmpty) {
      throw StateError("既存migration資格情報が不完全です。");
    }
    await check(host, database, legacyUser, legacyPassword, node);
    entries[environment] = {
      "username": legacyUser,
      "password": legacyPassword,
      "cluster_id": cluster,
      "owner": "katana-cloudflare-tidb-migration-v1",
      "status": "active",
    };
    await persist(state);
    return TidbMigrationCredentials(legacyUser, legacyPassword, state);
  }

  if (authMode == "api_key" && (publicKey.isEmpty || privateKey.isEmpty)) {
    throw StateError("TiDB Cloud管理API資格情報がありません。");
  }
  if (!allowProvision) {
    throw StateError("TiDB migration資格情報の初期作成はkatana applyで完了してください。");
  }
  final client = api ??
      await _openSqlUserApi(authMode, oauthProfile, publicKey, privateKey);
  try {
    final prefix = await client.clusterPrefix(cluster);
    final users = await client.list(cluster);
    final shortName = "migrate_$environment";
    final username = "$prefix.$shortName";
    if (username.length > 32) {
      throw StateError("TiDB migration user名が32文字を超えています。");
    }
    if (users.any((user) => _name(user) == username)) {
      throw StateError("同名の未管理TiDB migration userがあります。既存アカウントを確認してください。");
    }
    final password = _randomPassword();
    entries[environment] = {
      "username": username,
      "password": password,
      "cluster_id": cluster,
      "requested_name": shortName,
      "owner": "katana-cloudflare-tidb-migration-v1",
      "status": "pending",
    };
    await persist(state);
    final created = await client.create(cluster, shortName, password);
    if (created != username) {
      throw StateError("TiDB Cloudが想定外のSQL user名を返しました。既存記録を保護して停止します。");
    }
    await check(host, database, username, password, node);
    (entries[environment] as Map<String, dynamic>)["status"] = "active";
    await persist(state);
    return TidbMigrationCredentials(username, password, state);
  } finally {
    if (api == null) {
      client.close();
    }
  }
}

Future<TidbCloudSqlUserApi> _openSqlUserApi(String authMode,
    String oauthProfile, String publicKey, String privateKey) async {
  switch (authMode) {
    case "api_key":
      return TidbCloudSqlUserApi(publicKey, privateKey);
    case "ticloud_oauth":
      return TidbCloudSqlUserApi.fromTicloudProfile(oauthProfile);
    default:
      throw StateError("TiDB SQL user管理認証方式が不正です。");
  }
}

/// Checks the actual SQL identity and administrative role over HTTPS SQL.
Future<void> verifyTidbMigrationSqlUser(String host, String database,
    String username, String password, String node) async {
  const script = r"""
const {connect}=require('@tidbcloud/serverless');
let input=''; process.stdin.setEncoding('utf8');
process.stdin.on('data', part => input += part);
process.stdin.on('end', async () => {
  try {
    const p=JSON.parse(input);
    const db=connect({host:p.host,database:p.database,username:p.username,password:p.password,debug:false});
    const rows=await db.execute('SELECT CURRENT_USER() AS identity_name');
    const actual=String(rows[0]?.identity_name ?? '').split('@')[0];
    if(actual!==p.username) throw new Error('identity');
    const grants=await db.execute('SHOW GRANTS');
    const text=grants.map(row=>String(Object.values(row)[0] ?? '')).join(' ').toLowerCase();
    if(!text.includes('role_admin') && !text.includes('all privileges')) throw new Error('privileges');
    process.stdout.write('verified');
  } catch { process.stderr.write('TiDB migration SQL identityまたは管理権限を確認できません。'); process.exitCode=1; }
});
""";
  final process =
      await Process.start(node, ["-e", script], workingDirectory: "cloudflare");
  final output = process.stdout.transform(utf8.decoder).join();
  final failure = process.stderr.transform(utf8.decoder).join();
  process.stdin.write(jsonEncode({
    "host": host,
    "database": database,
    "username": username,
    "password": password,
  }));
  await process.stdin.close();
  final status = await process.exitCode;
  await output;
  await failure;
  if (status != 0) {
    throw StateError("TiDB migration SQL identityまたは管理権限を確認できません。");
  }
}
