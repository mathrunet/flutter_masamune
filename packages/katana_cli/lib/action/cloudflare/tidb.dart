// Dart imports:
import "dart:convert";
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/cloudflare/tidb_data_service_api.dart";
import "package:katana_cli/action/cloudflare/tidb_state.dart";
import "package:katana_cli/katana_cli.dart";

const _managedEndpointTags = {"Masamune", "MasamuneServer"};

/// Splits generated additive schema into independently deployable table jobs.
List<String> splitTidbAdditiveSchemaMigrations(String source) {
  final marker = RegExp(
    r"CREATE DATABASE IF NOT EXISTS `([A-Za-z0-9_]+)`;\s*"
    r"USE `\1`;\s*",
  );
  final matches = marker.allMatches(source).toList();
  return [
    for (var index = 0; index < matches.length; index++)
      "CREATE DATABASE IF NOT EXISTS `${matches[index].group(1)}`;\n"
          "USE `${matches[index].group(1)}`;\n"
          "${source.substring(
                matches[index].end,
                index + 1 < matches.length
                    ? matches[index + 1].start
                    : source.length,
              ).trim()}",
  ];
}

/// Returns whether every generated endpoint has a matching remote method/path.
///
/// The local ownership file is only a record of a previous successful apply;
/// it cannot prove that the endpoint still exists in TiDB Cloud.
bool tidbGeneratedEndpointSetIsComplete(
  Iterable<Object?> generated,
  Iterable<Map<String, dynamic>> remote,
) {
  final remoteKeys = remote
      .map(
        (item) => "${item["method"]?.toString().toUpperCase()}:${item["path"]}",
      )
      .toSet();
  return generated.every((raw) {
    final item = raw is Map
        ? raw.map((key, value) => MapEntry(key.toString(), value))
        : const <String, dynamic>{};
    final method = item["method"]?.toString().toUpperCase() ?? "";
    final path = item["endpoint"]?.toString() ?? "";
    return method.isNotEmpty &&
        path.isNotEmpty &&
        remoteKeys.contains("$method:$path");
  });
}

/// Cloudflare deployment process for TiDB.
///
/// Cloudflare用のTiDBのデプロイ処理を行います。
class CloudflareTidbCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for TiDB.
  ///
  /// Cloudflare用のTiDBのデプロイ処理を行います。
  const CloudflareTidbCliAction();

  @override
  String get description =>
      "Configure TiDB Data Service for Cloudflare Workers. Cloudflare Workers向けのTiDB Data Serviceを構成します。";

  @override
  bool checkEnabled(ExecContext context) {
    return context.yaml
        .getAsMap("cloudflare")
        .getAsMap("tidb")
        .get("enable", false);
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final tidb = context.yaml.getAsMap("cloudflare").getAsMap("tidb");
    final mode = tidb.get("mode", "data_service").toString();
    if (mode != "data_service" && mode != "data-service") {
      error(
        "TiDB direct mode is no longer supported. Configure `project_id` "
        "and `cluster_id` for TiDB Data Service.",
      );
      return;
    }
    if (!_validateCloudflareFiles()) {
      return;
    }
    try {
      await ensureTidbManagedStateIsGitIgnored();
    } on StateError catch (exception) {
      error(exception.message.toString());
      return;
    }
    final secrets = await _loadSecretsRoot();
    late final TidbManagedStateLoadResult managed;
    try {
      managed = await loadAndMigrateTidbManagedState(
        secrets,
        environment: flavor,
      );
    } on StateError catch (exception) {
      error(exception.message.toString());
      return;
    }
    if (managed.stateChanged) {
      await saveTidbManagedState(managed.state, environment: flavor);
    }
    if (managed.secretsChanged) {
      await _saveSecretsRoot(secrets);
    }
    await _applyDataService(
      tidb,
      npm: npm,
      wrangler: wrangler,
      environment: flavor,
      secrets: secrets,
      managedState: managed.state,
    );
  }

  bool _validateCloudflareFiles() {
    if (!Directory("cloudflare").existsSync()) {
      error(
        "The directory `cloudflare` does not exist. Enable Cloudflare Workers and execute `katana apply` first.",
      );
      return false;
    }
    if (!File("cloudflare/src/index.ts").existsSync()) {
      error("The file `cloudflare/src/index.ts` does not exist.");
      return false;
    }
    return true;
  }

  Future<void> _applyDataService(
    Map tidb, {
    required String npm,
    required String wrangler,
    required String environment,
    required Map<String, dynamic> secrets,
    required Map<String, dynamic> managedState,
  }) async {
    final legacy = tidb["data_service"] is Map
        ? Map<String, dynamic>.from(tidb["data_service"] as Map)
        : <String, dynamic>{};
    final config = <String, dynamic>{
      ...legacy,
      ...Map<String, dynamic>.from(tidb),
    }..remove("data_service");
    final directory = config["directory"]?.toString() ?? "tidb/data_service";
    final manifestFile = File("$directory/__generated_manifest.json");
    if (!manifestFile.existsSync()) {
      error(
        "`$directory/__generated_manifest.json` was not found. "
        "Add `@tidbDataService` to models and run `katana code generate`.",
      );
      return;
    }
    final manifestText = await manifestFile.readAsString();
    final manifest = _decodeMap(manifestText, manifestFile.path);
    final manifestHash = _stableHash(manifestText);
    final projectId = config["project_id"]?.toString().trim() ?? "";
    final clusterId = config["cluster_id"]?.toString().trim() ?? "";
    final configuredAppName = config["app_name"]?.toString().trim() ?? "";
    final appName = configuredAppName.isNotEmpty
        ? configuredAppName
        : environment == "prod"
            ? "masamune"
            : "masamune-$environment";
    final rateLimit =
        int.tryParse(config["rate_limit_rpm"]?.toString() ?? "") ?? 1000;
    final maxScanRows =
        int.tryParse(config["max_scan_rows"]?.toString() ?? "") ?? 1000;
    final restrictMysql = config["restrict_mysql"] != false;
    if (projectId.isEmpty || clusterId.isEmpty || appName.isEmpty) {
      error(
        "Data Service mode requires project_id, cluster_id, and app_name.",
      );
      return;
    }
    if (rateLimit < 1 || rateLimit > 1000) {
      error("rate_limit_rpm must be between 1 and 1000.");
      return;
    }
    if (maxScanRows < 1 || maxScanRows > 1999) {
      error("max_scan_rows must be between 1 and 1999.");
      return;
    }

    final secretTidb = _nested(secrets, ["cloudflare", "tidb"]);
    final management = _nested(secretTidb, ["management_api"]);
    final dataService = _nested(managedState, ["data_service"]);
    final cutover = _nested(managedState, ["cutover"]);
    final managedAppId = dataService["app_id"]?.toString().trim() ?? "";
    if (managedAppId.isNotEmpty) {
      await _writeDataAppConfig(
        directory: directory,
        appId: managedAppId,
        appName: appName,
        clusterId: clusterId,
      );
    }
    final managementPublic = management["public_key"]?.toString() ?? "";
    final managementPrivate = management["private_key"]?.toString() ?? "";
    if (managementPublic.isEmpty || managementPrivate.isEmpty) {
      error(
        "Data Service mode requires "
        "`cloudflare.tidb.management_api.public_key/private_key` "
        "in katana_secrets.yaml.",
      );
      return;
    }

    final previousHash = cutover["manifest_hash"]?.toString();
    final state = cutover["state"]?.toString();
    if (restrictMysql && state == "complete" && previousHash == manifestHash) {
      final ownership = await _readEndpointOwnershipState(directory);
      if (managedAppId.isNotEmpty) {
        final api = TidbCloudManagementApi(
          publicKey: managementPublic,
          privateKey: managementPrivate,
        );
        try {
          await _ensureDataSource(
            api,
            appId: managedAppId,
            clusterId: clusterId,
          );
          final synchronized = await _generatedEndpointsAreSynchronized(
            api,
            appId: managedAppId,
            clusterId: clusterId,
            directory: directory,
          );
          if (!ownership.belongsTo(managedAppId) || !synchronized) {
            final nextOwnership = await _upsertManagedEndpoints(
              api,
              appId: managedAppId,
              clusterId: clusterId,
              directory: directory,
            );
            await _deployAndWait(
              api,
              managedAppId,
              synchronized
                  ? "Initialize Katana endpoint ownership."
                  : "Repair missing or drifted Katana endpoints.",
            );
            await _writeEndpointOwnershipState(directory, nextOwnership);
          }
        } finally {
          api.close();
        }
      }
      label("TiDB Data Service-only cutover is already complete.");
      return;
    }
    if (restrictMysql && state == "prepared" && previousHash == manifestHash) {
      final deployed = await _currentWorkerDeploymentId(
        wrangler,
        environment: environment,
      );
      final baseline =
          cutover["baseline_worker_deployment_id"]?.toString() ?? "";
      if (deployed.isEmpty || deployed == baseline) {
        label("TiDB Data Service cutover is waiting for a Worker deployment.");
        stdout.writeln(
          "\nRun `katana cloudflare deploy`, then run `katana apply` again. "
          "The MySQL public endpoint remains enabled.",
        );
        return;
      }
      final api = TidbCloudManagementApi(
        publicKey: managementPublic,
        privateKey: managementPrivate,
      );
      try {
        await _applyAdditiveSchema(
          api,
          appId: dataService["app_id"].toString(),
          clusterId: clusterId,
          region: dataService["region"].toString(),
          directory: directory,
          dataService: dataService,
        );
        final nextOwnership = await _upsertManagedEndpoints(
          api,
          appId: dataService["app_id"].toString(),
          clusterId: clusterId,
          directory: directory,
        );
        await _deployAndWait(
          api,
          dataService["app_id"].toString(),
          "Synchronize Masamune endpoints before cutover.",
        );
        await _writeEndpointOwnershipState(directory, nextOwnership);
      } finally {
        api.close();
      }
      await _finishCutover(
        wrangler: wrangler,
        environment: environment,
        clusterId: clusterId,
        dataService: dataService,
        managementPublic: managementPublic,
        managementPrivate: managementPrivate,
        manifest: manifest,
      );
      cutover["state"] = "complete";
      cutover["worker_deployment_id"] = deployed;
      await saveTidbManagedState(managedState, environment: environment);
      return;
    }

    await addFlutterImport(["masamune_model_tidb"]);
    await addFlutterImport(["masamune_model_tidb_annotation"]);
    await addFlutterImport(
      ["masamune_model_tidb_builder"],
      development: true,
    );

    final api = TidbCloudManagementApi(
      publicKey: managementPublic,
      privateKey: managementPrivate,
    );
    try {
      label("Validate TiDB Data Service cluster.");
      final region = await _validateStarterCluster(
        api,
        projectId: projectId,
        clusterId: clusterId,
      );
      var appId = managedAppId;
      appId = await _ensureDataApp(
        api,
        projectId: projectId,
        clusterId: clusterId,
        appId: appId,
        appName: appName,
      );
      dataService["app_id"] = appId;
      dataService["region"] = region;
      await _ensureDataSource(api, appId: appId, clusterId: clusterId);
      await _ensureDataApiKey(
        api,
        appId: appId,
        rateLimit: rateLimit,
        dataService: dataService,
      );
      await saveTidbManagedState(managedState, environment: environment);
      await _applyAdditiveSchema(
        api,
        appId: appId,
        clusterId: clusterId,
        region: region,
        directory: directory,
        dataService: dataService,
      );
      final nextOwnership = await _upsertManagedEndpoints(
        api,
        appId: appId,
        clusterId: clusterId,
        directory: directory,
      );
      await _deployAndWait(api, appId, "Deploy Masamune endpoints.");
      await _writeEndpointOwnershipState(directory, nextOwnership);
      await _writeDataAppConfig(
        directory: directory,
        appId: appId,
        appName: appName,
        clusterId: clusterId,
      );
      await _copyRuntimeManifest(manifestText);
      if (!await _updateWorkersFunction()) {
        return;
      }
      await _installNodePackage(npm);
      await _putDataServiceSecrets(
        wrangler: wrangler,
        environment: environment,
        appId: appId,
        region: region,
        maxScanRows: maxScanRows,
        dataService: dataService,
      );
      if (!restrictMysql) {
        label("TiDB Data Service is ready; MySQL public access was retained.");
        return;
      }
      final baseline = await _currentWorkerDeploymentId(
        wrangler,
        environment: environment,
      );
      cutover
        ..["manifest_hash"] = manifestHash
        ..["baseline_worker_deployment_id"] = baseline
        ..["state"] = "prepared";
      await saveTidbManagedState(managedState, environment: environment);
      label("TiDB Data Service preparation completed.");
      stdout.writeln(
        "\nThe MySQL public endpoint is still enabled. "
        "Run `katana cloudflare deploy`, then run `katana apply` again "
        "to smoke-test Data Service and disable the public endpoint.",
      );
    } on Object catch (exception) {
      error(
        "TiDB Data Service API automation failed: $exception\n"
        "The MySQL public endpoint was not changed. "
        "You can connect the generated `$directory` CaC directory through "
        "the TiDB Cloud GitHub integration and retry `katana apply`.",
      );
    } finally {
      api.close();
    }
  }

  Future<String> _validateStarterCluster(
    TidbCloudManagementApi api, {
    required String projectId,
    required String clusterId,
  }) async {
    final cluster = await api.starter("GET", "clusters/$clusterId");
    final resolvedClusterId = cluster["clusterId"]?.toString() ??
        cluster["name"]?.toString().split("/").last;
    if (resolvedClusterId != clusterId) {
      throw StateError(
        "Cluster $clusterId is not a supported Starter cluster.",
      );
    }
    final labels = _mapValue(cluster["labels"]);
    final resolvedProjectId = labels["tidb.cloud/project"]?.toString() ??
        cluster["projectId"]?.toString();
    if (resolvedProjectId != null && resolvedProjectId != projectId) {
      throw StateError(
        "Cluster $clusterId belongs to project $resolvedProjectId, "
        "not $projectId.",
      );
    }
    final state = cluster["state"]?.toString().toUpperCase();
    if (state != null && state != "ACTIVE") {
      throw StateError("Cluster $clusterId is not ACTIVE: $state");
    }
    final region = _mapValue(cluster["region"]);
    final regionName = region["name"]?.toString() ?? "";
    if (!regionName.contains("aws-")) {
      throw StateError(
        "Data Service automation currently requires a Starter AWS cluster.",
      );
    }
    return regionName.replaceFirst("regions/", "").replaceFirst("aws-", "");
  }

  Future<String> _ensureDataApp(
    TidbCloudManagementApi api, {
    required String projectId,
    required String clusterId,
    required String appId,
    required String appName,
  }) async {
    if (appId.isNotEmpty) {
      return appId;
    }
    final listed = await api.dataService(
      "GET",
      "dataApps",
      query: {"projectId": projectId, "pageSize": "100"},
    );
    final matches = _listOfMaps(listed["dataApps"])
        .where((item) => item["displayName"] == appName)
        .toList();
    if (matches.length > 1) {
      throw StateError("Multiple Data Apps are named `$appName`.");
    }
    if (matches.length == 1) {
      return matches.single["dataAppId"].toString();
    }
    final created = await api.dataService("POST", "dataApps", body: {
      "version": "1.0.0",
      "projectId": projectId,
      "clusterIds": [clusterId],
      "appType": "DATAAPP",
      "displayName": appName,
      "description": "Managed by Katana CLI.",
    });
    final createdId = created["dataAppId"]?.toString() ?? "";
    if (createdId.isEmpty) {
      throw StateError("Created Data App response did not include dataAppId.");
    }
    return createdId;
  }

  Future<void> _ensureDataSource(
    TidbCloudManagementApi api, {
    required String appId,
    required String clusterId,
  }) async {
    final response = await api.dataService(
      "GET",
      "dataApps/$appId/dataSources",
      query: {"pageSize": "100"},
    );
    final linked = _listOfMaps(response["dataSources"]).any(
      (item) => item["clusterId"]?.toString() == clusterId,
    );
    if (!linked) {
      await api.dataService(
        "POST",
        "dataApps/$appId/dataSources",
        body: {"clusterId": clusterId},
      );
    }
  }

  Future<void> _ensureDataApiKey(
    TidbCloudManagementApi api, {
    required String appId,
    required int rateLimit,
    required Map<String, dynamic> dataService,
  }) async {
    final publicKey = dataService["public_key"]?.toString() ?? "";
    final privateKey = dataService["private_key"]?.toString() ?? "";
    if (publicKey.isNotEmpty && privateKey.isNotEmpty) {
      final apiKeyId = dataService["api_key_id"]?.toString() ?? "";
      if (apiKeyId.isNotEmpty) {
        await api.dataService(
          "PATCH",
          "dataApps/$appId/apiKeys/$apiKeyId",
          body: {
            "description": "Masamune Cloudflare Workers",
            "role": "READ_AND_WRITE",
            "rateLimitRpm": rateLimit,
          },
        );
      }
      return;
    }
    final listed = await api.dataService(
      "GET",
      "dataApps/$appId/apiKeys",
      query: {"pageSize": "100"},
    );
    if (_listOfMaps(listed["apiKeys"]).length >= 100) {
      throw StateError("The Data App already has the maximum 100 API keys.");
    }
    final created = await api.dataService(
      "POST",
      "dataApps/$appId/apiKeys",
      body: {
        "description": "Masamune Cloudflare Workers",
        "role": "READ_AND_WRITE",
        "rateLimitRpm": rateLimit,
      },
    );
    final createdPublic = created["publicKey"]?.toString() ?? "";
    final createdPrivate = created["privateKey"]?.toString() ?? "";
    if (createdPublic.isEmpty || createdPrivate.isEmpty) {
      throw StateError("Created Data API key was not returned.");
    }
    dataService
      ..["api_key_id"] = created["apiKeyId"]?.toString() ?? ""
      ..["public_key"] = createdPublic
      ..["private_key"] = createdPrivate;
  }

  Future<void> _applyAdditiveSchema(
    TidbCloudManagementApi api, {
    required String appId,
    required String clusterId,
    required String region,
    required String directory,
    required Map<String, dynamic> dataService,
  }) async {
    final schema = File("$directory/__masamune/schema.sql");
    if (!schema.existsSync()) {
      throw StateError("Generated additive schema.sql was not found.");
    }
    final migrations = splitTidbAdditiveSchemaMigrations(
      await schema.readAsString(),
    );
    if (migrations.isEmpty) {
      throw StateError("Generated additive schema contains no database.");
    }

    label("Apply additive TiDB schema through temporary table endpoints.");
    const bootstrapPrefix = "/__masamune/bootstrap_";
    final existing = await listTidbDataServicePages(
      api,
      "dataApps/$appId/endpoints",
      "endpoints",
    );
    for (final endpoint in existing.where(
      (item) =>
          (item["path"]?.toString().startsWith(bootstrapPrefix) ?? false) &&
          _managedEndpointTags.contains(item["tag"]),
    )) {
      await deleteTidbDataServiceEndpointAndWait(
        api,
        appId: appId,
        endpointName: endpoint["name"].toString(),
        maxAttempts: 60,
      );
    }

    final endpoints = <({String name, String path})>[];
    Object? failure;
    try {
      for (var index = 0; index < migrations.length; index++) {
        final path = "$bootstrapPrefix${index.toString().padLeft(3, "0")}";
        final created = await _createManagedEndpoint(
          api,
          appId,
          {
            "displayName": "Masamune schema bootstrap ${index + 1}",
            "description": "Temporary additive schema endpoint.",
            "path": path,
            "method": "POST",
            "clusterId": clusterId,
            "params": const [],
            "settings": {
              "timeout": 60000,
              "rowLimit": 1,
              "paginationEnabled": false,
              "cacheEnabled": false,
            },
            "tag": "MasamuneServer",
            "batchOperation": false,
            "sqlTemplate": migrations[index],
          },
        );
        final name = created["name"]?.toString() ?? "";
        if (name.isEmpty) {
          throw StateError("Temporary schema endpoint name was not returned.");
        }
        endpoints.add((name: name, path: path));
      }
      await _deployAndWait(api, appId, "Apply additive Masamune schema.");
      for (final endpoint in endpoints) {
        await retryTidbDataEndpointUntilDeployed(
          () => callTidbDataEndpoint(
            region: region,
            appId: appId,
            path: endpoint.path,
            publicKey: dataService["public_key"].toString(),
            privateKey: dataService["private_key"].toString(),
            method: "POST",
            body: const <String, dynamic>{},
          ),
          maxAttempts: 30,
        );
      }
    } on Object catch (exception) {
      failure = exception;
    } finally {
      for (final endpoint in endpoints) {
        await deleteTidbDataServiceEndpointAndWait(
          api,
          appId: appId,
          endpointName: endpoint.name,
          maxAttempts: 60,
        );
      }
    }
    if (failure != null) {
      throw failure;
    }
  }

  Future<TidbEndpointOwnershipState> _upsertManagedEndpoints(
    TidbCloudManagementApi api, {
    required String appId,
    required String clusterId,
    required String directory,
  }) async {
    label("Upsert generated TiDB Data Service endpoints.");
    final previousOwnership = await _readEndpointOwnershipState(directory);
    final configFile = File("$directory/http_endpoints/config.json");
    final decoded = jsonDecode(await configFile.readAsString());
    if (decoded is! List) {
      throw StateError("http_endpoints/config.json must contain an array.");
    }
    final listed = await listTidbDataServicePages(
      api,
      "dataApps/$appId/endpoints",
      "endpoints",
    );
    final existing = {
      for (final item in listed)
        "${item["method"]?.toString().toUpperCase()}:${item["path"]}": item,
    };
    final existingByName = {
      for (final item in listed)
        if (item["name"]?.toString().isNotEmpty ?? false)
          item["name"].toString(): item,
    };
    final desired = <String>{};
    final nextOwnedEndpoints = <TidbManagedEndpointOwnership>[];
    for (final raw in decoded) {
      final item = _mapValue(raw);
      final method = item["method"].toString().toUpperCase();
      final path = item["endpoint"].toString();
      final key = "$method:$path";
      if (!desired.add(key)) {
        throw StateError("Duplicate generated endpoint: $method $path");
      }
      final current = existing[key];
      if (current != null && !_managedEndpointTags.contains(current["tag"])) {
        throw StateError(
          "Endpoint collision with a non-Masamune endpoint: $method $path",
        );
      }
      final sqlFile = File(
        "$directory/http_endpoints/${item["sql_file"]}",
      );
      final body = _managementEndpointBody(
        item,
        await sqlFile.readAsString(),
        clusterId,
      );
      late Map<String, dynamic> resolved;
      try {
        if (current == null) {
          resolved = await _createManagedEndpoint(api, appId, body);
        } else if (!_endpointMatches(current, body)) {
          await deleteTidbDataServiceEndpointAndWait(
            api,
            appId: appId,
            endpointName: current["name"].toString(),
          );
          resolved = await _createManagedEndpoint(api, appId, body);
        } else {
          resolved = current;
        }
      } on Object catch (exception) {
        throw StateError(
          "Failed to upsert generated endpoint $method $path: $exception",
        );
      }
      final name = resolved["name"]?.toString().trim() ?? "";
      if (name.isEmpty) {
        throw StateError(
          "TiDB did not return the resource name for $method $path.",
        );
      }
      nextOwnedEndpoints.add(
        TidbManagedEndpointOwnership(
          name: name,
          method: method,
          path: path,
        ),
      );
    }

    if (previousOwnership.appId.isNotEmpty &&
        !previousOwnership.belongsTo(appId)) {
      stdout.writeln(
        "[WARN] Ignore TiDB endpoint ownership for "
        "`${previousOwnership.appId}` while applying `$appId`.",
      );
    }
    for (final owned in previousOwnership.staleEndpoints(
      currentAppId: appId,
      desiredKeys: desired,
    )) {
      final current = existingByName[owned.name];
      if (current == null) {
        continue;
      }
      if (!owned.matchesEndpoint(current) ||
          !_managedEndpointTags.contains(current["tag"])) {
        stdout.writeln(
          "[WARN] Skip deleting `${owned.name}` because the remote endpoint "
          "no longer matches its Katana ownership record.",
        );
        continue;
      }
      await deleteTidbDataServiceEndpointAndWait(
        api,
        appId: appId,
        endpointName: owned.name,
      );
    }
    return TidbEndpointOwnershipState(
      appId: appId,
      endpoints: nextOwnedEndpoints,
    );
  }

  Future<bool> _generatedEndpointsAreSynchronized(
    TidbCloudManagementApi api, {
    required String appId,
    required String clusterId,
    required String directory,
  }) async {
    final configFile = File("$directory/http_endpoints/config.json");
    final decoded = jsonDecode(await configFile.readAsString());
    if (decoded is! List) {
      throw StateError("http_endpoints/config.json must contain an array.");
    }
    final listed = await listTidbDataServicePages(
      api,
      "dataApps/$appId/endpoints",
      "endpoints",
    );
    if (!tidbGeneratedEndpointSetIsComplete(decoded, listed)) {
      return false;
    }
    final existing = {
      for (final item in listed)
        "${item["method"]?.toString().toUpperCase()}:${item["path"]}": item,
    };
    for (final raw in decoded) {
      final item = _mapValue(raw);
      final method = item["method"].toString().toUpperCase();
      final path = item["endpoint"].toString();
      final current = existing["$method:$path"];
      if (current == null) {
        return false;
      }
      final sqlFile = File(
        "$directory/http_endpoints/${item["sql_file"]}",
      );
      final desired = _managementEndpointBody(
        item,
        await sqlFile.readAsString(),
        clusterId,
      );
      if (!_endpointMatches(current, desired)) {
        return false;
      }
    }
    return true;
  }

  Future<TidbEndpointOwnershipState> _readEndpointOwnershipState(
    String directory,
  ) async {
    final file = File(
      "$directory/__masamune/deployed_endpoints.json",
    );
    if (!file.existsSync()) {
      return const TidbEndpointOwnershipState.empty();
    }
    try {
      return TidbEndpointOwnershipState.decode(await file.readAsString());
    } on FormatException catch (exception) {
      stdout.writeln(
        "[WARN] Ignore malformed TiDB endpoint ownership state "
        "`${file.path}`: $exception",
      );
      return const TidbEndpointOwnershipState.empty();
    }
  }

  Future<void> _writeEndpointOwnershipState(
    String directory,
    TidbEndpointOwnershipState state,
  ) async {
    final file = File(
      "$directory/__masamune/deployed_endpoints.json",
    );
    await file.parent.create(recursive: true);
    final temporary = File("${file.path}.tmp");
    final backup = File("${file.path}.bak");
    await temporary.writeAsString(state.encode());
    if (file.existsSync()) {
      if (backup.existsSync()) {
        await backup.delete();
      }
      await file.rename(backup.path);
    }
    try {
      await temporary.rename(file.path);
    } on Object {
      if (backup.existsSync()) {
        await backup.rename(file.path);
      }
      rethrow;
    }
    if (backup.existsSync()) {
      await backup.delete();
    }
  }

  Future<Map<String, dynamic>> _createManagedEndpoint(
    TidbCloudManagementApi api,
    String appId,
    Map<String, dynamic> body,
  ) async {
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        return await api.dataService(
          "POST",
          "dataApps/$appId/endpoints",
          body: body,
        );
      } on HttpException catch (exception) {
        if (attempt == 4 ||
            !exception.message.contains(
              "runtime error: invalid memory address or nil pointer dereference",
            )) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
    throw StateError(
        "TiDB Data Service endpoint creation retry was exhausted.");
  }

  bool _endpointMatches(
    Map<String, dynamic> current,
    Map<String, dynamic> desired,
  ) {
    Map<String, dynamic> comparable(Map<String, dynamic> endpoint) {
      final settings = _mapValue(endpoint["settings"]);
      final cacheEnabled = settings["cacheEnabled"] == true;
      return {
        for (final key in [
          "displayName",
          "description",
          "path",
          "method",
          "clusterId",
          "tag",
          "batchOperation",
          "sqlTemplate",
        ])
          key: endpoint[key],
        "params": [
          for (final raw in endpoint["params"] as List? ?? const [])
            {
              for (final key in [
                "name",
                "type",
                "required",
                "defaultValue",
                "description",
              ])
                key: _mapValue(raw)[key],
            },
        ],
        "settings": {
          for (final key in [
            "timeout",
            "rowLimit",
            "paginationEnabled",
            "cacheEnabled",
          ])
            key: settings[key],
          if (cacheEnabled) "cacheTtl": settings["cacheTtl"],
        },
      };
    }

    return jsonEncode(comparable(current)) == jsonEncode(comparable(desired));
  }

  Map<String, dynamic> _managementEndpointBody(
    Map<String, dynamic> item,
    String sql,
    String clusterId,
  ) {
    final settings = _mapValue(item["settings"]);
    final cacheEnabled = settings["cache_enabled"] == 1;
    return {
      "displayName": item["name"],
      "description": item["description"],
      "path": item["endpoint"],
      "method": item["method"],
      "clusterId": clusterId,
      "params": [
        for (final raw in item["params"] as List? ?? const [])
          {
            "name": _mapValue(raw)["name"],
            "type": _mapValue(raw)["type"],
            "required": _mapValue(raw)["required"] == 1,
            "defaultValue": _mapValue(raw)["default"]?.toString() ?? "",
            "description": _mapValue(raw)["description"] ?? "",
          },
      ],
      "settings": {
        "timeout": settings["timeout"] ?? 30000,
        "rowLimit": settings["row_limit"] ?? 2000,
        "paginationEnabled": settings["enable_pagination"] == 1,
        "cacheEnabled": cacheEnabled,
        if (cacheEnabled) "cacheTtl": settings["cache_ttl"] ?? 30,
      },
      "tag": item["tag"] ?? "Masamune",
      "batchOperation": item["batch_operation"] == 1,
      "sqlTemplate": sql,
    };
  }

  Future<void> _deployAndWait(
    TidbCloudManagementApi api,
    String appId,
    String description,
  ) async {
    final deployment = await api.dataService(
      "POST",
      "dataApps/$appId/deployments",
      body: {"description": description},
    );
    final name = deployment["name"]?.toString() ?? "";
    if (name.isEmpty) {
      return;
    }
    for (var attempt = 0; attempt < 30; attempt++) {
      final current = await api.dataService("GET", name);
      final status = current["status"]?.toString().toLowerCase();
      if (status == "success") {
        return;
      }
      if (status == "failed") {
        throw StateError(
          "Data Service deployment failed: "
          "${current["statusErrorMessage"]}",
        );
      }
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    throw StateError("Timed out waiting for Data Service deployment.");
  }

  Future<void> _writeDataAppConfig({
    required String directory,
    required String appId,
    required String appName,
    required String clusterId,
  }) async {
    final configFile = File("$directory/dataapp_config.json");
    final config = _decodeMap(
      await configFile.readAsString(),
      configFile.path,
    );
    config
      ..["app_id"] = appId
      ..["app_name"] = appName;
    await configFile.writeAsString(_prettyJson(config));
    await File("$directory/data_sources/cluster.json").writeAsString(
      _prettyJson([
        {"cluster_id": int.tryParse(clusterId) ?? clusterId},
      ]),
    );
  }

  Future<void> _copyRuntimeManifest(String manifestText) async {
    await File("cloudflare/src/tidb_data_service_manifest.json")
        .writeAsString(manifestText);
  }

  Future<bool> _updateWorkersFunction() async {
    final index = File("cloudflare/src/index.ts");
    var source = await index.readAsString();
    if (!source.contains(
      'import tidbDataServiceManifest from "./tidb_data_service_manifest.json";',
    )) {
      final imports =
          RegExp(r"^import .+;$", multiLine: true).allMatches(source);
      const statement =
          'import tidbDataServiceManifest from "./tidb_data_service_manifest.json";';
      source = imports.isEmpty
          ? "$statement\n$source"
          : source.replaceRange(
              imports.last.end,
              imports.last.end,
              "\n$statement",
            );
      await index.writeAsString(source);
    }
    const function = """
    tidb.Functions.tidb({
        dataServiceManifest: tidbDataServiceManifest as tidb.TidbDataServiceManifest,
    }),""";
    return applyCloudflareWorkersFunctions(
      alias: "tidb",
      package: "@mathrunet/masamune_cloudflare_tidb",
      functions: {"tidb.Functions.tidb": function},
    );
  }

  Future<void> _installNodePackage(String npm) {
    return installMissingCloudflarePackages(
      npm: npm,
      packages: const ["@mathrunet/masamune_cloudflare_tidb"],
    );
  }

  Future<void> _putDataServiceSecrets({
    required String wrangler,
    required String environment,
    required String appId,
    required String region,
    required int maxScanRows,
    required Map<String, dynamic> dataService,
  }) async {
    final values = {
      "TIDB_DATA_SERVICE_APP_ID": appId,
      "TIDB_DATA_SERVICE_REGION": region,
      "TIDB_DATA_SERVICE_PUBLIC_KEY": dataService["public_key"].toString(),
      "TIDB_DATA_SERVICE_PRIVATE_KEY": dataService["private_key"].toString(),
      "TIDB_DATA_SERVICE_MAX_SCAN_ROWS": maxScanRows.toString(),
    };
    for (final entry in values.entries) {
      await putWranglerSecret(
        wrangler: wrangler,
        environment: environment,
        name: entry.key,
        value: entry.value,
      );
    }
  }

  Future<String> _currentWorkerDeploymentId(
    String wrangler, {
    required String environment,
  }) async {
    final result = await Process.run(
      wrangler,
      ["deployments", "list", "--json", "--env", environment],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    if (result.exitCode != 0) {
      throw StateError(
        "Could not list Cloudflare Worker deployments: ${result.stderr}",
      );
    }
    final decoded = jsonDecode(result.stdout.toString());
    final deployments = decoded is List
        ? decoded
        : decoded is Map
            ? decoded["deployments"] as List? ?? const []
            : const [];
    if (deployments.isEmpty) {
      return "";
    }
    final first = _mapValue(deployments.first);
    return (first["id"] ?? first["deployment_id"] ?? first["version_id"])
            ?.toString() ??
        "";
  }

  Future<void> _finishCutover({
    required String wrangler,
    required String environment,
    required String clusterId,
    required Map<String, dynamic> dataService,
    required String managementPublic,
    required String managementPrivate,
    required Map<String, dynamic> manifest,
  }) async {
    final tables = _mapValue(manifest["tables"]);
    if (tables.isEmpty) {
      throw StateError("The generated manifest contains no tables.");
    }
    final list = tables.values
        .map(_mapValue)
        .map((table) => _mapValue(_mapValue(table["endpoints"])["list"]))
        .firstWhere(
          (endpoint) =>
              endpoint["path"] is String &&
              endpoint["path"].toString().isNotEmpty,
          orElse: () => const <String, dynamic>{},
        );
    if (list["path"] is! String || list["path"].toString().isEmpty) {
      throw StateError(
        "At least one generated list endpoint is required for the cutover smoke test.",
      );
    }
    await callTidbDataEndpoint(
      region: dataService["region"].toString(),
      appId: dataService["app_id"].toString(),
      path: list["path"].toString(),
      publicKey: dataService["public_key"].toString(),
      privateKey: dataService["private_key"].toString(),
      query: {"limit": "1"},
    );
    final api = TidbCloudManagementApi(
      publicKey: managementPublic,
      privateKey: managementPrivate,
    );
    try {
      label("Disable the TiDB Starter public endpoint.");
      await api.starter(
        "PATCH",
        "clusters/$clusterId",
        body: {
          "updateMask": "endpoints.public.disabled",
          "cluster": {
            "endpoints": {
              "public": {"disabled": true},
            },
          },
        },
      );
      var disabled = false;
      for (var attempt = 0; attempt < 10; attempt++) {
        final cluster = await api.starter("GET", "clusters/$clusterId");
        final endpoints = _mapValue(cluster["endpoints"]);
        final public = _mapValue(endpoints["public"]);
        if (public["disabled"] == true) {
          disabled = true;
          break;
        }
        await Future<void>.delayed(const Duration(seconds: 2));
      }
      if (!disabled) {
        throw StateError(
          "TiDB did not confirm that the public endpoint was disabled.",
        );
      }
    } finally {
      api.close();
    }
    final listed = await Process.run(
      wrangler,
      ["secret", "list", "--format", "json", "--env", environment],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    if (listed.exitCode != 0) {
      throw StateError(
        "The public endpoint was disabled, but Worker secrets could not "
        "be listed: ${listed.stderr}",
      );
    }
    final workerSecrets = jsonDecode(listed.stdout.toString());
    final names = workerSecrets is List
        ? workerSecrets
            .whereType<Map>()
            .map((item) => item["name"]?.toString())
            .whereType<String>()
            .toSet()
        : <String>{};
    for (final obsolete in const ["TIDB_CONNECTION_URL", "TIDB_MODE"]) {
      if (!names.contains(obsolete)) {
        continue;
      }
      final deleted = await Process.run(
        wrangler,
        ["secret", "delete", obsolete, "--env", environment],
        workingDirectory: "cloudflare",
        runInShell: true,
      );
      if (deleted.exitCode != 0) {
        throw StateError(
          "The public endpoint was disabled, but $obsolete could not be "
          "deleted: ${deleted.stderr}",
        );
      }
    }
    label("TiDB Data Service-only cutover completed.");
  }

  Future<Map<String, dynamic>> _loadSecretsRoot() async {
    final file = File("katana_secrets.yaml");
    if (!file.existsSync()) {
      return {};
    }
    return Map<String, dynamic>.from(
      modifize(loadYaml(await file.readAsString())) as Map? ?? {},
    );
  }

  Future<void> _saveSecretsRoot(Map<String, dynamic> root) {
    return File("katana_secrets.yaml").writeAsString(YamlWriter().write(root));
  }

  Map<String, dynamic> _nested(
    Map<String, dynamic> root,
    List<String> path,
  ) {
    var current = root;
    for (final key in path) {
      final value = current[key];
      current = value is Map
          ? current[key] = Map<String, dynamic>.from(value)
          : current[key] = <String, dynamic>{};
    }
    return current;
  }

  Map<String, dynamic> _decodeMap(String source, String path) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) {
      throw FormatException("$path must contain a JSON object.");
    }
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }

  String _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, "0");
  }

  String _prettyJson(Object value) {
    return "${const JsonEncoder.withIndent("  ").convert(value)}\n";
  }

  Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return {};
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    return value is List ? value.map(_mapValue).toList() : const [];
  }
}
