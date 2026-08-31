// Dart imports:
import "dart:convert";
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";

// Project imports:
import "package:katana_cli/action/cloudflare/tidb.dart";
import "package:katana_cli/action/cloudflare/tidb_data_service_api.dart";
import "package:katana_cli/action/cloudflare/tidb_state.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  final yaml = modifize(loadYaml(await File("katana.yaml").readAsString()));
  final secretsFile = File("katana_secrets.yaml");
  final secrets = secretsFile.existsSync()
      ? modifize(loadYaml(await secretsFile.readAsString()))
      : <String, dynamic>{};
  if (Platform.environment["TIDB_VERIFY"] == "1") {
    final tidb = ((secrets as Map)["cloudflare"] as Map)["tidb"] as Map;
    final management = tidb["management_api"] as Map;
    final config = ((yaml as Map)["cloudflare"] as Map)["tidb"] as Map;
    final managed = await loadAndMigrateTidbManagedState(
      Map<String, dynamic>.from(secrets),
    );
    final dataService = managed.state["data_service"] as Map;
    final api = TidbCloudManagementApi(
      publicKey: management["public_key"].toString(),
      privateKey: management["private_key"].toString(),
    );
    try {
      final cluster = await api.starter(
        "GET",
        "clusters/${config["cluster_id"]}",
      );
      final endpoints = await listTidbDataServicePages(
        api,
        "dataApps/${dataService["app_id"]}/endpoints",
        "endpoints",
      );
      stdout.writeln(
        jsonEncode({
          "publicEndpointDisabled": (((cluster["endpoints"] as Map?)?["public"]
                  as Map?)?["disabled"]) ==
              true,
          "endpointCount": endpoints.length,
          "temporaryEndpointCount": endpoints
              .where(
                (endpoint) =>
                    (endpoint as Map)["path"]
                        ?.toString()
                        .startsWith("/__masamune/") ??
                    false,
              )
              .length,
        }),
      );
    } finally {
      api.close();
    }
    return;
  }
  await const CloudflareTidbCliAction().exec(
    ExecContext(yaml: yaml, secrets: secrets, args: const ["tidb_apply"]),
  );
}
